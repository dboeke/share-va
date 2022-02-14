#####################################################################
## Tagging for resources related to the VPC that have VPC References
#####################################################################
resource "turbot_policy_setting" "efs_resource_tag_enforcement" {
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = "tmod:@turbot/aws-efs#/policy/types/fileSystemTags"
  value           = "Enforce: Set tags"
}

resource "turbot_policy_setting" "efs_resource_tag_template" {
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = "tmod:@turbot/aws-efs#/policy/types/fileSystemTagsTemplate"
  # GraphQL to pull policy Statements
  template_input  = <<-QUERY
  - |
    {
      eni: resource {
        mounts: get(path:"MountTargets")
      }
    }
  - |
    {
      resource {
        turbot {
          tags
        }
      }
      params: region {
        children(filter:"title:'/vaec/tag/*' resourceTypeId:tmod:@turbot/aws-ssm#/resource/types/ssmParameter resourceTypeLevel:self") {
          items {
            name: get(path: "Name")
            value: get(path: "Value")
          }
        }
      }
      enis: resources(filter:"title:'{{ $.eni['mounts'][0]['NetworkInterfaceId'] }}' resourceType:tmod:@turbot/aws-ec2#/resource/types/networkInterface") {
        items {
          turbot {
            tags
          }
        }
      }
    }
  QUERY
  
  # Nunjucks template to set tags and check for tag validity.
  template = <<-TEMPLATE
    {%- if $.resource.turbot.tags -%}
    {#- --------------------------- -#}
    {#-    initialize variables     -#}
    {#- --------------------------- -#}
    {%- set new_tags = "" -%}
    {%- set required_tags = ${jsonencode(var.required_tags)} -%}
    {%- set tag_value_map = ${jsonencode(var.wrong_tag_values)} -%}
    {%- set env_key_list = ${jsonencode(var.env_key_list)} -%}
    {#- --------------------------- -#}
    {#- set default tags from ssm   -#}
    {#- --------------------------- -#}
    {%- for ssm_param in $.params.children.items -%}
      {%- if ssm_param.name in required_tags -%}
        {%- set new_tags = new_tags + '- "' + required_tags[ssm_param.name] + '": ' -%}
        {%- set new_tags = new_tags + '"' + ssm_param.value + '"\n' -%}
      {%- endif -%}
    {%- endfor -%}
    {#- ---------------------------- -#}
    {#- grab environment from volume -#}
    {#- ---------------------------- -#}
    {%- set assoc_eni = false -%}
    {#- grab Environment from Volume -#}
    {%- for env_tag_key in env_key_list -%}
      {%- if $.enis.items[0] -%}
        {%- if env_tag_key in $.enis.items[0].turbot.tags -%}
          {%- if $.enis.items[0].turbot.tags[env_tag_key] in tag_value_map -%}
            {%- set assoc_eni = $.enis.items[0].turbot.tags[env_tag_key] -%}
          {%- endif -%}
        {%- endif -%}
      {%- endif -%}
    {%- endfor -%}
    {#- --------------------------- -#}
    {#-     set environment tag     -#}
    {#- --------------------------- -#}
    {%- set env_tag = "null" -%}
    {%- if assoc_eni in tag_value_map -%}
      {%- set env_tag = '"' + tag_value_map[assoc_eni] + '"\n' -%}
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
    {%- endif -%}
    TEMPLATE
}

