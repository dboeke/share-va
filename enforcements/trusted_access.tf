#Smart Folder
resource "turbot_smart_folder" "enforce_public_trusted_access_baseline" {
  parent = "tmod:@turbot/turbot#/"
  title  = "RASP AWS - Public Access"
}

# AWS > Account > Trusted Accounts [Default]
resource "turbot_policy_setting" "aws_trusted_accounts" {
  resource       = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type           = "tmod:@turbot/aws#/policy/types/trustedAccounts"
  template_input = <<EOT
{
account{
 Id
  }
}
EOT
  template       = <<EOT
- "{{ $.account.Id }}" {# Checks for your own account #}
EOT
}

# AWS > VPC > Endpoint > Policy > Trusted Access
resource "turbot_policy_setting" "aws_vpc_internet_vpc_endpoint_policy_trusted_access" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-vpc-internet#/policy/types/vpcEndpointPolicyTrustedAccess"
  value    = "Enforce: Revoke untrusted access"
  # "Skip"
  # "Check: Trusted Access"
  # "Enforce: Revoke untrusted access"
}

# AWS > Lambda > Function > Policy > Trusted Access
resource "turbot_policy_setting" "aws_lambda_function_policy_trusted_access" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-lambda#/policy/types/functionPolicyTrustedAccess"
  value    = "Enforce: Revoke untrusted access"
  # "Skip"
  # "Check: Trusted Access"
  # "Enforce: Revoke untrusted access"
}

# AWS > IAM > Role > Policy > Trusted Access
resource "turbot_policy_setting" "aws_iam_role_policy_trusted_access" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-iam#/policy/types/rolePolicyTrustedAccess"
  value    = "Enforce: Revoke untrusted access"
  # "Skip"
  # "Check: Trusted Access"
  # "Enforce: Revoke untrusted access"
}

# AWS > S3 > Bucket > Policy > Trusted Access
resource "turbot_policy_setting" "aws_s3_bucket_policy_trusted_access" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-s3#/policy/types/bucketPolicyTrustedAccess"
  value    = "Enforce: Revoke untrusted access"
  # "Skip"
  # "Check: Trusted Access"
  # "Enforce: Revoke untrusted access"
}

# AWS > VPC > Default VPC > Approved
resource "turbot_policy_setting" "aws_vpc_core_default_vpc_approved" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-vpc-core#/policy/types/defaultVpcApproved"
  value    = "Enforce: Force delete unapproved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Force delete unapproved"
}

# AWS > VPC > Default VPC > Approved > Usage
resource "turbot_policy_setting" "aws_vpc_core_default_vpc_approved_usage" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-vpc-core#/policy/types/defaultVpcApprovedUsage"
  value    = "Not approved"
  # Not approved
  # Approved
  # Approved if AWS > VPC > Enabled
}

# AWS > S3 > Bucket > Public Access Block
resource "turbot_policy_setting" "aws_s3_s3_bucket_public_access_block" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-s3#/policy/types/s3BucketPublicAccessBlock"
  value    = "Enforce: Per `Public Access Block  > Settings`"
  # "Skip"
  # "Check: Per `Public Access Block  > Settings`"
  # "Enforce: Per `Public Access Block  > Settings`"
}

# AWS > S3 > Account > Public Access Block
resource "turbot_policy_setting" "aws_s3_s3_account_public_access_block" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-s3#/policy/types/s3AccountPublicAccessBlock"
  value    = "Enforce: Per `Public Access Block  > Settings`"
  # "Skip"
  # "Check: Per `Public Access Block  > Settings`"
  # "Enforce: Per `Public Access Block  > Settings`"
}

# AWS > VPC > Internet Gateway > Approved > Usage
resource "turbot_policy_setting" "aws_vpc_internet_internet_gateway_approved_usage" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-vpc-internet#/policy/types/internetGatewayApprovedUsage"
  value    = "Not approved"
  # Not approved
  # Approved
  # Approved if AWS > VPC > Enabled
}

