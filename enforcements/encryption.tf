# Encryption controls commonly used

#Smart Folder
resource "turbot_smart_folder" "enforce_encryption_baseline" {
  parent = "tmod:@turbot/turbot#/"
  title  = "RASP AWS - Encryption"
}

# AWS > EC2 > Classic Load Balancer Listener > SSL Policy
resource "turbot_policy_setting" "aws_ec2_classic_load_balancer_listener_ssl_policy" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/classicLoadBalancerListenerSslPolicy"
  value    = "Enforce: Set to SSL Policy > Default"
  # "Skip"
  # "Check: Set in SSL Policy > Allowed"
  # "Enforce: Set to SSL Policy > Default"
}

# AWS > EC2 > Classic Load Balancer Listener > SSL Policy > Allowed
resource "turbot_policy_setting" "aws_ec2_classic_load_balancer_listener_ssl_policy_allowed" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/classicLoadBalancerListenerSslPolicyAllowed"
  value    = <<-EOT
    - ELBSecurityPolicy-TLS-1-2-2017-01
    EOT
  # "Custom"
  # "ELBSample-ELBDefaultNegotiationPolicy"
  # "ELBSample-OpenSSLDefaultNegotiationPolicy"
  # "ELBSecurityPolicy-2011-08"
  # "ELBSecurityPolicy-2014-01"
  # "ELBSecurityPolicy-2014-10"
  # "ELBSecurityPolicy-2015-02"
  # "ELBSecurityPolicy-2015-03"
  # "ELBSecurityPolicy-2015-05"
  # "ELBSecurityPolicy-2016-08"
  # "ELBSecurityPolicy-TLS-1-1-2017-01"
  # "ELBSecurityPolicy-TLS-1-2-2017-01"
}

resource "turbot_policy_setting" "aws_ec2_classic_load_balancer_listener_ssl_policy_default" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/classicLoadBalancerListenerSslPolicyDefault"
  value    = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

# AWS > EC2 > Load Balancer Listener > SSL Policy
resource "turbot_policy_setting" "aws_ec2_load_balancer_listener_ssl_policy" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/loadBalancerListenerSslPolicy"
  value    = "Enforce: Set to SSL Policy > Default"
  # "Skip"
  # "Check: Set in SSL Policy > Allowed"
  # "Enforce: Set to SSL Policy > Default"
}

resource "turbot_policy_setting" "aws_ec2_load_balancer_listener_ssl_policy_default" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/loadBalancerListenerSslPolicyDefault"
  value    = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
}

# AWS > EC2 > Load Balancer Listener > SSL Policy > Allowed
resource "turbot_policy_setting" "aws_ec2_load_balancer_listener_ssl_policy_allowed" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/loadBalancerListenerSslPolicyAllowed"
  value    = <<-EOT
    - ELBSecurityPolicy-FS-1-2-2019-08
    - ELBSecurityPolicy-FS-1-2-Res-2019-08
    - ELBSecurityPolicy-FS-1-2-Res-2020-10
    EOT
  # "ELBSecurityPolicy-2015-05"
  # "ELBSecurityPolicy-2016-08"
  # "ELBSecurityPolicy-FS-1-1-2019-08"
  # "ELBSecurityPolicy-FS-1-2-2019-08"
  # "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  # "ELBSecurityPolicy-FS-2018-06"
  # "ELBSecurityPolicy-TLS-1-0-2015-04"
  # "ELBSecurityPolicy-TLS-1-1-2017-01"
  # "ELBSecurityPolicy-TLS-1-2-2017-01"
  # "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}

# AWS > KMS > Key > Rotation
resource "turbot_policy_setting" "aws_kms_key_rotation" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-kms#/policy/types/keyRotation"
  value    = "Enforce: Enabled"
  # Skip
  # Check: Enabled
  # Check: Disabled
  # Enforce: Enabled
  # Enforce: Disabled
}

# AWS > EC2 > Snapshot > Approved > Encryption at Rest
resource "turbot_policy_setting" "aws_ec2_snapshot_encryption_at_rest" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/snapshotEncryptionAtRest"
  value    = "AWS managed key or higher"
  # "None"
  # "None or higher"
  # "AWS managed key"
  # "AWS managed key or higher"
  # "Customer managed key"
  # "Encryption at Rest > Customer Managed Key"
}

