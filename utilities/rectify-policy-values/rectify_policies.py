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
            }
                paging {
                    next
                }
            }
        }
    '''

    filter = "state:error,tbd controlCategoryId:'tmod:@turbot/turbot#/control/categories/resourceTags'"
    targets = []
    paging = None
    print("Looking for targets...")

    while True:
        variables = {'filter': filter, 'paging': paging}
        result = endpoint(query, variables)

        if "errors" in result:
            for error in result['errors']:
                print(error)
            break

        for item in result['data']['targets']['items']:
            if 'id' in item['resource'] and len(item['resource']['id']) > 12:
                cmd = "psql -h $RDSHOST -d turbot -U turbot -c 'select * from rectify_policy_values({}::bigint);'".format(item['resource']['id'])
                subprocess.run(cmd, shell=True)

        if not result['data']['targets']['paging']['next']:
            break
        else:
            print("{} found...".format(len(targets)))
            paging = result['data']['targets']['paging']['next']
        print("Pausing for {} seconds".format(cooldown))
        time.sleep(cooldown)

if __name__ == "__main__":
    rectify()