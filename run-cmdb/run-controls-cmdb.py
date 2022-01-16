import turbot
import vaec
import click
from sgqlc.endpoint.http import HTTPEndpoint
import pprint
import time

@click.command()
@click.option('-p', '--profile', default="default", help="[String] Profile to be used from config file.")
@click.option('-s', '--start-index', default=0, help="[Int] Sets the starting point in the returned control collection. All controls starting at the starting point will be run.")
@click.option('-e', '--execute', is_flag=True, help="Will re-run controls when found.")
def run_controls(profile, start_index, execute):
    config_file = None
    batch = 80
    cooldown = 450
    max_batch = -1

    config = turbot.Config(config_file, profile)
    headers = {'Authorization': 'Basic {}'.format(config.auth_token)}
    endpoint = HTTPEndpoint(config.graphql_endpoint, headers)

    query = '''
      query Targets($filter: [String!]!, $paging: String) {
        targets: controls(filter: $filter, paging: $paging) {
          items {
            turbot { id }
            state
          }
          paging {
            next
          }
        }
      }
    '''

    for account, acct_name in vaec.accounts.items():
        print("*****************************")
        print("* Processing {}".format(acct_name))
        print("*****************************")

        filter = "controlTypeId:'tmod:@turbot/aws-ec2#/control/types/instanceCmdb','tmod:@turbot/aws-ec2#/control/types/volumeCmdb' {}".format(account)
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
                targets.append(item)
            if not result['data']['targets']['paging']['next']:
                break
            else:
                print("{} found...".format(len(targets)))
                paging = result['data']['targets']['paging']['next']

        print("\nFound {} Total Targets".format(len(targets)))

        if not execute:
            print("\n --execute flag not set... exiting.")
        else:
            mutation = '''
            mutation RunControl($input: RunControlInput!) {
                runControl(input: $input) {
                turbot {
                    id
                }
                }
            }
            '''

            total_batches = 0
            for index in range(start_index, len(targets)):
                control = targets[index]
                vars = {'input': {'id': control['turbot']['id']}}
                print(vars)
                try:
                    run = endpoint(mutation, vars)
                    print(run)
                except Exception as e:
                    print(e)

                if ((index - start_index + 1) % batch == 0):
                    total_batches = total_batches + 1
                    time.sleep(cooldown)
                    if (total_batches == max_batch):
                        break


if __name__ == "__main__":
    try:
        run_controls()
    except Exception as e:
        print(e)