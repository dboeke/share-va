
# AWS > IAM > User > Approved
resource "turbot_policy_setting" "aws_iam_user_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/userApproved"
  value    = "Check: Approved"
}

# AWS > IAM > User > Approved > Recently Used
resource "turbot_policy_setting" "aws_iam_access_key_active_recently_used" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/accessKeyActiveRecentlyUsed"
  value    = "Force active if recently used <= 90 days"
}

# AWS > IAM > User > Approved > Custom
resource "turbot_policy_setting" "aws_iam_user_approved_custom" {
  resource       = turbot_smart_folder.iam_controls_enforce.id
  type           = "tmod:@turbot/aws-iam#/policy/types/userApprovedCustom"
  template_input = <<-EOT
    { account {
            Id
            children(filter: "resourceTypeId:tmod:@turbot/aws-iam#/resource/types/credentialReport resourceTypeLevel:self") {
              items {
                credentialInfo: get(path: "credentialInfo")
              }
            }
          }
      user {
        UserName
      }
    }
    EOT
  template       = <<-EOT
    {%- set credReportExists = false -%}
    {%- set userCredReport = false -%}
    {%- set userHasPassword = false -%}
    {%- set userHasMfa = false -%}
    {%- set result = "Approved" -%}
    {%- set title = "CmdbNotUpdated" -%}
    {%- set message = "Approving user, waiting on CMDB Update" -%}
    {%- if $.user.UserName -%}
      {%- if $.account.children.items[0] -%}
        {%- if "credentialInfo" in $.account.children.items[0] -%}
          {%- set credReportExists = true -%}
          {%- if $.user.UserName in $.account.children.items[0]["credentialInfo"] -%}
            {%- set userCredReport = $.account.children.items[0]["credentialInfo"][$.user.UserName] -%}
            {%- if userCredReport["password_enabled"] == "true" -%}
              {%- set userHasPassword = true -%}
            {%- endif -%}
            {%- if userCredReport["mfa_active"] == "true" -%}
              {%- set userHasMfa = true -%}
            {%- endif -%}
          {%- endif -%}
        {%- endif -%}
      {%- endif -%}
      {%- if not credReportExists -%}
        {%- set result  = "Approved" -%}
        {%- set title   = "NoCredentialReport" -%}
        {%- set message = "Approving user, waiting on Credential Report" -%}
      {%- elif not userCredReport -%}
        {%- set result  = "Approved" -%}
        {%- set title   = "UserMissingFromCredentialreport" -%}
        {%- set message = "Approving user, waiting on Credential Report update" -%}
      {%- elif userHasPassword and not userHasMfa -%}
        {%- if $.user.UserName == "Administrator" -%}
          {%- set result  = "Approved" -%}
          {%- set title   = "AdministratorException" -%}
          {%- set message = "Admin exception for no MFA" -%}
        {%- else -%}
          {%- set result  = "Not approved" -%}
          {%- set title   = "NoMFAonUser" -%}
          {%- set message = "User has password, but no MFA" -%}
        {%- endif -%}
      {%- endif -%}
    {%- endif -%}
    - title: "{{ title }}"
      result: "{{ result }}"
      message: "{{ message }}"
EOT
}

# AWS > IAM > User > Approved > Usage
resource "turbot_policy_setting" "aws_iam_user_approved_usage" {
  resource       = turbot_smart_folder.iam_controls_enforce.id
  type           = "tmod:@turbot/aws-iam#/policy/types/userApprovedUsage"
  value          =  "Approved"
}

# AWS > IAM > User > Inline Policy > Statements > Approved
resource "turbot_policy_setting" "aws_iam_user_inline_policy_statements_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/userInlinePolicyStatementsApproved"
  value    = "Check: Approved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete Unapproved"
}

# AWS > IAM > User > Policy Attachments > Approved
resource "turbot_policy_setting" "aws_iam_user_policy_attachments_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/userPolicyAttachmentsApproved"
  value    = "Check: Approved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved"
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

# # Unable to set these policies due to bug. Mods team is looking into it
# # AWS > IAM > User > Inline Policy > Statements > Approved > Administrator Access
# resource "turbot_policy_setting" "aws_iam_user_inline_policy_statements_approved_admin_access" {
#   resource = turbot_smart_folder.iam_controls_enforce.id
#   type     = "tmod:@turbot/aws-iam#/policy/types/userInlinePolicyStatementsApprovedAdminAccess"
#   value    = "Disabled: Disallow Administrator Access ('*:*') policies"
#   # "Enabled: Allow Administrator Access ('*:*') policies"
#   # "Disabled: `Disallow Administrator Access ('*:*') policies"
# }
