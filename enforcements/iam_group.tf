# AWS > IAM > Group > Inline Policy > Statements > Approved
resource "turbot_policy_setting" "aws_iam_group_inline_policy_statements_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/groupInlinePolicyStatementsApproved"
  value    = "Check: Approved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete Unapproved"
}

# AWS > IAM > Group > Inline Policy > Statements > Approved > Usage
resource "turbot_policy_setting" "aws_iam_group_inline_policy_statements_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/groupInlinePolicyStatementsApprovedUsage"
  value    = "Not approved"
}

# AWS > IAM > Group > Policy Attachments > Approved
resource "turbot_policy_setting" "aws_iam_group_policy_attachments_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/groupPolicyAttachmentsApproved"
  value    = "Check: Approved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved"
}

# AWS > IAM > Group > Policy Attachments > Approved > Rules
resource "turbot_policy_setting" "aws_iam_group_policy_attachments_approved_rules" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/groupPolicyAttachmentsApprovedRules"
  value    = <<EOT
REJECT $.PolicyName:/^.+FullAccess.*$/
REJECT $.PolicyName:AdministratorAccess
APPROVE *
EOT
}

# # AWS > IAM > Group > Inline Policy > Statements > Approved > Administrator Access
# resource "turbot_policy_setting" "aws_iam_group_inline_policy_statements_approved_admin_access" {
#   resource = turbot_smart_folder.iam_controls_enforce.id
#   type     = "tmod:@turbot/aws-iam#/policy/types/groupInlinePolicyStatementsApprovedAdminAccess"
#   value    = "Disabled: Disallow Administrator Access ('*:*') policies"
#   # "Enabled: Allow Administrator Access ('*:*') policies"
#   # "Disabled: Disallow Administrator Access ('*:*') policies"
# }
