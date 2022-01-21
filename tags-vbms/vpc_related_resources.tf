#####################################################################
## Tagging for resources related to the VPC that have VPC References
#####################################################################
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
      children(filter:"title:'/vaec/tag/*' resourceTypeId:tmod:@turbot/aws-ssm#/resource/types/ssmParameter resourceTypeLevel:self") {
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
    {#- --------------------------- -#}
    {#-    initialize variables     -#}
    {#- --------------------------- -#}
    {%- set new_tags = "" -%}
    {%- set required_tags = ${jsonencode(var.required_tags)} -%}
    {%- set tag_value_map = ${jsonencode(var.wrong_tag_values)} -%}
    {%- set conn_id_map = ${jsonencode(var.conn_id_map)} -%}
    {%- set conn_key_list = ${jsonencode(var.conn_key_list)} -%}
    {%- set env_key_list = ${jsonencode(var.env_key_list)} -%}
    {#- --------------------------- -#}
    {#- set default tags from ssm   -#}
    {#- --------------------------- -#}
    {%- for ssm_param in $.region.children.items -%}
      {%- if ssm_param.name in required_tags -%}
        {%- set new_tags = new_tags + '- "' + required_tags[ssm_param.name] + '": ' -%}
        {%- set new_tags = new_tags + '"' + ssm_param.value + '"\n' -%}
      {%- endif -%}
    {%- endfor -%}
    {#- --------------------------- -#}
    {#- grab connection id from vpc -#}
    {#- --------------------------- -#}
    {%- set assoc_vpc_env = false -%}
    {%- set assoc_vpc_conn = false -%}
    {%- for assoc_vpc in $.resource.parent.children.items -%}
      {%- if assoc_vpc["vpcId"] == $.resource.assoc_vpc_id -%}
      {#- grab connection id from vpc -#}
        {%- for conn_tag_key in conn_key_list -%}
          {%- if conn_tag_key in assoc_vpc.turbot.tags -%}
            {%- set assoc_vpc_conn = assoc_vpc.turbot.tags[conn_tag_key] | truncate (3, false, "") -%}
          {%- endif -%}
        {%- endfor -%}
        {#- grab Environment from vpc -#}
        {%- for env_tag_key in env_key_list -%}
          {%- if env_tag_key in assoc_vpc.turbot.tags -%}
            {%- set assoc_vpc_env = assoc_vpc.turbot.tags[env_tag_key] -%}
          {%- endif -%}
        {%- endfor -%}
      {%- endif -%}
    {%- endfor -%}
    {#- --------------------------- -#}
    {#-     set environment tag     -#}
    {#- --------------------------- -#}
    {%- set env_tag = "null" -%}
    {%- if assoc_vpc_conn in conn_id_map -%}
      {%- set env_tag = '"' + conn_id_map[assoc_vpc_conn] + '"\n' -%}
    {%- elif assoc_vpc_env in tag_value_map -%}
      {%- set env_tag = '"' + tag_value_map[assoc_vpc_env] + '"\n' -%}
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
    {%- endif -%}
    {%- set new_tags = new_tags + '- "vaec:Environment": ' + env_tag -%}
    {#- --------------------------- -#}
    {#-     output required tags    -#}
    {#- --------------------------- -#}
    {{ new_tags }}
    TEMPLATE
}

