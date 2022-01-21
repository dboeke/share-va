###############################
## Sets tagging policy for VPCs
###############################
resource "turbot_policy_setting" "vpc_tag_enforcement" {
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = "tmod:@turbot/aws-vpc-core#/policy/types/vpcTags"
  value           = "Enforce: Set tags"
}

## Sets tagging template for VPCs
resource "turbot_policy_setting" "vpc_tag_template" {
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = "tmod:@turbot/aws-vpc-core#/policy/types/vpcTagsTemplate"
  template_input  = <<-QUERY
  {
    region {
      name: Name
      children(filter:"title:'/vaec/tag/*' resourceTypeId:tmod:@turbot/aws-ssm#/resource/types/ssmParameter resourceTypeLevel:self") {
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
    {#- --------------------------- -#}
    {#-    initialize variables     -#}
    {#- --------------------------- -#}
    {%- set new_tags = "" -%}
    {%- set required_tags = ${jsonencode(var.required_tags)} -%}
    {%- set tag_value_map = ${jsonencode(var.wrong_tag_values)} -%}
    {%- set conn_id_map = ${jsonencode(var.conn_id_map)} -%}
    {%- set conn_key_list = ${jsonencode(var.conn_key_list)} -%}
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
    {%- set connectionId = "none" -%}
    {%- for conn_tag_key in conn_key_list -%}
      {%- if conn_tag_key in $.resource.turbot.tags -%}
        {%- set connectionId = $.resource.turbot.tags[conn_tag_key] | truncate (3, false, "") -%}
      {%- endif -%}
    {%- endfor -%}
    {#- --------------------------- -#}
    {#-     set environment tag     -#}
    {#- --------------------------- -#}
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
    {%- endif -%}
    {%- set new_tags = new_tags + '- "vaec:Environment": ' + env_tag -%}
    {#- --------------------------- -#}
    {#-     output required tags    -#}
    {#- --------------------------- -#}
    {{ new_tags }}
    TEMPLATE
}