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

    key_query = '''
        query Keys($filter: [String!]!, $paging: String) {
            keys: resources(filter: $filter, paging: $paging) {
                items {
                    arn: get(path: "KeyArn")
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

    key_filter = "resourceTypeId:'tmod:@turbot/aws-kms#/resource/types/key' resourceTypeLevel:self title:'alias/aws/ebs' "
    keys = {}
    paging = None
    print("Pulling EBS default key List...")

    while True:
        variables = {'filter': key_filter, 'paging': paging}
        result = endpoint(key_query, variables)

        if "errors" in result:
            for error in result['errors']:
                print(error)
            break

        for item in result['data']['keys']['items']:
            arr_arn = item['arn'].split(":")
            account_arn = ':'.join(arr_arn[0:2]+['']+arr_arn[3:5])
            account_id = ':'.join(arr_arn[1:2]+arr_arn[4:5])
            region = arr_arn[3]
            arr_trunk = item['trunk']['title'].split("|")
            acct_title = arr_trunk[len(arr_trunk)-3]
            acct_folder = arr_trunk[len(arr_trunk)-4]
            keys[account_arn] = {
                "account_id": account_id,
                "region": region,
                "ebs_key": item['arn'],
                "folder": acct_folder,
                "title": acct_title,
                "total": 0,
                "default": 0,
                "cmk": 0,
                "unencrypted": 0
            }
        if not result['data']['keys']['paging']['next']:
            break
        else:
            print("{} found...".format(len(keys)))
            paging = result['data']['keys']['paging']['next']
    
    print("\nFound {} AWS Regions".format(len(keys)))

    aws_vol_query = '''
        query Volumes($filter: [String!]!, $paging: String) {
            volumes: resources(filter: $filter, paging: $paging) {
                items {
                    key: get(path:"KmsKeyId")
                    encrypted: get(path:"Encrypted")
                }
                paging {
                    next
                }
            }
        }
    '''

    for region, key in keys.items():
        aws_vol_filter = f"resourceId:'{region}' resourceTypeId:'tmod:@turbot/aws-ec2#/resource/types/volume' resourceTypeLevel:self"
        paging = None
        count = 0
        print("Looking for volumes in {}...".format(region))

        while True:
            variables = {'filter': aws_vol_filter, 'paging': paging}
            result = endpoint(aws_vol_query, variables)

            if "errors" in result:
                for error in result['errors']:
                    print(error)
                break

            for item in result['data']['volumes']['items']:
                keys[region]['total'] = keys[region]['total'] + 1
                if item['encrypted']:
                    if item['key'] == key['ebs_key']:
                        keys[region]['default'] = keys[region]['default'] + 1
                    else: 
                        keys[region]['cmk'] = keys[region]['cmk'] + 1
                else:
                    keys[region]['unencrypted'] = keys[region]['unencrypted'] + 1
                
            if not result['data']['volumes']['paging']['next']:
                break
            else:
                paging = result['data']['disks']['paging']['next']

        if keys[region]['total'] > 0:
            print("\nFound {} volumes.".format(keys[region]['total']))
    
    filename = f"aws_volume_encryption_report_{profile}_{date}.csv"
    with open(filename, mode='w') as report_file:
        report_writer = csv.writer(report_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        header = ['Account','Region','Group','Title','Total Vol','Default Key','Custom Key','Unencrypted']
        report_writer.writerow(header)
        for region, key in keys.items():
            if key['title'].isnumeric():
                title = ''
            else:
                title = key['title']
            if key['total'] > 0:
                report_writer.writerow([
                    key['account_id'],
                    key['region'],
                    key['folder'],
                    title,
                    key['total'],
                    key['default'],
                    key['cmk'],
                    key['unencrypted']
                ])
    
    if len(bucket) > 0:
        s3_client = boto3.client('s3')
        try:
            response = s3_client.upload_file(filename, bucket, filename)
        except ClientError as e:
            print(e)    

    azure_query = '''
        query Disks($filter: [String!]!, $paging: String) {
            disks: resources(filter: $filter, paging: $paging) {
                items {
                    encryption: get(path: "encryption.type")
                    trunk {
                        title(delimiter: "|")
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

    az_disk_filter = "resourceTypeId:'tmod:@turbot/azure-compute#/resource/types/disk'"
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
            trunk = item['trunk']['title'].split("|")
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