# AWS > VPC > Elastic IP > Approved > Usage
resource "turbot_policy_setting" "aws_vpc_internet_elastic_ip_approved_usage" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-vpc-internet#/policy/types/elasticIpApprovedUsage"
  value    = "Not approved"
  # Not approved
  # Approved
  # Approved if AWS > VPC > Enabled
}

# AWS > EC2 > Classic Load Balancer > Approved
resource "turbot_policy_setting" "aws_ec2_classic_load_balancer_approved" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/classicLoadBalancerApproved"
  value    = "Enforce: Delete unapproved if new"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved if new"
}

# AWS > EC2 > Snapshot > Trusted Access
resource "turbot_policy_setting" "aws_ec2_snapshot_trusted_access" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/snapshotTrustedAccess"
  value    = "Enforce: Trusted Access > Accounts"
  # "Skip"
  # "Check: Trusted Access > Accounts"
  # "Enforce: Trusted Access > Accounts"
}

# AWS > Lambda > Function > Approved > Usage
# resource "turbot_policy_setting" "aws_lambda_function_approved_usage" {
#   resource       = turbot_smart_folder.enforce_public_trusted_access_baseline.id
#   type           = "tmod:@turbot/aws-lambda#/policy/types/functionApprovedUsage"
#   template_input = <<EOT
# {
#     resource {
#       object
#     }
# }
# EOT
#   template       = <<EOT
# {% if 'VpcConfig' in $.resource.object %}
#     Approved
# {% else %}
#     Not approved
# {% endif %}
# EOT
#   # Not approved
#   # Approved
#   # Approved if AWS > Lambda > Enabled
# }

# AWS > EC2 > AMI > Trusted Access
resource "turbot_policy_setting" "aws_ec2_ami_trusted_access" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/amiTrustedAccess"
  value    = "Enforce: Trusted Access > Accounts"
  # "Skip"
  # "Check: Trusted Access > Accounts"
  # "Enforce: Trusted Access > Accounts"
}

# AWS > VPC > Security Group > Ingress Rules > Approved > CIDR Ranges
resource "turbot_policy_setting" "aws_vpc_security_security_group_ingress_rules_approved_cidr_ranges" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-vpc-security#/policy/types/securityGroupIngressRulesApprovedCidrRanges"
  value    = <<EOT
# RFC 1918
- 10.0.0.0/8
- 172.16.0.0/12
- 192.168.0.0/16
EOT
}

# AWS > EC2 > Classic Load Balancer > Approved > Usage
resource "turbot_policy_setting" "aws_ec2_classic_load_balancer_approved_usage" {
  resource       = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type           = "tmod:@turbot/aws-ec2#/policy/types/classicLoadBalancerApprovedUsage"
  template_input = <<EOT
{
  resource {
    scheme: get(path: "Scheme")
  }
}
EOT
  template       = <<EOT
{%- if $.resource.scheme == "internal" -%}
Approved
{%- else -%}
Not approved
{%- endif -%}
EOT
  # Not approved
  # Approved
  # Approved if AWS > EC2 > Enabled
}

# AWS > VPC > Internet Gateway > Approved
resource "turbot_policy_setting" "aws_vpc_internet_internet_gateway_approved" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-vpc-internet#/policy/types/internetGatewayApproved"
  value    = "Enforce: Detach unapproved if new"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Detach unapproved"
  # "Enforce: Detach unapproved if new"
  # "Enforce: Detach and delete unapproved if new"
  # "Enforce: Delete unapproved if new"
}

# AWS > EC2 > Network Load Balancer > Approved > Usage
resource "turbot_policy_setting" "aws_ec2_network_load_balancer_approved_usage" {
  resource       = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type           = "tmod:@turbot/aws-ec2#/policy/types/networkLoadBalancerApprovedUsage"
  template_input = <<EOT
{
  resource {
    scheme: get(path: "Scheme")
  }
}
EOT
  template       = <<EOT
{%- if $.resource.scheme == "internal" -%}
Approved
{%- else -%}
Not approved
{%- endif -%}
EOT
  # Not approved
  # Approved
  # Approved if AWS > EC2 > Enabled
}

