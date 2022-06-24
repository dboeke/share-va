# params = {
#   workspace_url,
#   workspace_access_key,
#   workspace_secret_key,
# }


resource "aws_ssm_parameter" "workspace_url" {
  for_each  = var.workspaces
  name      = "/turbot/firehose/${each.key}/workspace/url"
  type      = "String"
  value     = each.value
}

resource "aws_ssm_parameter" "workspace_access_key" {
  for_each  = var.workspaces
  name      = "/turbot/firehose/${each.key}/workspace/access_key"
  type      = "SecureString"
  value     = var.workspace_access_key[each.key]
}

resource "aws_ssm_parameter" "workspace_secret_key" {
  for_each  = var.workspaces
  name      = "/turbot/firehose/${each.key}/workspace/secret_key"
  type      = "SecureString"
  value     = var.workspace_secret_key[each.key]
}

resource "aws_ssm_parameter" "smtp_server_name" {
  for_each  = var.workspaces
  name      = "/turbot/firehose/vaec/smtp/server/name"
  type      = "String"
  value     = var.smtp_server
}

resource "aws_ssm_parameter" "smtp_recipients" {
  for_each  = var.workspaces
  name      = "/turbot/firehose/${each.key}/workspace/emails"
  type      = "String"
  value     = var.workspace_emails[each.key]
}
