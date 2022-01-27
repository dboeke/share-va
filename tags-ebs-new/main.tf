## SMART FOLDER TEMPLATE: aws_tagging
## Description: Sets default tag template to validate 3 Tags:
##     vaec:ProjectName, vaec:VAECID, vaec:CKID
##
## If the tags do not exist, we will create them with a default
## value pulled from a key value in AWS SSM Parameter Store.

variable "turbot_profile" {
  description = "Enter profile matching your turbot cli credentials."
}

## Create Smart Folder at the Turbot level

resource "turbot_smart_folder" "vaec_ebs_tagging_snapshots" {
  parent = "tmod:@turbot/turbot#/"
  title  = "VAEC EBS Tagging Snapshots v5"
}

resource "turbot_smart_folder" "vaec_ebs_tagging_volumes" {
  parent = "tmod:@turbot/turbot#/"
  title  = "VAEC EBS Tagging Volumes v5"
}

## Vars to Map resources to tag

variable "required_tags" {
  description = "This is a list of tag names that must exist on all resources."
  type        = map
}
variable "conn_id_map" {
  description = "This is a list of allowed connection keys."
  type        = map
}

variable "wrong_tag_values" {
  description = "This is a list of environment values to map to correct values"
  type        = map
}

variable "conn_key_list" {
  description = "This is a list of tag names that could contain the connection key."
  type        = list
}

variable "env_key_list" {
  description = "This is a list of tag names that could contain the environment type."
  type        = list
}