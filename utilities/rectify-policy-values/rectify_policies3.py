import turbot
import vaec
import click
from sgqlc.endpoint.http import HTTPEndpoint
import pprint
import time
import subprocess
import os
import psycopg2
import boto3


@click.command()
@click.option('-p', '--profile', default="default", help="[String] Profile to be used from config file.")
@click.option('-c', '--cooldown', default="60", help="[Integer] Seconds to wait between batches.")
@click.option('--host', help="[String] fully qualified hostname of Turbot RDS instance.")
@click.option('--port', default="5432", help="[Integer] ip port of rds instance.")
@click.option('--region', default="us-gov-west-1", help="[String] region name of instance")
@click.option('--timeout', default="20", help="[Float] how long to wait on graphql call to run policy values")
@click.option('--state-filter', default="", help="[Float] e.g. state:error")


def rectify(profile, cooldown, host, port, region, timeout, state_filter):
    config_file = None
    config = turbot.Config(config_file, profile)
    headers = {'Authorization': 'Basic {}'.format(config.auth_token)}
    endpoint = HTTPEndpoint(config.graphql_endpoint, base_headers=headers, timeout=float(timeout))

    #gets the credentials from .aws/credentials
    session = boto3.Session()
    client = session.client('rds')

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

        if "errors" in result:
            for error in result['errors']:
                print(error)
            break
        
        session = boto3.Session()
        client = session.client('rds')
        token = client.generate_db_auth_token(DBHostname=host, Port=port, DBUsername="turbot", Region=region)

        try:
            conn = psycopg2.connect(host=host, port=port, database="turbot", user="turbot", password=token, sslmode='require', sslrootcert="SSLCERTIFICATE")
            cur = conn.cursor()
        except Exception as e:
            print("Database connection failed due to {}".format(e))    
                
        for item in result['data']['targets']['items']:
            
            if 'id' in item['resource'] and item['resource']['id'] and len(item['resource']['id']) > 12:
                print("Rectifying Resource: {}".format(item['resource']['id']))
                rec_query = "select * from rectify_policy_values({}::bigint);".format(item['resource']['id'])
                cur.execute(rec_query)
                query_results = cur.fetchall()
                print(query_results)
            
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