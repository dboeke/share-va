

resource "turbot_policy_setting" "aws_iam_iam_policy_approved_turbot" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/iamPolicyApprovedTurbot"
  value    = "Force Approved for Turbot Policies"
}

# AWS > IAM > Policy > Approved
resource "turbot_policy_setting" "aws_iam_iam_policy_approved" {
  resource = turbot_smart_folder.iam_controls_enforce.id
  type     = "tmod:@turbot/aws-iam#/policy/types/iamPolicyApproved"
  value    = "Check: Approved"
  # "Skip"
  # "Check: Approved"
  # "Enforce: Delete unapproved if new"
}


# AWS > IAM > Policy > Approved > Usage
resource "turbot_policy_setting" "aws_iam_iam_policy_approved_usage" {
  resource       = turbot_smart_folder.iam_controls_enforce.id
  type           = "tmod:@turbot/aws-iam#/policy/types/iamPolicyApprovedUsage"
  template_input = <<-EOT
    {
    policy: resource {
        statements: get(path: "PolicyVersion.Document.Statement")
    }
    }
    EOT
  template       = <<-EOT
    {%- set approved = "Approved" -%}
    {%- for statement in $.policy.statements -%}
        {%- if 'Action' in statement -%}
            {%- set actions_string = statement.Action | string -%}
            {%- set actions = actions_string.split(",") -%}
            {%- for action in actions -%}
                {%- if action == "*" -%}
                    {%- set approved = "Not approved" -%}
                {%- endif -%}
            {%- endfor -%}
        {%- endif -%}
    {%- endfor -%}
    {{ approved }}
    EOT
  # Not approved
  # Approved
  # Approved if AWS > IAM > Enabled
}