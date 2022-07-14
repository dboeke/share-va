
variable "turbot_profile" {
  description = "Enter profile matching your turbot cli credentials."
}

resource "turbot_smart_folder" "decommission_accounts" {
  parent      = "tmod:@turbot/turbot#/"
  title       = "Decommission Accounts"
  description = "Attach to decommissioned accounts"
}
 
resource "turbot_policy_setting" "aws_regions_default" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws#/policy/types/regionsDefault"
  value    = "[]"
}
 
resource "turbot_policy_setting" "aws_s3_bucket_encryption_at_rest" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws-s3#/policy/types/bucketEncryptionAtRest"
  value    = "Skip"
}
 
resource "turbot_policy_setting" "aws_s3_encryption_in_transit" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws-s3#/policy/types/encryptionInTransit"
  value    = "Skip"
}
 
resource "turbot_policy_setting" "aws_cisv1_cis" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws-cisv1#/policy/types/cis"
  value    = "Skip"
}
 
resource "turbot_policy_setting" "aws_ec2_volume_approved" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeApproved"
  value    = "Skip"
}
 
resource "turbot_policy_setting" "aws_ec2_snapshot_approved" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/snapshotApproved"
  value    = "Skip"
}
 
resource "turbot_policy_setting" "aws_vpc_security_security_group_approved" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws-vpc-security#/policy/types/securityGroupApproved"
  value    = "Skip"
}
 
resource "turbot_policy_setting" "aws_vpc_security_security_group_ingress_rules_approved" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws-vpc-security#/policy/types/securityGroupIngressRulesApproved"
  value    = "Skip"
}
 
resource "turbot_policy_setting" "aws_event_poller" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws#/policy/types/eventPoller"
  value    = "Disabled"
}
 
resource "turbot_policy_setting" "aws_event_handlers" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws#/policy/types/eventHandlers"
  value    = "Skip"
}
 
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettings"
  value    = "Skip"
}
 
resource "turbot_policy_setting" "aws_s3_bucket_access_logging" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws-s3#/policy/types/bucketAccessLogging"
  value    = "Skip"
}
 
resource "turbot_policy_setting" "aws_iam_access_key_active" {
  resource = turbot_smart_folder.decommission_accounts.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accessKeyActive"
  value    = "Skip"
}