#Smart Folder
resource "turbot_smart_folder" "iam_controls_enforce" {
  parent = "tmod:@turbot/turbot#/"
  title  = "RASP AWS - IAM Controls"
}

resource "turbot_policy_setting" "aws_iam_iam_policy_approved_turbot" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/iamPolicyApprovedTurbot"
  value    = "Force Approved for Turbot Policies"
}

resource "turbot_policy_setting" "aws_iam_role_inline_policy_approved_usage" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/roleInlinePolicyApprovedUsage"
  value    = "Not approved"
}

# AWS > IAM > Group > Inline Policy > Statements > Approved
resource "turbot_policy_setting" "aws_iam_group_inline_policy_statements_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/groupInlinePolicyStatementsApproved"
  value    = "Enforce: Delete Unapproved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete Unapproved"
}

# AWS > IAM > Account Password Policy > Settings > Require Lowercase Characters
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings_require_lowercase_characters" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettingsRequireLowercaseCharacters"
  value    = "Enabled"
  # "Enabled"
  # "Disabled"
}

# AWS > IAM > Account Password Policy > Settings > Require Numbers
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings_require_numbers" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettingsRequireNumbers"
  value    = "Enabled"
  # "Enabled"
  # "Disabled"
}

# AWS > IAM > Policy > Approved > Usage
resource "turbot_policy_setting" "aws_iam_iam_policy_approved_usage" {
  resource       = turbot_smart_folder.iam_controls_enforce.id
  type           = "tmod:@turbot/aws-iam#/policy/types/iamPolicyApprovedUsage"
  template_input = <<EOT
{
  policy: resource {
    statements: get(path: "PolicyVersion.Document.Statement")
  }
}
EOT
  template       = <<EOT
{%- set anyStar = r/\*/g -%}
{%- set goodStar = r/(Get|List)\*/g -%}
{%- set approved = true -%}
{%- for statement in $.policy.statements -%}
    {%- if 'Action' in statement -%}
    	{%- set actions_string = statement.Action | string -%}
    	{%- set actions = actions_string.split(",") -%}
    	{%- for action in actions -%}
        	{%- if anyStar.test(action) -%}
            		{%- if not goodStar.test(action) -%}
                	{%- set approved = false -%}
            		{%- endif -%}
        	{%- endif -%}
    	{%- endfor -%}
    {%- endif -%}
{%- endfor -%}
{%- if approved  -%}
    "Approved"
{%- else -%}
    "Not approved"
{%- endif -%}
EOT
  # Not approved
  # Approved
  # Approved if AWS > IAM > Enabled
}

# AWS > IAM > Access Key > Active
resource "turbot_policy_setting" "aws_iam_access_key_active" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accessKeyActive"
  value    = "Enforce: Deactivate inactive with 7 days warning"
  # "Skip"
  # "Check: Active"
  # "Enforce: Delete inactive with 1 day warning"
  # "Enforce: Delete inactive with 3 days warning"
  # "Enforce: Delete inactive with 7 days warning"
  # "Enforce: Delete inactive with 14 days warning"
  # "Enforce: Delete inactive with 30 days warning"
  # "Enforce: Delete inactive with 60 days warning"
  # "Enforce: Delete inactive with 90 days warning"
  # "Enforce: Delete inactive with 180 days warning"
  # "Enforce: Delete inactive with 365 days warning"
  # "Enforce: Deactivate inactive with 1 day warning"
  # "Enforce: Deactivate inactive with 3 days warning"
  # "Enforce: Deactivate inactive with 7 days warning"
  # "Enforce: Deactivate inactive with 14 days warning"
  # "Enforce: Deactivate inactive with 30 days warning"
  # "Enforce: Deactivate inactive with 60 days warning"
  # "Enforce: Deactivate inactive with 90 days warning"
  # "Enforce: Deactivate inactive with 180 days warning"
  # "Enforce: Deactivate inactive with 365 days warning"
}

# AWS > IAM > Access Key > Active > Age
resource "turbot_policy_setting" "aws_iam_access_key_active_age" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accessKeyActiveAge"
  value    = "Force inactive if age > 180 days"
  # "Skip"
  # "Force inactive if age > 1 day"
  # "Force inactive if age > 3 days"
  # "Force inactive if age > 7 days"
  # "Force inactive if age > 14 days"
  # "Force inactive if age > 30 days"
  # "Force inactive if age > 60 days"
  # "Force inactive if age > 90 days"
  # "Force inactive if age > 180 days"
  # "Force inactive if age > 365 days"
}

# AWS > IAM > Access Key > Active > Status
resource "turbot_policy_setting" "aws_iam_access_key_active_status" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accessKeyActiveStatus"
  value    = "Force active if $.Status is active"
  # "Active if $.Status is active"
  # "Force active if $.Status is active"
}

# AWS > IAM > Access Key > Active > Last Modified
resource "turbot_policy_setting" "aws_iam_access_key_active_last_modified" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accessKeyActiveLastModified"
  value    = "Force active if last modified <= 14 days"
}

# AWS > IAM > User > Approved > Recently Used
resource "turbot_policy_setting" "aws_iam_access_key_active_recently_used" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accessKeyActiveRecentlyUsed"
  value    = "Force active if recently used <= 90 days"
}

# AWS > IAM > Account Password Policy > Settings > Minimum Length
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings_minimum_length" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettingsMinimumLength"
  value    = 14
}



