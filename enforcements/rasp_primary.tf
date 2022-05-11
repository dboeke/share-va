# Skip enforcements for RASP-PRIMARY

#Smart Folder
resource "turbot_smart_folder" "rasp_primary_skip" {
  parent = "tmod:@turbot/turbot#/"
  title  = "RASP Primary - Enforcement Skips"
}

# AWS > EC2 > Classic Load Balancer Listener > SSL Policy
resource "turbot_policy_setting" "rasp_primary_aws_ec2_classic_load_balancer_listener_ssl_policy" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/classicLoadBalancerListenerSslPolicy"
  value    = "Check: Set in SSL Policy > Allowed"
}


# AWS > EC2 > Load Balancer Listener > SSL Policy
resource "turbot_policy_setting" "rasp_primary_aws_ec2_load_balancer_listener_ssl_policy" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/loadBalancerListenerSslPolicy"
  value    = "Check: Set in SSL Policy > Allowed"
  # "Skip"
  # "Check: Set in SSL Policy > Allowed"
  # "Enforce: Set to SSL Policy > Default"
}

# AWS > KMS > Key > Rotation
resource "turbot_policy_setting" "rasp_primary_aws_kms_key_rotation" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-kms#/policy/types/keyRotation"
  value    = "Check: Enabled"
  # Skip
  # Check: Enabled
  # Check: Disabled
  # Enforce: Enabled
  # Enforce: Disabled
}

# AWS > S3 > Bucket > Encryption in Transit
resource "turbot_policy_setting" "rasp_primary_aws_s3_encryption_in_transit" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-s3#/policy/types/encryptionInTransit"
  value    = "Check: Enabled"
  # "Skip"
  # "Check: Disabled"
  # "Check: Enabled"
  # "Enforce: Disabled"
  # "Enforce: Enabled"
}

# AWS > EC2 > Volume > Approved
resource "turbot_policy_setting" "rasp_primary_aws_ec2_volume_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeApproved"
  value    = "Check: Approved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Detach unapproved if new"
  # "Enforce: Detach, snapshot and delete unapproved if new"
}

# AWS > EC2 > Snapshot > Approved
resource "turbot_policy_setting" "rasp_primary_aws_ec2_snapshot_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/snapshotApproved"
  value    = "Check: Approved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved if new"
}

# AWS > S3 > Bucket > Encryption at Rest
resource "turbot_policy_setting" "rasp_primary_aws_s3_bucket_encryption_at_rest" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-s3#/policy/types/bucketEncryptionAtRest"
  value    = "Check: AWS SSE or higher"
}

# AWS > SNS > Topic > Encryption at Rest
resource "turbot_policy_setting" "rasp_primary_aws_sns_topic_encryption_at_rest" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-sns#/policy/types/topicEncryptionAtRest"
  value    = "Check: AWS managed key or higher"
}

# AWS > Logs > Log Group > Encryption at Rest
resource "turbot_policy_setting" "rasp_primary_aws_logs_log_group_encryption_at_rest" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-logs#/policy/types/logGroupEncryptionAtRest"
  value    = "Check: AWS SSE or higher"
}

# AWS > Lambda > Function > Encryption at Rest
resource "turbot_policy_setting" "rasp_primary_aws_lambda_function_encryption_at_rest" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-lambda#/policy/types/functionEncryptionAtRest"
  value    = "Check: AWS managed key or higher"
}

# AWS > EC2 > Instance > Approved
resource "turbot_policy_setting" "rasp_primary_aws_ec2_instance_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/instanceApproved"
  value    = "Check: Approved"
}

# AWS > RDS > DB Instance > Approved
resource "turbot_policy_setting" "rasp_primary_aws_rds_db_instance_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-rds#/policy/types/dbInstanceApproved"
  value    = "Check: Approved"
}


# AWS > ElastiCache > Cache Cluster > Approved
resource "turbot_policy_setting" "rasp_primary_aws_elasticache_cluster_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-elasticache#/policy/types/cacheClusterApproved"
  value    = "Check: Approved"
}

# AWS > DynamoDB > Table > Encryption at Rest
resource "turbot_policy_setting" "rasp_primary_aws_dynamodb_table_encryption_at_rest" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-dynamodb#/policy/types/tableEncryptionAtRest"
  value    = "Check: AWS managed key or higher"
}

resource "turbot_policy_setting" "rasp_primary_aws_ec2_ec2_account_attributes_ebs_encryption_by_default" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/ec2AccountAttributesEbsEncryptionByDefault"
  value    = "Check: AWS managed key or higher"
}

resource "turbot_policy_setting" "rasp_primary_loggingBucket" {
  resource    = turbot_smart_folder.rasp_primary_skip.id
  type        = "tmod:@turbot/aws#/policy/types/loggingBucket"
  value       = "Skip"
}

