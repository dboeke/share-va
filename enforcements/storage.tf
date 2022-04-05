resource "turbot_smart_folder" "storage_controls" {
  parent = "tmod:@turbot/turbot#/"
  title  = "RASP AWS - Storage Controls"
}

resource "turbot_policy_setting" "aws_ec2_volume_active" {
  resource = turbot_smart_folder.storage_controls.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeActive"
  value    = "Enforce: Detach, snapshot and delete inactive with 30 days warning"
}

resource "turbot_policy_setting" "aws_ec2_volume_active_last_modified" {
  resource = turbot_smart_folder.storage_controls.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeActiveLastModified"
  value    = "Force active if last modified <= 60 days"
}

resource "turbot_policy_setting" "aws_ec2_volume_active_age" {
  resource = turbot_smart_folder.storage_controls.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeActiveAge"
  value    = "Force inactive if age > 60 days"
}

resource "turbot_policy_setting" "aws_ec2_volume_active_attached" {
  resource = turbot_smart_folder.storage_controls.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeActiveAttached"
  value    = "Force active if attached"
  ## Skip
  ## Active if attached
  ## Force active if attached
  ## Force inactive if unattached
}


