import turbot
import click
from sgqlc.endpoint.http import HTTPEndpoint
from datetime import datetime
import csv
import boto3

@click.command()
@click.option('-p', '--profile', default="default", help="[String] Profile to be used from config file.")
@click.option('-b', '--bucket', default="", help="[String] Name of bucket to upload report to.")

def run_report(profile, bucket):
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
    
    date = datetime.now().strftime("%Y_%m_%d-%I:%M")
    filename = f"instance_report_{profile}_{date}"

    with open(filename, mode='w') as report_file:
        report_writer = csv.writer(report_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        # Header
        report_writer.writerow([
            'Account','Region','VAECID','CKID',
            'Environment','Instance Id','Name',
            'State','Platform','Arch','IP Addr',
            'Image Id','Image Name'
        ])
        for instance in instances:
            name = instance['tags']['Name'] if ('Name' in instance['tags']) else 'Null'
            environment = instance['tags']['vaec:Environment'] if ('vaec:Environment' in instance['tags']) else 'Null'
            vaecid = instance['tags']['vaec:VAECID'] if ('vaec:VAECID' in instance['tags']) else 'Null'
            ckid = instance['tags']['vaec:CKID'] if ('vaec:CKID' in instance['tags']) else 'Null'
            report_writer.writerow([
                f"{instance['turbot']['metadata']['aws']['partition']}:{instance['turbot']['metadata']['aws']['accountId']}",
                instance['turbot']['metadata']['aws']['regionName'],
                vaecid, ckid, environment,
                instance['instance_id'], name,
                instance['state'],
                instance['platform'],
                instance['architecture'],
                instance['ip'],
                instance['image_id'],
                instance['image_name']
            ])
    
    if len(bucket) > 0:
        s3_client = boto3.client('s3')
        try:
            response = s3_client.upload_file(filename, bucket, filename)
        except ClientError as e:
            print(e)
        


if __name__ == "__main__":
    try:
        run_report()
    except Exception as e:
        print(e)