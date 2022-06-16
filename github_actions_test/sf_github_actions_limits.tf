#Smart Folder
resource "turbot_smart_folder" "enforce_github_actions_limits" {
  parent = "tmod:@turbot/turbot#/"
  title  = "GitHub Actions Role Enforcement"
}

resource "turbot_policy_setting" "conditional_aws_iam_role_approved" {
  resource       = turbot_smart_folder.enforce_github_actions_limits.id
  type           = "tmod:@turbot/aws-iam#/policy/types/roleApproved"
  template_input = <<-EOT
    { role {
        AssumeRolePolicyDocument
      }
    }
    EOT
  template       = <<-EOT
    {%- set policy_value = 'Check: Approved' -%}
    {%- if "Statement" in $.role.AssumeRolePolicyDocument -%}
      {%- for statement in $.role.AssumeRolePolicyDocument.Statement -%}
        {%- if "Federated" in statement.Principal -%}
          {%- if "token.actions.githubusercontent.com" in statement.Principal.Federated -%}
            {%- set policy_value = 'Enforce: Delete unapproved if new' -%}
          {%- endif -%}
      {%- endif -%}
      {%- endfor -%}
    {%- endif -%}
    "{{ policy_value }}"
    EOT
}

# resource "turbot_policy_setting" "conditional_aws_iam_role_approved" {
#   resource       = turbot_smart_folder.enforce_github_actions_limits.id
#   type           = "tmod:@turbot/aws-iam#/policy/types/roleApproved"
#   template_input = <<-EOT
#     { role {
#         AssumeRolePolicyDocument
#       }
#     }
#     EOT
#   template       = <<-EOT
#     {%- set policy_value = 'Skip' -%}
#     {%- if "Statement" in $.role.AssumeRolePolicyDocument -%}
#       {%- for statement in $.role.AssumeRolePolicyDocument.Statement -%}
#         {%- if "Federated" in statement.Principal -%}
#           {%- if "token.actions.githubusercontent.com" in statement.Principal.Federated -%}
#             {%- set policy_value = 'Check: Approved' -%}
#           {%- endif -%}
#       {%- endif -%}
#       {%- endfor -%}
#     {%- endif -%}
#     "{{ policy_value }}"
#     EOT
# }

resource "turbot_policy_setting" "aws_iam_role_approved_custom" {
  resource       = turbot_smart_folder.enforce_github_actions_limits.id
  type           = "tmod:@turbot/aws-iam#/policy/types/roleApprovedCustom"
  template_input = <<-EOT
    { role {
        AssumeRolePolicyDocument
      }
    }
    EOT
  template       = <<-EOT
    {%- set policy_result = 'Approved' -%}
    {%- set policy_message = "Role doesn't allow GitHub Actions" -%}
    {%- if "Statement" in $.role.AssumeRolePolicyDocument -%}
      {%- for statement in $.role.AssumeRolePolicyDocument.Statement -%}
        {%- if "Federated" in statement.Principal -%}
          {%- if "token.actions.githubusercontent.com" in statement.Principal.Federated -%}
            {%- set policy_result = 'Not approved' -%}
            {%- set policy_message = "GitHub role does not limit to VA Github Organization" -%}
              {%- if "Condition" in statement -%}
                {%- if "StringLike" in statement.Condition -%}
                  {%- if "token.actions.githubusercontent.com:sub" in statement.Condition.StringLike -%}
                    {%- if "repo:department-of-veterans-affairs/" in statement.Condition.StringLike["token.actions.githubusercontent.com:sub"] -%}
                      {%- set policy_result = 'Approved' -%}
                      {%- set policy_message = "GitHub role limited to VA Github Organization" -%}
                    {%- endif -%}
                  {%- endif -%}
                {%- endif -%}
              {%- endif -%}
          {%- endif -%}
      {%- endif -%}
      {%- endfor -%}
    {%- endif -%}
    - title: "Github Actions Approved"
      result: "{{ policy_result }}"
      message: "{{ policy_message }}"
    EOT
}