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
    {# --------------------------- #}
    {#    initialize variables     #}
    {# --------------------------- #}
    {%- set new_tags = "" -%}
    {%- set required_tags = ${jsonencode(var.required_tags)} -%}
    {%- set tag_value_map = ${jsonencode(var.wrong_tag_values)} -%}
    {# --------------------------- #}
    {# set default tags from ssm   #}
    {# --------------------------- #}
    {%- for ssm_param in $.region.children.items -%}
      {%- if ssm_param.name in required_tags -%}
        {%- set new_tags = new_tags + '- "' + required_tags[ssm_param.name] + '": ' -%}
        {%- set new_tags = new_tags + '"' + ssm_param.value + '"\n' -%}
      {%- endif -%}
    {%- endfor -%}
    {# --------------------------- #}
    {#     set environment tag     #}
    {# --------------------------- #}
    {%- set env_tag = "null" -%}
    {%- if "Environment" in $.resource.turbot.tags -%}
      {%- if $.resource.turbot.tags["Environment"] in tag_value_map -%}
        {%- set env_tag = '"' + tag_value_map[$.resource.turbot.tags["Environment"]] + '"\n'  -%}
      {%- endif -%}
    {%- elif "environment" in $.resource.turbot.tags -%}
      {%- if $.resource.turbot.tags["environment"] in tag_value_map -%}
        {%- set env_tag = '"' + tag_value_map[$.resource.turbot.tags["environment"]] + '"\n'  -%}
      {%- endif -%}
    {%- endif -%}
    {%- if (env_tag == "null") and ("vaec:Environment" in $.resource.turbot.tags) -%}
      {%- if $.resource.turbot.tags["vaec:Environment"] in tag_value_map -%}
        {%- set env_tag = '"' + tag_value_map[$.resource.turbot.tags["vaec:Environment"]] + '"\n'  -%}
      {%- endif -%}
    {%- set new_tags = new_tags + '- "vaec:Environment": ' + env_tag -%}
    {# --------------------------- #}
    {#     output required tags    #}
    {# --------------------------- #}
    {{ new_tags }}
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
    {# --------------------------- #}
    {#    initialize variables     #}
    {# --------------------------- #}
    {%- set new_tags = "" -%}
    {%- set required_tags = ${jsonencode(var.required_tags)} -%}
    {%- set tag_value_map = ${jsonencode(var.wrong_tag_values)} -%}
    {%- set conn_id_map = ${jsonencode(var.conn_id_map)} -%}
    {# --------------------------- #}
    {# set default tags from ssm   #}
    {# --------------------------- #}
    {%- for ssm_param in $.region.children.items -%}
      {%- if ssm_param.name in required_tags -%}
        {%- set new_tags = new_tags + '- "' + required_tags[ssm_param.name] + '": ' -%}
        {%- set new_tags = new_tags + '"' + ssm_param.value + '"\n' -%}
      {%- endif -%}
    {%- endfor -%}
    {# --------------------------- #}
    {# grab connection id from vpc #}
    {# --------------------------- #}
    {%- set connectionId = "none" -%}
    {%- if $.resource.parent.turbot.tags["vaec:ConnectionID"] -%}
      {%- set connectionId=$.resource.parent.turbot.tags["vaec:ConnectionID"] | truncate (3, false, "") -%}
    {%- elif $.resource.parent.turbot.tags["ConnectionID"] -%}
      {%- set connectionId=$.resource.parent.turbot.tags["ConnectionID"] | truncate (3, false, "") -%}
    {%- endif -%}
    {# --------------------------- #}
    {#     set environment tag     #}
    {# --------------------------- #}
    {%- set env_tag = "null" -%}
    {%- if connectionId in conn_id_map -%}
      {%- set env_tag = '"' + conn_id_map[connectionId] + '"\n' -%}
    {%- elif "Environment" in $.resource.turbot.tags -%}
      {%- if $.resource.turbot.tags["Environment"] in tag_value_map -%}
        {%- set env_tag = '"' + tag_value_map[$.resource.turbot.tags["Environment"]] + '"\n'  -%}
      {%- endif -%}
    {%- elif "environment" in $.resource.turbot.tags -%}
      {%- if $.resource.turbot.tags["environment"] in tag_value_map -%}
        {%- set env_tag = '"' + tag_value_map[$.resource.turbot.tags["environment"]] + '"\n'  -%}
      {%- endif -%}
    {%- endif -%}
    {%- if (env_tag == "null") and ("vaec:Environment" in $.resource.turbot.tags) -%}
      {%- if $.resource.turbot.tags["vaec:Environment"] in tag_value_map -%}
        {%- set env_tag = '"' + tag_value_map[$.resource.turbot.tags["vaec:Environment"]] + '"\n'  -%}
      {%- endif -%}
    {%- set new_tags = new_tags + '- "vaec:Environment": ' + env_tag -%}
    {# --------------------------- #}
    {#     output required tags    #}
    {# --------------------------- #}
    {{ new_tags }}
    TEMPLATE
}


## Sets tagging policy for each vpc related resource.
resource "turbot_policy_setting" "vpc_related_resource_tag_enforcement" {
  for_each        = var.vpc_referenced_tags 
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map[each.key]
  value           = each.value
}

resource "turbot_policy_setting" "vpc_related_resource_tag_template" {
  for_each        = var.vpc_referenced_tags
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map_template[each.key]
  # GraphQL to pull policy Statements
  template_input  = <<-QUERY
  { region {
      name: Name
      children(filter:"'/vaec/tag/' resourceTypeId:tmod:@turbot/aws-ssm#/resource/types/ssmParameter resourceTypeLevel:self") {
        items {
          name: get(path: "Name")
          value: get(path: "Value")
        }
      }
    }
    resource {
      parent {
        children(filter:"resourceTypeLevel:self resourceType:tmod:@turbot/aws-vpc-core#/resource/types/vpc") {
          items {
            vpcId:get(path: "VpcId")
            turbot {
              tags
            }
          }
        }
      }
      assoc_vpc_id: get(path:"${var.vpc_referenced_resource_map[each.key]}")
      turbot {
        tags
      }
    }
  }
  QUERY
  
  # Nunjucks template to set tags and check for tag validity.
  template = <<-TEMPLATE
    {# --------------------------- #}
    {#    initialize variables     #}
    {# --------------------------- #}
    {%- set new_tags = "" -%}
    {%- set required_tags = ${jsonencode(var.required_tags)} -%}
    {%- set tag_value_map = ${jsonencode(var.wrong_tag_values)} -%}
    {%- set conn_id_map = ${jsonencode(var.conn_id_map)} -%}
    {# --------------------------- #}
    {# set default tags from ssm   #}
    {# --------------------------- #}
    {%- for ssm_param in $.region.children.items -%}
      {%- if ssm_param.name in required_tags -%}
        {%- set new_tags = new_tags + '- "' + required_tags[ssm_param.name] + '": ' -%}
        {%- set new_tags = new_tags + '"' + ssm_param.value + '"\n' -%}
      {%- endif -%}
    {%- endfor -%}
    {# --------------------------- #}
    {# grab connection id from vpc #}
    {# --------------------------- #}
    {%- set assoc_vpc_env = false -%}
    {%- set assoc_vpc_conn = false -%}
    {%- for assoc_vpc in $.resource.parent.children.items -%}
      {%- if assoc_vpc["vpcId"] == $.resource.assoc_vpc_id -%}
        {# grab connection id from vpc #}
        {%- if assoc_vpc.turbot.tags["vaec:ConnectionID"] -%}
          {%- set assoc_vpc_conn = assoc_vpc.turbot.tags["vaec:ConnectionID"] | truncate (3, false, "") -%}
        {%- elif assoc_vpc.turbot.tags.ConnectionId -%}
          {%- set assoc_vpc_conn = assoc_vpc.turbot.tags.ConnectionId | truncate (3, false, "") -%}
        {%- elif assoc_vpc.turbot.tags.connectionId -%}
          {%- set assoc_vpc_conn = assoc_vpc.turbot.tags.connectionId | truncate (3, false, "") -%}
        {%- endif -%}
        {# grab Environment from vpc #}
        {%- if assoc_vpc.turbot.tags["vaec:Environment"] -%}
          {%- set assoc_vpc_env = assoc_vpc.turbot.tags["vaec:Environment"] -%}
        {%- elif assoc_vpc.turbot.tags.Environment -%}
          {%- set assoc_vpc_env = assoc_vpc.turbot.tags.Environment -%}
        {%- elif assoc_vpc.turbot.tags.environment -%}
          {%- set assoc_vpc_env = assoc_vpc.turbot.tags.environment -%}
        {%- endif -%}
      {%- endif -%}
    {%- endfor -%}
    {# --------------------------- #}
    {#     set environment tag     #}
    {# --------------------------- #}
    {%- set env_tag = "null" -%}
    {%- if assoc_vpc_conn in conn_id_map -%}
      {%- set env_tag = '"' + conn_id_map[assoc_vpc_conn] + '"\n' -%}
    {%- elif assoc_vpc_env in tag_value_map -%}
      {%- set env_tag = '"' + tag_value_map[assoc_vpc_env + '"\n' -%}
    {%- elif "Environment" in $.resource.turbot.tags -%}
      {%- if $.resource.turbot.tags["Environment"] in tag_value_map -%}
        {%- set env_tag = '"' + tag_value_map[$.resource.turbot.tags["Environment"]] + '"\n'  -%}
      {%- endif -%}
    {%- elif "environment" in $.resource.turbot.tags -%}
      {%- if $.resource.turbot.tags["environment"] in tag_value_map -%}
        {%- set env_tag = '"' + tag_value_map[$.resource.turbot.tags["environment"]] + '"\n'  -%}
      {%- endif -%}
    {%- endif -%}
    {%- if (env_tag == "null") and ("vaec:Environment" in $.resource.turbot.tags) -%}
      {%- if $.resource.turbot.tags["vaec:Environment"] in tag_value_map -%}
        {%- set env_tag = '"' + tag_value_map[$.resource.turbot.tags["vaec:Environment"]] + '"\n'  -%}
      {%- endif -%}
    {%- set new_tags = new_tags + '- "vaec:Environment": ' + env_tag -%}
    {# --------------------------- #}
    {#     output required tags    #}
    {# --------------------------- #}
    {{ new_tags }}
    TEMPLATE
}