# AWS > SNS > Topic > Policy > Trusted Access
resource "turbot_policy_setting" "aws_sns_topic_policy_trusted_access" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-sns#/policy/types/topicPolicyTrustedAccess"
  value    = "Enforce: Revoke untrusted access"
  # "Skip"
  # "Check: Trusted Access"
  # "Enforce: Revoke untrusted access"
}

# AWS > EC2 > Instance > Metadata Service
resource "turbot_policy_setting" "aws_ec2_instance_metadata_service" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/instanceMetadataService"
  value    = "Enforce: Enabled for V1 and V2"
  # "Skip"
  # "Check: Disabled"
  # "Check: Enabled for V1 and V2"
  # "Check: Enabled for V2 only"
  # "Enforce: Disabled"
  # "Enforce: Enabled for V1 and V2"
  # "Enforce: Enabled for V2 only"
}

# AWS > EC2 > Instance > Metadata Service > HTTP Token Hop Limit
# resource "turbot_policy_setting" "aws_ec2_instance_metadata_service_token_hop_limit" {
#   resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
#   type     = "tmod:@turbot/aws-ec2#/policy/types/instanceMetadataServiceTokenHopLimit"
#   value    = 1
# }

# AWS > EC2 > Application Load Balancer > Approved
resource "turbot_policy_setting" "aws_ec2_application_load_balancer_approved" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/applicationLoadBalancerApproved"
  value    = "Enforce: Delete unapproved if new"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved if new"
}

# AWS > S3 > Bucket > Public Access Block > Settings
resource "turbot_policy_setting" "aws_s3_s3_bucket_public_access_block_settings" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-s3#/policy/types/s3BucketPublicAccessBlockSettings"
  value    = <<EOT
- Block Public ACLs
- Block Public Bucket Policies
- Ignore Public ACLs
- Restrict Public Bucket Policies
EOT
  # "Block Public ACLs"
  # "Block Public Bucket Policies"
  # "Ignore Public ACLs"
  # "Restrict Public Bucket Policies"
}

# AWS > VPC > Subnet > Approved
resource "turbot_policy_setting" "aws_vpc_core_subnet_approved" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-vpc-core#/policy/types/subnetApproved"
  value    = "Enforce: Delete unapproved if new"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved if new"
}

# AWS > VPC > Elastic IP > Approved
resource "turbot_policy_setting" "aws_vpc_internet_elastic_ip_approved" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-vpc-internet#/policy/types/elasticIpApproved"
  value    = "Enforce: Detach and delete unapproved if new"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Detach unapproved"
  # "Enforce: Detach unapproved if new"
  # "Enforce: Detach and delete unapproved if new"
  # "Enforce: Delete unapproved if new"
}

# AWS > EC2 > Application Load Balancer > Approved > Usage
resource "turbot_policy_setting" "aws_ec2_application_load_balancer_approved_usage" {
  resource       = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type           = "tmod:@turbot/aws-ec2#/policy/types/applicationLoadBalancerApprovedUsage"
  template_input = <<EOT
{
  resource {
    scheme: get(path: "Scheme")
  }
}
EOT
  template       = <<EOT
{%- if $.resource.scheme == "internal" -%}
Approved
{%- else -%}
Not approved
{%- endif -%}
EOT
  # Not approved
  # Approved
  # Approved if AWS > EC2 > Enabled
}

# AWS > EC2 > Instance > Approved > Public IP
resource "turbot_policy_setting" "aws_ec2_instance_approved_public_ip" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/instanceApprovedPublicIp"
  value    = "Approved if not assigned"
  # "Skip"
  # Approved if assigned
  # Approved if not assigned
}

# AWS > EC2 > Network Load Balancer > Approved
resource "turbot_policy_setting" "aws_ec2_network_load_balancer_approved" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/networkLoadBalancerApproved"
  value    = "Enforce: Delete unapproved if new"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved if new"
}

