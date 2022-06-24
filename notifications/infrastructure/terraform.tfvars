## Deployment AWS Profile

aws_profile = "default"

aws_region = "us-east-2"

workspaces = {
  morales = "https://morales-turbot.cloud.turbot-dev.com/"
}

workspace_access_key = {
  morales = "03018bf5-010b-40f7-8ea1-b9c1f6e99b7c"
}

workspace_secret_key = {
  morales = "33183749-4472-4194-a5cb-cef026ab2939"
}

## subnets to deploy lambda (need access to turbot master account & dns)
subnet_ids = [
  "subnet-0dfb2cc4288ebda2c", 
  "subnet-00928f84664aa72c1"
]

security_groups = [
  "sg-0c908bbefd035d6a2"
]

smtp_server = "smtp.va.gov"

