## Don't auto tag Cloudformation stacks

resource "turbot_policy_setting" "cloudformation_tag_skip" {
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = "tmod:@turbot/aws-cloudformation#/policy/types/stackTags"
  value           = "Skip"
}

resource "turbot_policy_setting" "vpc_tag_enforcement" {
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = "tmod:@turbot/aws-vpc-core#/policy/types/vpcTags"
  value           = "Enforce: Set tags"
}

##############

resource "turbot_policy_setting" "non_vpc_tag_enforcement" {
  for_each        = var.enforce_non_vpc_resource_tags
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map[each.key]
  value           = each.value
}

resource "turbot_policy_setting" "vpc_resource_tag_enforcement" {
  for_each        = var.enforce_vpc_child_resource_tags
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map[each.key]
  value           = each.value
}

resource "turbot_policy_setting" "vpc_related_resource_tag_enforcement" {
  for_each        = var.enforce_vpc_referenced_tags 
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map[each.key]
  value           = each.value
}

resource "turbot_policy_setting" "vpc_unreferenced_resource_tag_enforcement" {
  for_each        = var.enforce_vpc_unreferenced_tags 
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map[each.key]
  value           = each.value
}