# AWS > IAM > Group > Inline Policy > Statements > Approved
resource "turbot_policy_setting" "rasp_primary_aws_iam_group_inline_policy_statements_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-iam#/policy/types/groupInlinePolicyApproved"
  value    = "Check: Approved"
}

# AWS > IAM > Group > Policy Attachments > Approved
resource "turbot_policy_setting" "rasp_primary_aws_iam_group_policy_attachments_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-iam#/policy/types/groupPolicyAttachmentsApproved"
  value    = "Check: Approved"
}

# AWS > IAM > Policy > Approved
resource "turbot_policy_setting" "rasp_primary_aws_iam_iam_policy_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-iam#/policy/types/iamPolicyApproved"
  value    = "Check: Approved"
}

# AWS > IAM > Role > Inline Policy > Statements > Approved
resource "turbot_policy_setting" "rasp_primary_aws_iam_role_inline_policy_statements_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-iam#/policy/types/roleInlinePolicyStatementsApproved"
  value    = "Check: Approved"
}

# AWS > IAM > Role > Policy Attachments > Approved
resource "turbot_policy_setting" "rasp_primary_aws_iam_role_policy_attachments_approved" {
  resource       = turbot_smart_folder.rasp_primary_skip.id
  type           = "tmod:@turbot/aws-iam#/policy/types/rolePolicyAttachmentsApproved"
  template_input = <<-EOT
    { role {
        RoleName
      }
    }
    EOT
  template       = <<-EOT
    {%- set result = "Check: Approved" -%}
    {%- if "stacksets-exec-" in $.role.RoleName -%}
      {%- set result = "Check: Approved" -%}
    {%- endif -%}
    {%- set exceptions = ["rasp-turbot", "stacksets-exec-a9bbdd7355b92f17da388f219a9ce137", "adfs-g-rasp-primary-limited-admin"] -%}
    {%- if $.role.RoleName in exceptions -%}
      {%- set result = "Skip" -%}
    {%- endif -%}
    {{ result }}
    EOT
}


# AWS > IAM > User > Approved
resource "turbot_policy_setting" "rasp_primary_aws_iam_user_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-iam#/policy/types/userApproved"
  value    = "Check: Approved"
}

# AWS > IAM > User > Inline Policy > Statements > Approved
resource "turbot_policy_setting" "rasp_primary_aws_iam_user_inline_policy_statements_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-iam#/policy/types/userInlinePolicyStatementsApproved"
  value    = "Check: Approved"
}

# AWS > IAM > User > Policy Attachments > Approved
resource "turbot_policy_setting" "rasp_primary_aws_iam_user_policy_attachments_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-iam#/policy/types/userPolicyAttachmentsApproved"
  value    = "Check: Approved"
}

# AWS > IAM > Access Key > Active
resource "turbot_policy_setting" "rasp_primary_aws_iam_access_key_active" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accessKeyActive"
  value    = "Check: Active"
}

resource "turbot_policy_setting" "rasp_primary_aws_iam_credential_report_cmdb" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-iam#/policy/types/credentialReportCmdb"
  value    = "Check: Enabled"
}

# AWS > IAM > Account Password Policy > Settings
resource "turbot_policy_setting" "rasp_primary_aws_iam_account_password_policy_settings" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettings"
  value    = "Check: Configured"
}

resource "turbot_policy_setting" "rasp_primary_aws_ec2_volume_active" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeActive"
  value    = "Check: Active"
}

#######

# AWS > VPC > Endpoint > Policy > Trusted Access
resource "turbot_policy_setting" "rasp_primary_aws_vpc_internet_vpc_endpoint_policy_trusted_access" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-vpc-internet#/policy/types/vpcEndpointPolicyTrustedAccess"
  value    = "Check: Trusted Access"
}

# AWS > Lambda > Function > Policy > Trusted Access
resource "turbot_policy_setting" "rasp_primary_aws_lambda_function_policy_trusted_access" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-lambda#/policy/types/functionPolicyTrustedAccess"
  value    = "Check: Trusted Access"
}

# AWS > IAM > Role > Policy > Trusted Access
resource "turbot_policy_setting" "rasp_primary_aws_iam_role_policy_trusted_access" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-iam#/policy/types/rolePolicyTrustedAccess"
  value    = "Check: Trusted Access"
}

# AWS > S3 > Bucket > Policy > Trusted Access
resource "turbot_policy_setting" "rasp_primary_aws_s3_bucket_policy_trusted_access" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-s3#/policy/types/bucketPolicyTrustedAccess"
  value    = "Check: Trusted Access"
}

# AWS > VPC > Default VPC > Approved
resource "turbot_policy_setting" "rasp_primary_aws_vpc_core_default_vpc_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-vpc-core#/policy/types/defaultVpcApproved"
  value    = "Check: Approved"
}

