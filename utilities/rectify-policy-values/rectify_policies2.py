import turbot
import click
from sgqlc.endpoint.http import HTTPEndpoint
import time
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

    filter = "controlCategoryId:'tmod:@turbot/turbot#/control/categories/resourceTags'"
    if len(state_filter):
        filter = f"{state_filter} {filter}"

    print(f"Using filter: {filter}")
    paging = None
    print("Starting...")

    while True:
        variables = {'filter': filter, 'paging': paging}
        result = endpoint(query, variables)

        session = boto3.Session()
        client = session.client('rds')
        token = client.generate_db_auth_token(DBHostname=host, Port=port, DBUsername="turbot", Region=region)

        try:
            conn = psycopg2.connect(host=host, port=port, database="turbot", user="turbot", password=token, sslmode='require', sslrootcert="SSLCERTIFICATE")
        except Exception as e:
            print("Database connection failed due to {}".format(e))    
                
        for item in result['data']['targets']['items']:
            with conn:
                with conn.cursor() as curs:
                    if 'id' in item['resource'] and item['resource']['id'] and len(item['resource']['id']) > 12:
                        print("Rectifying Resource: {}".format(item['resource']['id']))
                        rec_query = "select * from rectify_policy_values({}::bigint);".format(item['resource']['id'])
                        curs.execute(rec_query)
                        query_results = curs.fetchall()
                        print(query_results)

        if not result['data']['targets']['paging']['next']:
            break
        else:
            paging = result['data']['targets']['paging']['next']

        conn.close()

        print("Pausing for {} seconds".format(cooldown))
        time.sleep(int(cooldown))

if __name__ == "__main__":
    rectify()