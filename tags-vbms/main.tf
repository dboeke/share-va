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

resource "turbot_smart_folder" "vaec_aws_tagging" {
  parent = "tmod:@turbot/turbot#/"
  title  = "VAEC VBMS Tagging Policies v4"
}

## Vars to Map resources to tag

variable "global_resource_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

variable "non_vpc_resource_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

variable "vpc_child_resource_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

variable "vpc_referenced_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

variable "vpc_unreferenced_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

variable "vpc_referenced_resource_map" {
  description = "Map of the name of the reference to the vpc id on a resource"
  type        = map
}

variable "policy_map" {
  description = "This is a map of Turbot policy types to service names. You probably should not modify this:"
  type        = map
}

variable "policy_map_template" {
  description = "This is a map of Turbot tag template policy types to service names. You probably should not modify this:"
  type        = map
}

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