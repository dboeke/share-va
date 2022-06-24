import os
import json
import boto3
import smtplib
from email.mime.text import MIMEText

def get_param(ssm_client, param_name, encrypted):
  print("in get_param function")
  response = ssm_client.get_parameter(
    Name=param_name,
    WithDecryption=encrypted
  )
  print("after response")
  return response['Parameter']['Value']

def lambda_handler(event, context):
  print("Parse Lambda Params")
  AWS_REGION = os.environ['AWS_REGION']
  SSM_PREFIX = "/turbot/firehose"
  print("Parse SSM Params")
  print("ssm_client")
  ssm_client = boto3.client('ssm')
  smtp_host = get_param(ssm_client, f'{SSM_PREFIX}/vaec/smtp/server/name', False)
  rasp_emails = get_param(ssm_client, f'{SSM_PREFIX}/rasp/workspace/emails', False)
  server = smtplib.SMTP(smtp_host)

  print("Iterate over events")
  for event_record in event['Records']:
    #receipt_handle = event_record['receiptHandle']
    asff_message = json.loads(event_record['body'])
    print("Parsed ASFF:")
    account_id = asff_message['AwsAccountId']

    print ("Sending email")
    FROM = "vaec_turbot_events@va.gov"
    TO = rasp_emails
    MSG = MIMEText(asff_message.as_string())
    MSG['Subject'] = asff_message['Title']
    MSG['From'] = "vaec_turbot_events@va.gov"
    MSG['To'] = ", ".join(rasp_emails)
    server.sendmail(FROM, TO, MSG.as_string())

    print ("Email Sent")
    print(MSG.as_string())

  server.quit()