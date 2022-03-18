import turbot
import click
from sgqlc.endpoint.http import HTTPEndpoint
from datetime import datetime
import csv
import boto3
from botocore.exceptions import ClientError

@click.command()
@click.option('-p', '--profile', default="default", help="[String] Profile to be used from config file.")

def run_report(profile):
  config = turbot.Config(None, profile)
  headers = {'Authorization': 'Basic {}'.format(config.auth_token)}
  endpoint = HTTPEndpoint(config.graphql_endpoint, headers)

  accounts = [
    "arn:aws:::899206412154"
  ]

  "tmod:@turbot/aws#/policy/types/turbotIamRole"

  role_query = '''
    query {
      role: policySetting(resourceAka: "arn:aws:::899206412154",uri:"tmod:@turbot/aws#/policy/types/turbotIamRole") {
        value
      }
    }
  '''
  result = endpoint(role_query, {})
  role_arn = result["data"]["role"]["value"]

  extid_query = '''
    query {
      extid: policySetting(resourceAka:"arn:aws:::899206412154",uri:"tmod:@turbot/aws#/policy/types/turbotIamRoleExternalId") {
        value
      }
    }
  '''
  result = endpoint(extid_query, {})
  ext_id = result["data"]["extid"]["value"]

  client = boto3.client('sts')
  auth_response = client.assume_role(
    RoleArn=role_arn,
    RoleSessionName='TurbotNISTReport',
    ExternalId=ext_id,
  )

  print(auth_response)



if __name__ == "__main__":
    try:
        run_report()
    except Exception as e:
        print(e)