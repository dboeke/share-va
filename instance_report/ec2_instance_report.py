import turbot
import click
from sgqlc.endpoint.http import HTTPEndpoint
import pprint

@click.command()
@click.option('-p', '--profile', default="default", help="[String] Profile to be used from config file.")

def run_report(profile):
    config = turbot.Config(None, profile)
    headers = {'Authorization': 'Basic {}'.format(config.auth_token)}
    endpoint = HTTPEndpoint(config.graphql_endpoint, headers)

    query = '''
        query Instances($filter: [String!]!, $paging: String) {
            instances: resources(filter: $filter, paging: $paging) {
                items {
                    instance_id: get(path: "InstanceId")
                    state: get(path: "State.Name")
                    ip: get(path: "PrivateIpAddress")
                    platform: get(path: "PlatformDetails")
                    architecture: get(path: "Architecture")
                    image_id: get(path: "ImageId")
                    image_name: get(path: "Image.Name")
                    tags
                    turbot {
                        metadata
                    }
                }
                paging {
                    next
                }
            }
        }
    '''

    filter = "resourceTypeId:tmod:@turbot/aws-ec2#/resource/types/instance"
    instances = []
    paging = None
    print("Looking for ec2 instances...")

    while True:
        variables = {'filter': filter, 'paging': paging}
        result = endpoint(query, variables)

        if "errors" in result:
            for error in result['errors']:
                print(error)
            break

        for item in result['data']['instances']['items']:
            instances.append(item)
        if not result['data']['instances']['paging']['next']:
            break
        else:
            print("{} found...".format(len(instances)))
            paging = result['data']['instances']['paging']['next']

    print("\nFound {} Total Instances".format(len(instances)))

    pprint(instances)


if __name__ == "__main__":
    try:
        run_report()
    except Exception as e:
        print(e)