# AWS > S3 > Bucket > Public Access Block
resource "turbot_policy_setting" "rasp_primary_aws_s3_s3_bucket_public_access_block" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-s3#/policy/types/s3BucketPublicAccessBlock"
  value    = "Check: Per `Public Access Block  > Settings`"
}

# AWS > S3 > Account > Public Access Block
resource "turbot_policy_setting" "rasp_primary_aws_s3_s3_account_public_access_block" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-s3#/policy/types/s3AccountPublicAccessBlock"
  value    = "Check: Per `Public Access Block  > Settings`"
}

# AWS > EC2 > Classic Load Balancer > Approved
resource "turbot_policy_setting" "rasp_primary_aws_ec2_classic_load_balancer_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/classicLoadBalancerApproved"
  value    = "Check: Approved"
}

# AWS > EC2 > Snapshot > Trusted Access
resource "turbot_policy_setting" "rasp_primary_aws_ec2_snapshot_trusted_access" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/snapshotTrustedAccess"
  value    = "Check: Trusted Access > Accounts"
}

# AWS > EC2 > AMI > Trusted Access
resource "turbot_policy_setting" "rasp_primary_aws_ec2_ami_trusted_access" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/amiTrustedAccess"
  value    = "Check: Trusted Access > Accounts"
}

# AWS > VPC > Internet Gateway > Approved
resource "turbot_policy_setting" "rasp_primary_aws_vpc_internet_internet_gateway_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-vpc-internet#/policy/types/internetGatewayApproved"
  value    = "Check: Approved"
}

# AWS > SNS > Topic > Policy > Trusted Access
resource "turbot_policy_setting" "rasp_primary_aws_sns_topic_policy_trusted_access" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-sns#/policy/types/topicPolicyTrustedAccess"
  value    = "Check: Trusted Access"
}

# AWS > EC2 > Instance > Metadata Service
resource "turbot_policy_setting" "rasp_primary_aws_ec2_instance_metadata_service" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/instanceMetadataService"
  value    = "Check: Enabled for V2 only"
}


# AWS > EC2 > Application Load Balancer > Approved
resource "turbot_policy_setting" "rasp_primary_aws_ec2_application_load_balancer_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/applicationLoadBalancerApproved"
  value    = "Check: Approved"
}

# AWS > VPC > Subnet > Approved
resource "turbot_policy_setting" "rasp_primary_aws_vpc_core_subnet_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-vpc-core#/policy/types/subnetApproved"
  value    = "Check: Approved"
}

# AWS > VPC > Elastic IP > Approved
resource "turbot_policy_setting" "rasp_primary_aws_vpc_internet_elastic_ip_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-vpc-internet#/policy/types/elasticIpApproved"
  value    = "Check: Approved"
}

# AWS > EC2 > Network Load Balancer > Approved
resource "turbot_policy_setting" "rasp_primary_aws_ec2_network_load_balancer_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/networkLoadBalancerApproved"
  value    = "Check: Approved"
}

# AWS > Lambda > Function > Approved
resource "turbot_policy_setting" "rasp_primary_aws_lambda_function_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-lambda#/policy/types/functionApproved"
  value    = "Skip"
}

# AWS > VPC > Security Group > Ingress Rules > Approved
resource "turbot_policy_setting" "rasp_primary_aws_vpc_security_security_group_ingress_rules_approved" {
  resource = turbot_smart_folder.rasp_primary_skip.id
  type     = "tmod:@turbot/aws-vpc-security#/policy/types/securityGroupIngressRulesApproved"
  value    = "Check: Approved"
}

# AWS > RDS > DB Instance > Publicly Accessible
resource "turbot_policy_setting" "rasp_primary_aws_rds_db_instance_publicly_accessible" {
  resource      = turbot_smart_folder.rasp_primary_skip.id
  type          = "tmod:@turbot/aws-rds#/policy/types/dbInstancePubliclyAccessible"
  value         = "Check: DB Instance is not publicly accessible"
}

# AWS > Redshift > Cluster > Publicly Accessible
resource "turbot_policy_setting" "rasp_primary_aws_redshift_cluster_publicly_accessible" {
  resource      = turbot_smart_folder.rasp_primary_skip.id
  type          = "tmod:@turbot/aws-redshift#/policy/types/clusterPubliclyAccessible"
  value         = "Check: Cluster is not publicly accessible"
}

# AWS > VPC > Subnet > Auto Assign Public IP
resource "turbot_policy_setting" "rasp_primary_aws_vpc_subnet_auto_assign_public_ip" {
  resource      = turbot_smart_folder.rasp_primary_skip.id
  type          = "tmod:@turbot/aws-vpc-core#/policy/types/subnetSetAutoAssignPublicIp"
  value         = "Check: Disabled"
}
