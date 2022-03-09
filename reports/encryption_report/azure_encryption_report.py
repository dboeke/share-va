import turbot
import click
from sgqlc.endpoint.http import HTTPEndpoint
from datetime import datetime
import csv
import boto3
from botocore.exceptions import ClientError

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
    date = datetime.now().strftime("%Y_%m_%d_%H_%M") 

    azure_query = '''
        query Disks($filter: [String!]!, $paging: String) {
            disks: resources(filter: $filter, paging: $paging) {
                items {
                    encryption: get(path: "encryption.type")
                    trunk {
                        title
                    }
                    parent {
                        type {
                            category {
                                title
                            }
                        }
                    }
                }
                paging {
                    next
                }
            }
        }
    '''

    az_disk_filter = "resourceId:'210275942479682' resourceTypeId:'tmod:@turbot/azure-compute#/resource/types/disk' resourceTypeLevel:self limit:250"
    az_disk_filter = "resourceId:210275942479682 level:self,descendant resourceTypeId:tmod:@turbot/azure-compute#/resource/types/disk resourceTypeLevel:self,descendant limit:250"
    az_disks = []
    max_len = 0
    paging = None
    print("Looking for Azure Disks...")

    while True:
        variables = {'filter': az_disk_filter, 'paging': paging}
        result = endpoint(azure_query, variables)

        if "errors" in result:
            for error in result['errors']:
                print(error)
            break

        for item in result['data']['disks']['items']:
            trunk = item['trunk']['title'].split(" > ")
            trunk_len = len(trunk)
            if trunk_len > max_len:
                max_len = trunk_len
            if item['encryption'] == 'EncryptionAtRestWithPlatformKey':
                enc_type = 'PlatformKey'
            elif item['encryption'] == 'EncryptionAtRestWithCustomerKey':
                enc_type = 'CustomerKey'
            else:
                enc_type = "Unencrypted"
            az_disks.append({"trunk": trunk, "encryption": enc_type, "parent": item['parent']['type']['category']['title']})
        if not result['data']['disks']['paging']['next']:
            break
        else:
            print("{} found...".format(len(az_disks)))
            paging = result['data']['disks']['paging']['next']

    print("\nFound {} Total Azure Disks".format(len(az_disks)))

    az_report = {}
    start = 3

    for disk in az_disks:
        back = 1
        if disk['parent'] == 'Server':
            back = 2
        depth = len(disk['trunk']) - back
        line = disk['trunk'][start]
        for n in range(start + 1 , max_len - 1):
            if n < depth:
                line = line + "|" + disk['trunk'][n]
            else: 
                line = line + "|"
        if line not in az_report:
            az_report[line] = {'total': 0, 'PlatformKey': 0, 'CustomerKey': 0, 'Unencrypted': 0}
        az_report[line]['total'] = az_report[line]['total'] + 1
        az_report[line][disk['encryption']] = az_report[line][disk['encryption']] + 1
    
    header = ["Azure Resource Group"]
    for n in range(start + 1 , max_len - 1):
        header.append('')
    header.append('Total Disks')
    header.append('PlatformKey')
    header.append('CustomerKey')
    header.append('Unencrypted')

    
    filename = f"azure_disk_encryption_report_{profile}_{date}.csv"
    with open(filename, mode='w') as report_file:
        report_writer = csv.writer(report_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        # Header
        report_writer.writerow(header)
        for rg, data in az_report.items():
            report_line = rg.split("|")
            report_line.append(data['total'])
            report_line.append(data['PlatformKey'])
            report_line.append(data['CustomerKey'])
            report_line.append(data['Unencrypted'])
            report_writer.writerow(report_line)
    
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