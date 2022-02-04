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
@click.option('-t', '--timeout', default="10", help="[Integer] Seconds to wait for graphql response")
@click.option('--state-filter', default="", help="[Float] e.g. state:error")

def rectify(profile, cooldown, timeout, state_filter):
    config_file = None

    config = turbot.Config(config_file, profile)
    headers = {'Authorization': 'Basic {}'.format(config.auth_token)}
    endpoint = HTTPEndpoint(config.graphql_endpoint, base_headers=headers, timeout=float(timeout))

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

    filter = "controlCategoryId:'tmod:@turbot/turbot#/control/categories/resourceTags'"
    if len(state_filter):
        filter = f"{state_filter} {filter}"
    print(f"Using filter: {filter}")
    paging = None
    print("Starting...")

    while True:
        variables = {'filter': filter, 'paging': paging}
        result = endpoint(query, variables)

        for item in result['data']['targets']['items']:
            
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