# AWS > S3 > Bucket > Encryption in Transit
resource "turbot_policy_setting" "aws_s3_encryption_in_transit" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-s3#/policy/types/encryptionInTransit"
  value    = "Enforce: Enabled"
  # "Skip"
  # "Check: Disabled"
  # "Check: Enabled"
  # "Enforce: Disabled"
  # "Enforce: Enabled"
}

# AWS > EC2 > Volume > Approved > Encryption at Rest
resource "turbot_policy_setting" "aws_ec2_volume_encryption_at_rest" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeEncryptionAtRest"
  value    = "AWS managed key or higher"
  # "None"
  # "None or higher"
  # "AWS managed key"
  # "AWS managed key or higher"
  # "Customer managed key"
  # "Encryption at Rest > Customer Managed Key"
}

# AWS > EC2 > Instance > Approved > Root Volume Encryption at Rest
resource "turbot_policy_setting" "aws_ec2_root_volume_encryption_at_rest" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/rootVolumeEncryptionAtRest"
  value    = "AWS managed key or higher"
  # "None"
  # "None or higher"
  # "AWS managed key"
  # "AWS managed key or higher"
  # "Customer managed key"
  # "Encryption at Rest > Customer Managed Key"
}

# AWS > EC2 > Volume > Approved
resource "turbot_policy_setting" "aws_ec2_volume_approved" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeApproved"
  value    = "Enforce: Detach, snapshot and delete unapproved if new"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Detach unapproved if new"
  # "Enforce: Detach, snapshot and delete unapproved if new"
}

# AWS > EC2 > Snapshot > Approved
resource "turbot_policy_setting" "aws_ec2_snapshot_approved" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/snapshotApproved"
  value    = "Enforce: Delete unapproved if new"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved if new"
}

# AWS > CloudTrail > Trail > Encryption at Rest
resource "turbot_policy_setting" "aws_cloudtrail_trail_encryption_at_rest" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-cloudtrail#/policy/types/trailEncryptionAtRest"
  value    = "Skip"
  # "Skip"
  # "Check: None"
  # "Check: None or higher"
  # "Check: Customer managed key"
  # "Check: Encryption at Rest > Customer Managed Key"
  # "Enforce: None"
  # "Enforce: Customer managed key"
  # "Enforce: Encryption at Rest > Customer Managed Key"
}

# AWS > S3 > Bucket > Encryption at Rest
resource "turbot_policy_setting" "aws_s3_bucket_encryption_at_rest" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-s3#/policy/types/bucketEncryptionAtRest"
  value    = "Enforce: AWS SSE or higher"
  # "Skip"
  # "Check: None"
  # "Check: None or higher"
  # "Check: AWS SSE"
  # "Check: AWS SSE or higher"
  # "Check: AWS managed key"
  # "Check: AWS managed key or higher"
  # "Check: Customer managed key"
  # "Check: Encryption at Rest > Customer Managed Key"
  # "Enforce: None"
  # "Enforce: None or higher"
  # "Enforce: AWS SSE"
  # "Enforce: AWS SSE or higher"
  # "Enforce: AWS managed key"
  # "Enforce: AWS managed key or higher"
  # "Enforce: Customer managed key"
  # "Enforce: Encryption at Rest > Customer Managed Key"
}

# AWS > SNS > Topic > Encryption at Rest
resource "turbot_policy_setting" "aws_sns_topic_encryption_at_rest" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-sns#/policy/types/topicEncryptionAtRest"
  value    = "Enforce: AWS managed key or higher"
  # "Skip"
  # "Check: None"
  # "Check: None or higher"
  # "Check: AWS managed key"
  # "Check: AWS managed key or higher"
  # "Check: Customer managed key"
  # "Check: Encryption at Rest > Customer Managed Key"
  # "Enforce: None"
  # "Enforce: AWS managed key"
  # "Enforce: AWS managed key or higher"
  # "Enforce: Customer managed key"
  # "Enforce: Encryption at Rest > Customer Managed Key"
}

