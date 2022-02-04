import turbot
import vaec
import click
from sgqlc.endpoint.http import HTTPEndpoint
import pprint
import time
import subprocess
import os

@click.command()
@click.option('-p', '--profile', default="default", help="[String] Profile to be used from config file.")
@click.option('-c', '--cooldown', default="60", help="[Integer] Seconds to wait between batches.")

def rectify(profile, cooldown):
    config_file = None

    config = turbot.Config(config_file, profile)
    headers = {'Authorization': 'Basic {}'.format(config.auth_token)}
    endpoint = HTTPEndpoint(config.graphql_endpoint, headers)

    query = '''
        query Targets($filter: [String!]!, $paging: String) {
            targets: policyValues(filter: $filter, paging: $paging) {
                items {
                    resource {
                        id: get(path:"turbot.id")
                    }
                    reason
                    turbot {
                        id
                    }
                }
                paging {
                    next
                }
            }
        }
    '''

    mutation = '''
        mutation RunPolicy($input: RunPolicyInput!) {
            runPolicy(input: $input) {
                turbot {
                    id
                }
            }
        }
    '''

    filter = "state:error controlCategoryId:'tmod:@turbot/turbot#/control/categories/resourceTags'"
    paging = None
    print("Starting...")

    while True:
        variables = {'filter': filter, 'paging': paging}
        result = endpoint(query, variables)

        if "errors" in result:
            for error in result['errors']:
                print(error)
            break

        export = 'export PGPASSWORD="$(aws rds generate-db-auth-token --hostname $RDSHOST --port 5432 --region us-gov-west-1 --username turbot )" ; '
                
        for item in result['data']['targets']['items']:
            
            if "reason" in item:
                if item['reason'] == "Bad Request: Expected only 1 winning policy setting for policy":
                    if 'id' in item['resource'] and item['resource']['id'] and len(item['resource']['id']) > 12:
                        print("Rectifying Resource: {}".format(item['resource']['id']))
                        cmd = export + "psql -h $RDSHOST -d turbot -U turbot -c 'select * from rectify_policy_values({}::bigint);'".format(item['resource']['id'])
                        output = subprocess.run(cmd, shell=True)
                        export = ""
                
                else:
                    print("running policy value for: {}".format(item['turbot']['id']))
                    vars = {'input': {'id': item['turbot']['id']}}
                    try:
                        run = endpoint(mutation, vars)
                        print(run)
                    except Exception as e:
                        print(e)

        if not result['data']['targets']['paging']['next']:
            break
        else:
            paging = result['data']['targets']['paging']['next']
        print("Pausing for {} seconds".format(cooldown))
        time.sleep(int(cooldown))

if __name__ == "__main__":
    rectify()