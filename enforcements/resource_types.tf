resource "turbot_smart_folder" "instance_types" {
  parent = "tmod:@turbot/turbot#/"
  title  = "RASP AWS - Approved Instance Types"
}


resource "turbot_policy_setting" "aws_ec2_instance_approved_instance_types" {
  resource = turbot_smart_folder.instance_types.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/instanceApprovedInstanceTypes"
  value    = <<EOT
- "*"
EOT
}

resource "turbot_policy_setting" "aws_rds_db_instance_approved_database_engines" {
  resource = turbot_smart_folder.instance_types.id
  type     = "tmod:@turbot/aws-rds#/policy/types/dbInstanceApprovedDatabaseEngines"
  value    = <<EOT
- "*"
EOT
}

resource "turbot_policy_setting" "aws_ec2_volume_approved_volume_types" {
  resource = turbot_smart_folder.instance_types.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeApprovedVolumeTypes"
  value    = <<EOT
- "*"
EOT
}

resource "turbot_policy_setting" "aws_rds_db_instance_approved_instance_classes" {
  resource = turbot_smart_folder.instance_types.id
  type     = "tmod:@turbot/aws-rds#/policy/types/dbInstanceApprovedInstanceClasses"
  value    = <<EOT
- "*"
EOT
}