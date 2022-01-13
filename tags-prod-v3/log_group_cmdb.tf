resource "turbot_policy_setting" "aws_logs_log_group_cmdb" {
  resource = turbot_smart_folder.vaec_aws_tagging.id
  type     = "tmod:@turbot/aws-logs#/policy/types/logGroupCmdb"
  value    = "Enforce: Enabled"
}