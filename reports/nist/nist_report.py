import turbot
import click
from sgqlc.endpoint.http import HTTPEndpoint
from datetime import datetime
import csv
import boto3
from botocore.exceptions import ClientError
from subprocess import run
import os

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

  sp_config = f'''
connection "aws" {{
  plugin        = "aws"
  secret_key    = "{auth_response['Credentials']['SecretAccessKey']}"
  access_key    = "{auth_response['Credentials']['AccessKeyId']}"
  session_token = "{auth_response['Credentials']['SessionToken']}"
  regions       = ["us-east*"]
}}

'''

  sp_logo = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxMzQ3LjA5NCAyMDIuNTU5Ij48ZGVmcz48c3R5bGU+LmEsLmJ7ZmlsbDojMjIyMDE3O30uYSwuY3tmaWxsLXJ1bGU6ZXZlbm9kZDt9LmN7ZmlsbDojYzcyNTJkO308L3N0eWxlPjwvZGVmcz48cGF0aCBjbGFzcz0iYSIgZD0iTTEzMzMuMiwyMjQuMDUzaDg1Ljc2NFYxOTcuMDI3aC03OS4zNTVhNC4xMzcsNC4xMzcsMCwwLDEtNC4xMjQtNC4xMjN2LTUuNjdIMTM5OC44YTI0Ljc5LDI0Ljc5LDAsMCwwLDI0Ljc0NC0yNC43NDJWMTQ4LjEzMWEyNC43OTEsMjQuNzkxLDAsMCwwLTI0Ljc0NC0yNC43NDJIMTMzMy4yYTI0Ljc5MSwyNC43OTEsMCwwLDAtMjQuNzQ0LDI0Ljc0MnY1MS4xODFhMjQuNzksMjQuNzksMCwwLDAsMjQuNzQ0LDI0Ljc0MVptMi4yODUtNjMuODQ1VjE1NC41NGE0LjEyOSw0LjEyOSwwLDAsMSw0LjEyNC00LjEyM2g1Mi43ODhhNC4xMjksNC4xMjksMCwwLDEsNC4xMjQsNC4xMjN2MS41NDRhNC4xMyw0LjEzLDAsMCwxLTQuMTI0LDQuMTI0WiIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTc2LjQ1MyAtNzIuMjIpIi8+PHBhdGggY2xhc3M9ImEiIGQ9Ik0xMjkzLjg1MSwxNzAuMTV2MjkuNzM5YTI0Ljc4OSwyNC43ODksMCwwLDEtMjQuNzQ1LDI0Ljc0aC02My4zMTl2MzAuOTc4aC0yNy4wMjFWMTQ4LjEzMWEyNC43ODcsMjQuNzg3LDAsMCwxLDI0Ljc0LTI0Ljc0Mmg2NS42YTI0Ljc5MSwyNC43OTEsMCwwLDEsMjQuNzQ1LDI0Ljc0MlYxNzAuMTVabS0zNi4wOCwyNy40NTNoNC45MzFhNC4xMzQsNC4xMzQsMCwwLDAsNC4xMjQtNC4xMjNWMTgwLjcwN2MwLS4yMjcsMC0uNDU3LDAtLjY5VjE3Ny44N2gwdi03LjcyaDB2LTIuMTQ0YzAtLjIzMywwLS40NjUsMC0uNjkyVjE1NC41NGE0LjEzNCw0LjEzNCwwLDAsMC00LjEyNC00LjEyM2gtNTIuNzg4YTQuMTMzLDQuMTMzLDAsMCwwLTQuMTIzLDQuMTIzdjEyLjc3NGMwLC4yMjcsMCwuNDU5LDAsLjY5MnYyLjE0NGgwbDAsMy44NiwwLDMuODZoMHYyLjE0N2wwLC41ODR2MTdoNTEuOThaIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtNzYuNDUzIC03Mi4yMikiLz48cmVjdCBjbGFzcz0iYiIgeD0iMTA2MC42NzciIHk9IjUxLjE2OSIgd2lkdGg9IjI3LjAyOSIgaGVpZ2h0PSIxMDAuNjg4Ii8+PHBhdGggY2xhc3M9ImEiIGQ9Ik0xMTIyLjUyNywxNzAuMTV2MjkuNzM5YTI0Ljc4OCwyNC43ODgsMCwwLDEtMjQuNzQ0LDI0Ljc0aC02My4zMTl2MzAuOTc4aC0yNy4wMjZWMTQ4LjEzMWEyNC43OTIsMjQuNzkyLDAsMCwxLDI0Ljc0NS0yNC43NDJoNjUuNmEyNC43OSwyNC43OSwwLDAsMSwyNC43NDQsMjQuNzQyVjE3MC4xNVpNMTA4Ni40NDQsMTk3LjZoNC45MzVhNC4xMzcsNC4xMzcsMCwwLDAsNC4xMjQtNC4xMjNWMTc3Ljg3aDB2LTcuNzJoMFYxNTQuNTRhNC4xMzcsNC4xMzcsMCwwLDAtNC4xMjQtNC4xMjNoLTUyLjc4OGE0LjEzNyw0LjEzNywwLDAsMC00LjEyNyw0LjEyM3YxNS42MWgwdjcuNzJoMFYxOTcuNmg1MS45OFoiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC03Ni40NTMgLTcyLjIyKSIvPjxwYXRoIGNsYXNzPSJhIiBkPSJNOTEyLjUxNiwxMjMuMzg5aDU1LjU3NmEyNC43OTEsMjQuNzkxLDAsMCwxLDI0Ljc0NCwyNC43NDJ2NzUuOTQ2SDk2NS44MVYxNzcuODdoMGwwLTkuODY0YzAtLjIzMywwLS40NjUsMC0uNjkyVjE1NC41NGE0LjEzNCw0LjEzNCwwLDAsMC00LjEyMy00LjEyM0g5MjYuMDN2NzMuNjZIODk5LjAwNXYtNzMuNjZIODYzLjM0OGE0LjEzNCw0LjEzNCwwLDAsMC00LjEyNCw0LjEyM3YxMi43NzRjMCwuMjI3LDAsLjQ1OSwwLC42OTJsMCw5Ljg2NGgwbDAsNDYuMjA3SDgzMi4yVjE0OC4xMzFhMjQuNzksMjQuNzksMCwwLDEsMjQuNzQtMjQuNzQyaDU1LjU3OFoiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC03Ni40NTMgLTcyLjIyKSIvPjxwYXRoIGNsYXNzPSJhIiBkPSJNNzkyLjg1MiwxMjMuMzg5SDcwNy4wODl2MjcuMDI4aDc5LjM1NGE0LjEzNSw0LjEzNSwwLDAsMSw0LjEyNCw0LjEyM3Y1LjY2OEg3MjcuMjQ5YTI0Ljc5MSwyNC43OTEsMCwwLDAtMjQuNzQ0LDI0Ljc0NnYxNC4zNThhMjQuNzg5LDI0Ljc4OSwwLDAsMCwyNC43NDQsMjQuNzQxaDY1LjZBMjQuNzkxLDI0Ljc5MSwwLDAsMCw4MTcuNiwxOTkuMzEyVjE0OC4xMzFhMjQuNzkyLDI0Ljc5MiwwLDAsMC0yNC43NDUtMjQuNzQyWm0tMi4yODUsNjMuODQ1djUuNjdhNC4xMjgsNC4xMjgsMCwwLDEtNC4xMjQsNC4xMjNINzMzLjY1NWE0LjEyOSw0LjEyOSwwLDAsMS00LjEyMy00LjEyM1YxOTEuMzZhNC4xMzEsNC4xMzEsMCwwLDEsNC4xMjMtNC4xMjZaIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtNzYuNDUzIC03Mi4yMikiLz48cGF0aCBjbGFzcz0iYSIgZD0iTTYwMS4xMzgsMjI0LjA1M0g2ODYuOVYxOTcuMDI3SDYwNy41NDJhNC4xMzcsNC4xMzcsMCwwLDEtNC4xMjQtNC4xMjN2LTUuNjdoNjMuMzJhMjQuNzksMjQuNzksMCwwLDAsMjQuNzQ0LTI0Ljc0MlYxNDguMTMxYTI0Ljc5MSwyNC43OTEsMCwwLDAtMjQuNzQ0LTI0Ljc0MmgtNjUuNmEyNC43OTEsMjQuNzkxLDAsMCwwLTI0Ljc0NywyNC43NDJ2NTEuMTgxYTI0Ljc5MSwyNC43OTEsMCwwLDAsMjQuNzQ3LDI0Ljc0MVptMi4yOC02My44NDVWMTU0LjU0YTQuMTMsNC4xMywwLDAsMSw0LjEyNC00LjEyM2g1Mi43OTJhNC4xMyw0LjEzLDAsMCwxLDQuMTIxLDQuMTIzdjEuNTQ0YTQuMTMxLDQuMTMxLDAsMCwxLTQuMTIxLDQuMTI0WiIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTc2LjQ1MyAtNzIuMjIpIi8+PHBvbHlnb24gY2xhc3M9ImEiIHBvaW50cz0iMzg0Ljg4OSA1MS4xNjkgMzg0Ljg4OSA3OC4zMzggNDIxLjc4NiA3OC4zMzggNDIxLjc4NiAxNTEuODMyIDQ0OS40MzYgMTUxLjgzMiA0NDkuNDM2IDc4LjMzOCA0ODYuMzMxIDc4LjMzOCA0ODYuMzMxIDUxLjE2OSAzODQuODg5IDUxLjE2OSIvPjxwYXRoIGNsYXNzPSJhIiBkPSJNMzkwLjUyNiwxODcuMjM0aC0zMi44YTI0Ljc5LDI0Ljc5LDAsMCwxLTI0Ljc0NS0yNC43NDJWMTQ4LjEzMWEyNC43OTEsMjQuNzkxLDAsMCwxLDI0Ljc0NS0yNC43NDJoODkuMDA5djI3LjAyOGgtODIuNmE0LjEzLDQuMTMsMCwwLDAtNC4xMjQsNC4xMjN2MS41NDRhNC4xMzEsNC4xMzEsMCwwLDAsNC4xMjQsNC4xMjRoNjIuNDQzYTI0Ljc5MiwyNC43OTIsMCwwLDEsMjQuNzQyLDI0Ljc0NnYxNC4zNThhMjQuNzg5LDI0Ljc4OSwwLDAsMS0yNC43NDIsMjQuNzQxaC04OS4wMVYxOTcuMDI3aDgyLjZhNC4xMyw0LjEzLDAsMCwwLDQuMTIzLTQuMTIzVjE5MS4zNmE0LjEzMiw0LjEzMiwwLDAsMC00LjEyMy00LjEyNkgzOTAuNTI2WiIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTc2LjQ1MyAtNzIuMjIpIi8+PHBhdGggY2xhc3M9ImEiIGQ9Ik0xNzAuNDI4LDIyMy43MjNoMGMzLjQyNCwzLjY3Myw4LjY1OSw1LjgxOSwxMS44NzMsMi42bDkuOTQ4LTkuOTUxLDM4LjMwNy0zOC4zYzYuMi02LjItNy41MjItMTkuODgtMTMuNy0xMy42OTNsLTE0LjE0LDE0LjEzNi43MzUuNzMuMDgzLjA4MWE0LjUsNC41LDAsMCwxLS4wODMsNi4yNjNsLS44MjQuODIzLTMuOTk0LDQtMy45LTMuOSwwLDAtMzAtMzAsLjAwNiwwLTMuOS0zLjkxLDQtMy45OTMuODI0LS44MjRhNC40OTIsNC40OTIsMCwwLDEsNi4yNTctLjA3OWwuMDgyLjA3OS43MzcuNzM0LDIxLjI1Mi0yMS4yNDhhMzguOTIsMzguOTIsMCwwLDEsNTQuOTMzLDBsMTguNzcxLDE4Ljc2N2EzOC45NTQsMzguOTU0LDAsMCwxLDAsNTQuOTM3bC00NS40MTYsNDUuNDE4TDIwNS4yLDI2My40NDJhMzguOTQ5LDM4Ljk0OSwwLDAsMS01NC45NDEsMGwtMjMuODI1LTIzLjgzMWE0Ny45Niw0Ny45NiwwLDAsMCw0MS41Mi0xMy40MTNaIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtNzYuNDUzIC03Mi4yMikiLz48cGF0aCBjbGFzcz0iYyIgZD0iTTE4NS4wMzMsMTIzLjI3NmwtLjAwNywwYy0zLjQyMS0zLjY3NS04LjY1Ni01LjgyNC0xMS44NzEtMi42MDhsLTkuOTQ3LDkuOTUtMzguMzA4LDM4LjNjLTYuMiw2LjIsNy41MjEsMTkuODgxLDEzLjcsMTMuN2wxNC4xNC0xNC4xNDItLjczMy0uNzI5LS4wODMtLjA4M2E0LjQ5Myw0LjQ5MywwLDAsMSwuMDgzLTYuMjYybC44MjQtLjgyMiwzLjk5My00LDMuOSwzLjksMCwwLDMwLDMwLS4wMDcsMCwzLjkwNSwzLjkwOC0zLjk5Miw0LS44My44MmE0LjQ5MSw0LjQ5MSwwLDAsMS02LjI1NC4wODFsLS4wODMtLjA4MS0uNzM0LS43MzUtMjEuMjUyLDIxLjI0NmEzOC45MTcsMzguOTE3LDAsMCwxLTU0LjkzNSwwTDg3Ljc4NiwyMDAuOTY3YTM4Ljk1NSwzOC45NTUsMCwwLDEsMC01NC45MzdMMTMzLjIsMTAwLjYxMWwxNy4wNTYtMTcuMDU1YTM4Ljk1NCwzOC45NTQsMCwwLDEsNTQuOTQxLDBsMjMuODI1LDIzLjgzMUE0Ny45NTUsNDcuOTU1LDAsMCwwLDE4Ny41MDYsMTIwLjhaIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtNzYuNDUzIC03Mi4yMikiLz48L3N2Zz4="

  with open("/home/ec2-user/.steampipe/config/aws.spc","w+") as f:
    f.writelines(sp_config)

  os.chdir('./mod')

  print("Running Report...")
  report = run(["steampipe","check","benchmark.nist_800_53_rev_4","--output","html","--progress=false"], capture_output=True).stdout
  print("Formatting Report...")

  report = report.replace(sp_logo, "https://turbot.com/images/turbot-icon-wordmark.svg")
  report = report.replace("steampipe.io", "turbot.com")
  report = report.replace("Steampipe", "Turbot")

  print("Outputting Report...")
  
  with open("../reports/latest_nist.html","w+") as f:
    f.writelines(report)



  
  



if __name__ == "__main__":
    try:
        run_report()
    except Exception as e:
        print(e)