# AWS > Lambda > Function > Approved
# resource "turbot_policy_setting" "aws_lambda_function_approved" {
#   resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
#   type     = "tmod:@turbot/aws-lambda#/policy/types/functionApproved"
#   value    = "Enforce: Delete unapproved if new"
#   # "Skip"
#   # "Check: Approved"
#   # "Enforce: Delete unapproved if new"
# }

# AWS > S3 > Account > Public Access Block > Settings
resource "turbot_policy_setting" "aws_s3_s3_account_public_access_block_settings" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-s3#/policy/types/s3AccountPublicAccessBlockSettings"
  value    = <<EOT
- Block Public ACLs
- Block Public Bucket Policies
- Ignore Public ACLs
- Restrict Public Bucket Policies
EOT
  # "Block Public ACLs"
  # "Block Public Bucket Policies"
  # "Ignore Public ACLs"
  # "Restrict Public Bucket Policies"
}

# AWS > VPC > Security Group > Ingress Rules > Approved > Rules
resource "turbot_policy_setting" "aws_vpc_security_security_group_ingress_rules_approved_rules" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-vpc-security#/policy/types/securityGroupIngressRulesApprovedRules"
  value    = <<EOT
  REJECT $.turbot.ports.+:22,3389 $.turbot.cidr:0.0.0.0/0,::/0
  APPROVE *
EOT
}

# AWS > VPC > Security Group > Ingress Rules > Approved
resource "turbot_policy_setting" "aws_vpc_security_security_group_ingress_rules_approved" {
  resource = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type     = "tmod:@turbot/aws-vpc-security#/policy/types/securityGroupIngressRulesApproved"
  value    = "Enforce: Delete unapproved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved"
}

# AWS > VPC > Subnet > Approved > Usage
resource "turbot_policy_setting" "aws_vpc_core_subnet_approved_usage" {
  resource       = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type           = "tmod:@turbot/aws-vpc-core#/policy/types/subnetApprovedUsage"
  template_input = <<EOT
{
    resource {
        publicIp: get(path: "MapPublicIpOnLaunch")
    }
}
EOT
  template       = <<EOT
{%- if $.resource.publicIp -%}
    Not approved
{%- else -%}
    Approved
{%- endif -%}
EOT
  # Not approved
  # Approved
  # Approved if AWS > VPC > Enabled
}

# AWS > RDS > DB Instance > Publicly Accessible
resource "turbot_policy_setting" "aws_rds_db_instance_publicly_accessible" {
  resource      = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type          = "tmod:@turbot/aws-rds#/policy/types/dbInstancePubliclyAccessible"
  value         = "Enforce: DB Instance is not publicly accessible"
  # "Skip"
  # "Check: DB Instance is not publicly accessible"
  # "Enforce: DB Instance is not publicly accessible"
}

# AWS > Redshift > Cluster > Publicly Accessible
resource "turbot_policy_setting" "aws_redshift_cluster_publicly_accessible" {
  resource      = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type          = "tmod:@turbot/aws-redshift#/policy/types/clusterPubliclyAccessible"
  value         = "Enforce: Cluster is not publicly accessible"
  # "Skip"
  # "Check: Cluster is not publicly accessible"
  # "Enforce: Cluster is not publicly accessible"
}

# AWS > VPC > Subnet > Auto Assign Public IP
resource "turbot_policy_setting" "aws_vpc_subnet_auto_assign_public_ip" {
  resource      = turbot_smart_folder.enforce_public_trusted_access_baseline.id
  type          = "tmod:@turbot/aws-vpc-core#/policy/types/subnetSetAutoAssignPublicIp"
  value         = "Enforce: Disabled"
  # "Skip"
  # "Check: Auto Assign Public IP"
  # "Check: Enabled"
  # "Check: Disabled"
  # "Enforce: Auto Assign Public IP"
  # "Enforce: Enabled"
  # "Enforce: Disabled"
}