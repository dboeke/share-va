## SMART FOLDER TEMPLATE: aws_tagging
## Description: Sets default tag template to validate 3 Tags:
##     vaec:ProjectName, vaec:VAECID, vaec:CKID
##
## If the tags do not exist, we will create them with a default
## value pulled from a key value in AWS SSM Parameter Store.

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
  title  = "VAEC AWS Tagging Policies v6"
}

## Vars to Map resources to tag

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