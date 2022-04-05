#Smart Folder
resource "turbot_smart_folder" "event_handlers_enforce" {
  parent = "tmod:@turbot/turbot#/"
  title  = "RASP AWS - Event Handlers"
}

resource "turbot_policy_setting" "aws_approved_regions_default" {
  resource = turbot_smart_folder.event_handlers_enforce.id
  type     = "tmod:@turbot/aws#/policy/types/approvedRegionsDefault"
  value    = <<EOT
- "us-gov-west-1"
- "us-gov-east-1"
EOT
}

resource "turbot_policy_setting" "regionsDefault" {
  resource    = turbot_smart_folder.event_handlers_enforce.id
  type        = "tmod:@turbot/aws#/policy/types/regionsDefault"
  value       = <<EOT
- "us-gov-west-1"
- "us-gov-east-1"
EOT
}

resource "turbot_policy_setting" "eventHandlers" {
  resource    = turbot_smart_folder.event_handlers_enforce.id
  type        = "tmod:@turbot/aws#/policy/types/eventHandlers"
  value       = "Enforce: Configured"
}

resource "turbot_policy_setting" "serviceRoles" {
  resource    = turbot_smart_folder.event_handlers_enforce.id
  type        = "tmod:@turbot/aws#/policy/types/serviceRoles"
  value       = "Enforce: Configured"
}

resource "turbot_policy_setting" "loggingBucket" {
  resource    = turbot_smart_folder.event_handlers_enforce.id
  type        = "tmod:@turbot/aws#/policy/types/loggingBucket"
  value       = "Enforce: Configured"
}

