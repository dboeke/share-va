import turbot
import click
from sgqlc.endpoint.http import HTTPEndpoint
from datetime import datetime
import csv
import boto3

@click.command()
@click.option('-p', '--profile', default="default", help="[String] Profile to be used from config file.")
@click.option('-b', '--bucket', default="", help="[String] Name of bucket to upload report to, leave blank to skip upload to s3.")

def run_report(profile, bucket):
    """ Finds resource types by account and reports on encryption compliance. """
    """
    Examples
    ---------------
    Run report in prod:                   "$ python3 encryption_report.py -p prod"
    Run report in prod and upload to s3:  "$ python3 encryption_report.py -p prod -b my_bucket_name"
    """

    config = turbot.Config(None, profile)
    headers = {'Authorization': 'Basic {}'.format(config.auth_token)}
    endpoint = HTTPEndpoint(config.graphql_endpoint, headers)

    account_query = '''
        query Accounts($filter: [String!]!, $paging: String) {
            accounts: resources(filter: $filter, paging: $paging) {
                items {
                    akas
                    metadata
                    sub_name: get(path: "displayName")
                    acct_name: get(path: "AccountAlias")
                }
                paging {
                    next
                }
            }
        }
    '''

    account_filter = "resourceType:tmod:@turbot/azure#/resource/types/subscription,tmod:@turbot/aws#/resource/types/account resourceTypeLevel:self"
    accounts = []
    paging = None
    print("Pulling Account List...")

    while True:
        variables = {'filter': account_filter, 'paging': paging}
        result = endpoint(account_query, variables)

        if "errors" in result:
            for error in result['errors']:
                print(error)
            break

        for item in result['data']['accounts']['items']:
            if "aws" in item['metadata']:
                acct = {
                    "type": "aws",
                    "name": item['acct_name'],
                    "id": item['akas'][0]
                }
            elif "azure" in item['metadata']:
                acct = {
                    "type": "azure",
                    "name": item['sub_name'],
                    "id": item['akas'][0]
                }
            else:
                print(f"metadata error: {item['metadata']}")
                break  
            accounts.append(acct)
        if not result['data']['instances']['paging']['next']:
            break
        else:
            print("{} found...".format(len(accounts)))
            paging = result['data']['accounts']['paging']['next']

    aws_query = '''
        query Instances($filter: [String!]!, $paging: String) {
            instances: resources(filter: $filter, paging: $paging) {
                items {
                    instance_id: get(path: "InstanceId")
                    state: get(path: "State.Name")
                    ip: get(path: "PrivateIpAddress")
                    platform: get(path: "Image.PlatformDetails")
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

    azure_query = '''
        query Disks($filter: [String!]!, $paging: String) {
            disks: resources(filter: $filter, paging: $paging) {
                items {
                    encryption: get(path: "encryption.type")
                    trunk {
                        title(delimiter: "|")
                    }
                }
                paging {
                    next
                }
            }
        }
    '''

    az_vol_filter = "resourceTypeId:'tmod:@turbot/azure-compute#/resource/types/disk'"
    az_disks = []
    az_report = []
    max_len = 0
    paging = None
    print("Looking for Azure Disks...")

    while True:
        variables = {'filter': az_vol_filter, 'paging': paging}
        result = endpoint(azure_query, variables)

        if "errors" in result:
            for error in result['errors']:
                print(error)
            break

        for item in result['data']['disks']['items']:
            trunk = item['trunk']['title'].split("|")
            trunk_len = len(trunk)
            if trunk_len > max_len:
                max_len = trunk_len
            if item['encryption']:
                encrypted = True
            az_disks.append({"trunk": trunk, "encryption": encrypted})
        if not result['data']['disks']['paging']['next']:
            break
        else:
            print("{} found...".format(len(az_disks)))
            paging = result['data']['disks']['paging']['next']

    print("\nFound {} Total Azure Disks".format(len(az_disks)))

    for disk in az_disks:
        depth = len(disk['trunk'])
        for leaf in disk['trunk']:



    
    date = datetime.now().strftime("%Y_%m_%d-%H:%M:%S")
    filename = f"instance_report_{profile}_{date}.csv"

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