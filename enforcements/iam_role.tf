


# AWS > IAM > Role > Inline Policy > Statements > Approved
resource "turbot_policy_setting" "aws_iam_role_inline_policy_statements_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/roleInlinePolicyStatementsApproved"
  value    = "Check: Approved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete Unapproved"
}

# AWS > IAM > Role > Inline Policy > Statements > Approved > Usage
resource "turbot_policy_setting" "aws_iam_role_inline_policy_approved_usage" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/roleInlinePolicyApprovedUsage"
  value    = "Approved"
}

# AWS > IAM > Role > Policy Attachments > Approved
resource "turbot_policy_setting" "aws_iam_role_policy_attachments_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/rolePolicyAttachmentsApproved"
  value    = "Check: Approved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved"
}

# AWS > IAM > Role > Policy Attachments > Approved > Rules
resource "turbot_policy_setting" "aws_iam_role_policy_attachments_approved_rules" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/rolePolicyAttachmentsApprovedRules"
  value    = <<EOT
REJECT $.PolicyName:/^.+FullAccess.*$/
REJECT $.PolicyName:AdministratorAccess
APPROVE *
EOT
}

# # Unable to set these policies due to bug. Mods team is looking into it
# # AWS > IAM > Role > Inline Policy > Statements > Approved > Administrator Access
# resource "turbot_policy_setting" "aws_iam_role_inline_policy_statements_approved_admin_access" {
#   resource = turbot_smart_folder.iam_controls_enforce.id
#   type     = "tmod:@turbot/aws-iam#/policy/types/roleInlinePolicyStatementsApprovedAdminAccess"
#   value    = "Disabled: Disallow Administrator Access ('*:*') policies"
#   # "Enabled: Allow Administrator Access ('*:*') policies"
#   # "Disabled: Disallow Administrator Access ('*:*') policies"
# }