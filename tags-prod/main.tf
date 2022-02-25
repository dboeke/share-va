## SMART FOLDER TEMPLATE: aws_tagging
## Description: Sets default tag template to validate 3 Tags:
##     vaec:Environment, vaec:VAECID, vaec:CKID
##
## These are pulled from the org account tags

variable "turbot_profile" {
  description = "Enter profile matching your turbot cli credentials."
}

variable "org_arn" {
  description = "Enter arn of the aws organization root."
  type        = string
}

## Create Smart Folder at the Turbot level

resource "turbot_smart_folder" "vaec_aws_tagging" {
  parent = "tmod:@turbot/turbot#/"
  title  = "VAEC AWS Tagging Policies v5"
}

##############################
## Tag Enforcement Maps
##############################
variable "enforce_non_vpc_resource_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

variable "enforce_vpc_child_resource_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

variable "enforce_vpc_referenced_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

variable "enforce_vpc_unreferenced_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

##############################
## NEW tag template maps
##############################
variable "new_non_vpc_resource_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

variable "new_vpc_child_resource_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

variable "new_vpc_referenced_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

variable "new_vpc_unreferenced_tags" {
  description = "Map of the list of resources that need to be tagged. please update in terraform.tfvars:"
  type        = map
}

##############################
## Vars to Map resources to tag
##############################
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

##############################
##  Nunjucks Templates
##############################
variable "template_init" {
  description = "Nunjucks calc policy template."
  type        = string
}

variable "template_org_tags" {
  description = "Nunjucks calc policy template."
  type        = string
}
variable "template_parent_conn_id" {
  description = "Nunjucks calc policy template."
  type        = string
}
variable "template_self_conn_id" {
  description = "Nunjucks calc policy template."
  type        = string
}
variable "template_related_conn_id" {
  description = "Nunjucks calc policy template."
  type        = string
}
variable "template_env_tag" {
  description = "Nunjucks calc policy template."
  type        = string
}
variable "template_tenant_tags" {
  description = "Nunjucks calc policy template."
  type        = string
}
variable "template_output_tags" {
  description = "Nunjucks calc policy template."
  type        = string
}