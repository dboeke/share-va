## Control Objective ID: aws_tagging_01
## Description:  Enforce default tag template and tag controls for all resource types

## Sets tagging policy for each resource type in the resource_tags map.
resource "turbot_policy_setting" "non_vpc_tag_enforcement" {
  for_each        = var.non_vpc_resource_tags
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map[each.key]
  value           = each.value
}

## Sets the default tag template for all resources.
resource "turbot_policy_setting" "non_vpc_tag_template" {
  for_each        = var.non_vpc_resource_tags
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map_template[each.key]
  # GraphQL to pull policy Statements
  template_input  = <<-QUERY
  {
    region {
        children(filter:"'/vaec/tag/' resourceTypeId:tmod:@turbot/aws-ssm#/resource/types/ssmParameter resourceTypeLevel:self") {
          items {
            name: get(path: "Name")
            value: get(path: "Value")
          }
        }
      }
    resource {
      turbot {
        tags
      }
    }
  }
  QUERY
  
  # Nunjucks template to set tags and check for tag validity.
  template = <<-TEMPLATE
    {%- set new_tags = {} -%}
    {%- set required_tags = ${jsonencode(var.required_tags)} -%}
    {%- set tag_value_map = ${jsonencode(var.required_tags)} -%}
    {%- for ssm_param in $.region.children.items -%}
      {%- if ssm_param.name in required_tags -%}
        {%- set new_tags[required_tags[ssm_param.name]] = ssm_param.value -%}
      {%- endif -%}
    {%- endfor -%}
    {%- if "vaec:Environment" in $.resource.turbot.tags -%}
      {%- if $.resource.turbot.tags["vaec:Environment"] in tag_value_map -%}
        {%- set new_tags["vaec:Environment"] = tag_value_map[$.resource.turbot.tags["vaec:Environment"]] -%}
      {%- endif -%}
    {%- elif "Environment" in $.resource.turbot.tags -%}
      {%- set new_tags["vaec:Environment"] = $.resource.turbot.tags["Environment"] -%}
    {%- elif "environment" in $.resource.turbot.tags -%}
      {%- set new_tags["vaec:Environment"] = $.resource.turbot.tags["environment"] -%}
    {%- else -%}
      {%- set new_tags["vaec:Environment"] = ${var.default_environment} -%}
    {%- endif -%}
    {%- for key, value in new_tags -%}
    - "{{key}}": "{{value}}"
    {%- endfor -%}
    TEMPLATE
}

## Sets tagging policy for each resource type in the resource_tags map.
resource "turbot_policy_setting" "vpc_resource_tag_enforcement" {
  for_each        = var.vpc_child_resource_tags
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map[each.key]
  value           = each.value
}

## Sets the default tag template for all VPC resources.
resource "turbot_policy_setting" "vpc_resource_tag_template" {
  for_each        = var.vpc_child_resource_tags
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map_template[each.key]
  # GraphQL to pull policy Statements
  template_input  = <<-QUERY
  {
    region {
      name: Name
      children(filter:"'/vaec/tag/' resourceTypeId:tmod:@turbot/aws-ssm#/resource/types/ssmParameter resourceTypeLevel:self") {
        items {
          name: get(path: "Name")
          value: get(path: "Value")
        }
      }
    }
    resource {
      turbot {
        tags
      }
      parent {
        turbot {
          tags
        }
      }
    }
  }
  QUERY
  
  # Nunjucks template to set tags and check for tag validity.
  template = <<-TEMPLATE
    {%- set new_tags = {} -%}
    {%- set required_tags = ${jsonencode(var.required_tags)} -%}
    {%- set tag_value_map = ${jsonencode(var.required_tags)} -%}
    {%- for ssm_param in $.region.children.items -%}
      {%- if ssm_param.name in required_tags -%}
        {%- set new_tags[required_tags[ssm_param.name]] = ssm_param.value -%}
      {%- endif -%}
    {%- endfor -%}

    {%- if $.resource.parent.turbot.tags["vaec:ConnectionID"] -%}
      {%- set connectionId=$.resource.parent.turbot.tags["vaec:ConnectionID"] | truncate (3, false, "") -%}
    {%- elif $.resource.parent.turbot.tags["ConnectionID"] -%}
      {%- set connectionId=$.resource.parent.turbot.tags["ConnectionID"] | truncate (3, false, "") -%}
    {%- endif -%}
    {%- if "vaec:Environment" in $.resource.turbot.tags -%}
      {%- if $.resource.turbot.tags["vaec:Environment"] in tag_value_map -%}
        {%- set new_tags["vaec:Environment"] = tag_value_map[$.resource.turbot.tags["vaec:Environment"]] -%}
      {%- endif -%}
    {%- elif "vaec:Environment" in $.resource.parent.turbot.tags -%}
      {%- set new_tags["vaec:Environment"] = $.resource.parent.turbot.tags["vaec:Environment"] -%}
    {%- elif connectionId == "311" -%}
      {%- set new_tags["vaec:Environment"] = "Production" -%}
    {%- elif connectionId == "312" -%}
      {%- set new_tags["vaec:Environment"] = "Stage" -%}
    {%- elif connectionId == "313" -%}
      {%- set new_tags["vaec:Environment"] = "Development" -%}
    {%- elif "Environment" in $.resource.turbot.tags -%}
      {%- set new_tags["vaec:Environment"] = $.resource.turbot.tags["Environment"] -%}
    {%- elif "environment" in $.resource.turbot.tags -%}
      {%- set new_tags["vaec:Environment"] = $.resource.turbot.tags["environment"] -%}
    {%- elif "Environment" in $.resource.parent.turbot.tags -%}
      {%- set new_tags["vaec:Environment"] = $.resource.parent.turbot.tags["Environment"] -%}
    {%- elif "environment" in $.resource.parent.turbot.tags -%}
      {%- set new_tags["vaec:Environment"] = $.resource.parent.turbot.tags["environment"] -%}
    {%- else -%}
      {%- set new_tags["vaec:Environment"] = ${var.default_environment} -%}
    {%- endif -%}
    {%- for key, value in new_tags -%}
    - "{{key}}": "{{value}}"
    {%- endfor -%}
    TEMPLATE
}
