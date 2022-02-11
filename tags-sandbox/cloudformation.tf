## Don't auto tag Cloudformation stacks

resource "turbot_policy_setting" "cloudformation_tag_skip" {
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = "tmod:@turbot/aws-cloudformation#/policy/types/stackTags"
  value           = "Skip"
}
