#Smart Folder
resource "turbot_smart_folder" "iam_controls_enforce" {
  parent = "tmod:@turbot/turbot#/"
  title  = "RASP AWS - IAM Controls"
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

# AWS > IAM > Access Key > Active
resource "turbot_policy_setting" "aws_iam_access_key_active" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accessKeyActive"
  value    = "Enforce: Deactivate inactive with 1 days warning"
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
  value    = "Force inactive if age > 60 days"
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



# AWS > IAM > Account Password Policy > Settings > Minimum Length
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings_minimum_length" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettingsMinimumLength"
  value    = 14
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


# AWS > IAM > Account Password Policy > Settings > Reuse Prevention
resource "turbot_policy_setting" "aws_iam_account_password_policy_settings_reuse_prevention" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accountPasswordPolicySettingsReusePrevention"
  value    = 24
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

resource "turbot_policy_setting" "aws_iam_credential_report_cmdb" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/credentialReportCmdb"
  value    = "Enforce: Enabled"
}