# AWS > Logs > Log Group > Encryption at Rest
resource "turbot_policy_setting" "aws_logs_log_group_encryption_at_rest" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-logs#/policy/types/logGroupEncryptionAtRest"
  value    = "Enforce: AWS SSE or higher"
  # "Skip"
  # "Check: AWS SSE"
  # "Check: AWS SSE or higher"
  # "Check: Customer managed key"
  # "Check: Encryption at Rest > Customer Managed Key"
  # "Enforce: AWS SSE"
  # "Enforce: AWS SSE or higher"
  # "Enforce: Customer managed key"
  # "Enforce: Encryption at Rest > Customer Managed Key"
}

# AWS > Lambda > Function > Encryption at Rest
resource "turbot_policy_setting" "aws_lambda_function_encryption_at_rest" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-lambda#/policy/types/functionEncryptionAtRest"
  value    = "Enforce: AWS managed key or higher"
  # "Skip"
  # "Check: AWS managed key"
  # "Check: AWS managed key or higher"
  # "Check: Customer managed key"
  # "Check: Encryption at Rest > Customer Managed Key"
  # "Enforce: AWS managed key"
  # "Enforce: AWS managed key or higher"
  # "Enforce: Customer managed key"
  # "Enforce: Encryption at Rest > Customer Managed Key"
}

# AWS > EC2 > Instance > Approved
resource "turbot_policy_setting" "aws_ec2_instance_approved" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/instanceApproved"
  value    = "Enforce: Stop unapproved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Stop unapproved"
  # "Enforce: Stop unapproved if new"
  # "Enforce: Delete unapproved if new"
}

# AWS > RDS > DB Instance > Approved
resource "turbot_policy_setting" "aws_rds_db_instance_approved" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-rds#/policy/types/dbInstanceApproved"
  value    = "Enforce: Stop unapproved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Stop unapproved"
  # "Enforce: Stop unapproved if new"
  # "Enforce: Snapshot and delete unapproved if new"
}

# AWS > RDS > DB Instance > Approved > Encryption at Rest
resource "turbot_policy_setting" "aws_rds_encryption_at_rest" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-rds#/policy/types/dbInstanceEncryptionAtRest"
  value    = "AWS managed key or higher"
  # "None"
  # "None or higher"
  # "AWS managed key"
  # "AWS managed key or higher"
  # "Customer managed key"
  # "Encryption at Rest > Customer Managed Key"
}

# AWS > ElastiCache > Cache Cluster > Approved
resource "turbot_policy_setting" "aws_elasticache_cluster_approved" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-elasticache#/policy/types/cacheClusterApproved"
  value    = "Enforce: Delete unapproved if new"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved if new"
}

# AWS > ElastiCache > Cache Cluster > Approved > Usage
resource "turbot_policy_setting" "aws_elasticache_cluster_approved_usage" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-elasticache#/policy/types/cacheClusterApprovedUsage"
  template_input = <<EOF
  {
    resource {
      transit: get(path: "TransitEncryptionEnabled")
      atRest: get(path: "AtRestEncryptionEnabled")
    }
  }
  EOF
  template = <<EOF
  {%- if $.resource.transit == true and $.resource.atRest == true -%}
  "Approved"
  {%- else -%}
  "Not approved"
  {%- endif -%}
  EOF
}

# AWS > DynamoDB > Table > Encryption at Rest
resource "turbot_policy_setting" "aws_dynamodb_table_encryption_at_rest" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-dynamodb#/policy/types/tableEncryptionAtRest"
  value    = "Enforce: AWS managed key or higher"
  # "Skip"
  # "Check: AWS owned key"
  # "Check: AWS owned key or higher"
  # "Check: AWS managed key"
  # "Check: AWS managed key or higher"
  # "Check: Customer managed key"
  # "Check: Encryption at Rest > Customer Managed Key"
  # "Enforce: AWS owned key"
  # "Enforce: AWS owned key or higher"
  # "Enforce: AWS managed key"
  # "Enforce: AWS managed key or higher"
  # "Enforce: Customer managed key"
  # "Enforce: Encryption at Rest > Customer Managed Key"
}

resource "turbot_policy_setting" "aws_ec2_ec2_account_attributes_ebs_encryption_by_default" {
  resource = turbot_smart_folder.enforce_encryption_baseline.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/ec2AccountAttributesEbsEncryptionByDefault"
  value    = "Enforce: AWS managed key or higher"
}