# AWS > IAM > Group > Policy Attachments > Approved
resource "turbot_policy_setting" "aws_iam_group_policy_attachments_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/groupPolicyAttachmentsApproved"
  value    = "Enforce: Delete unapproved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved"
}

# AWS > IAM > Policy > Approved
resource "turbot_policy_setting" "aws_iam_iam_policy_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/iamPolicyApproved"
  value    = "Enforce: Delete unapproved if new"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved if new"
}

# AWS > IAM > User > Approved > Usage
resource "turbot_policy_setting" "aws_iam_user_approved_usage" {
  resource       = turbot_smart_folder.iam_controls_enforce.id
  type           = "tmod:@turbot/aws-iam#/policy/types/userApprovedUsage"
  template_input = <<EOT
{
	user{
		Arn
		UserName
		}
resources(filter:"resourceType:'tmod:@turbot/aws-iam#/resource/types/mfaVirtual'") {
	items {
		usertest: get(path:"User.UserName")
		trunk {
			title
			}
		}
	}
}
EOT
  template       = <<EOT
{%- set matches = false -%}
{%- for v in $.resources.items -%}
	{%- if v.usertest == $.user.UserName -%}
	{%- set matches = true -%}
	{%- endif -%}
{%- endfor -%}
{%- if matches -%}
"Approved"
{%- else -%}
"Not approved"
{%- endif -%}
EOT
}

# AWS > IAM > User > Policy Attachments > Approved
resource "turbot_policy_setting" "aws_iam_user_policy_attachments_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/userPolicyAttachmentsApproved"
  value    = "Enforce: Delete unapproved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved"
}

# AWS > IAM > Role > Inline Policy > Statements > Approved
resource "turbot_policy_setting" "aws_iam_role_inline_policy_statements_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/roleInlinePolicyStatementsApproved"
  value    = "Enforce: Delete Unapproved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete Unapproved"
}

# AWS > IAM > Account Password Policy > Settings > Require Uppercase Characters
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings_require_uppercase_characters" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettingsRequireUppercaseCharacters"
  value    = "Enabled"
  # "Enabled"
  # "Disabled"
}

# AWS > IAM > Account Password Policy > Settings > Max Age
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings_max_age" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettingsMaxAge"
  value    = 60
}

# AWS > IAM > User > Inline Policy > Statements > Approved
resource "turbot_policy_setting" "aws_iam_user_inline_policy_statements_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/userInlinePolicyStatementsApproved"
  value    = "Enforce: Delete Unapproved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete Unapproved"
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

# AWS > IAM > Account Password Policy > Settings > Reuse Prevention
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings_reuse_prevention" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettingsReusePrevention"
  value    = 24
}

# AWS > IAM > User > Policy Attachments > Approved > Rules
resource "turbot_policy_setting" "aws_iam_user_policy_attachments_approved_rules" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/userPolicyAttachmentsApprovedRules"
  value    = <<EOT
REJECT $.PolicyName:/^.+FullAccess.*$/
REJECT $.PolicyName:AdministratorAccess
APPROVE *
EOT
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

resource "turbot_policy_setting" "aws_iam_role_policy_attachments_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/rolePolicyAttachmentsApproved"
  value    = "Enforce: Delete unapproved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved"
}

# AWS > IAM > Account Password Policy > Settings > Require Symbols
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings_require_symbols" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettingsRequireSymbols"
  value    = "Enabled"
  # "Enabled"
  # "Disabled"
}

# AWS > IAM > Account Password Policy > Settings
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettings"
  value    = "Enforce: Configured"
  # "Skip"
  # "Check: Configured"
  # "Enforce: Configured"
}

# AWS > IAM > Account Password Policy > Settings > Allow Users to Change
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings_allow_change" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettingsAllowUsersToChange"
  value    = "Enabled"
  # "Enabled"
  # "Disabled"
}

# AWS > IAM > Account Password Policy > Settings > Hard Expiry
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings_hard_expiry" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettingsHardExpiry"
  value    = "Enabled"
  # "Enabled"
  # "Disabled"
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

# # AWS > IAM > Group > Inline Policy > Statements > Approved > Administrator Access
# resource "turbot_policy_setting" "aws_iam_group_inline_policy_statements_approved_admin_access" {
#   resource = turbot_smart_folder.iam_controls_enforce.id
#   type     = "tmod:@turbot/aws-iam#/policy/types/groupInlinePolicyStatementsApprovedAdminAccess"
#   value    = "Disabled: Disallow Administrator Access ('*:*') policies"
#   # "Enabled: Allow Administrator Access ('*:*') policies"
#   # "Disabled: Disallow Administrator Access ('*:*') policies"
# }

# # AWS > IAM > User > Inline Policy > Statements > Approved > Administrator Access
# resource "turbot_policy_setting" "aws_iam_user_inline_policy_statements_approved_admin_access" {
#   resource = turbot_smart_folder.iam_controls_enforce.id
#   type     = "tmod:@turbot/aws-iam#/policy/types/userInlinePolicyStatementsApprovedAdminAccess"
#   value    = "Disabled: Disallow Administrator Access ('*:*') policies"
#   # "Enabled: Allow Administrator Access ('*:*') policies"
#   # "Disabled: Disallow Administrator Access ('*:*') policies"
# }