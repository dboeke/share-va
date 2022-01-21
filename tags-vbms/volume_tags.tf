#####################################################################
## Tagging for ebs volumes, checking instance for environment tag
#####################################################################
/*
resource "turbot_policy_setting" "volume_tag_enforcement" {
  resource = turbot_smart_folder.vaec_aws_tagging.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeTags"
  value    = "Enforce: Set tags"
}

resource "turbot_policy_setting" "volume_tag_template" {
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = "tmod:@turbot/aws-ec2#/policy/types/volumeTagsTemplate"
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
      parent {
        children(filter:"resourceTypeLevel:self resourceType:tmod:@turbot/aws-ec2#/resource/types/instance limit:5000") {
          items {
            instance_id: get(path: "InstanceId")
            turbot {
              tags
            }
          }
        }
      }
      attachments: get(path:"Attachments")
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
    {#- ---------------------------- -#}
    {#- grab environment from volume -#}
    {#- ---------------------------- -#}
    {%- set assoc_instance_env = false -%}
    {%- set attachments = "" -%}
    {%- for attachment in $.resource.attachments -%}
      {%- set attachments = attachments + "," + attachment.InstanceId -%}
    {%- endfor -%}
    {%- for assoc_instance in $.resource.parent.children.items -%}
      {%- if assoc_instance["instance_id"] in attachments -%}
        {#- grab Environment from Instance -#}
        {%- for env_tag_key in env_key_list -%}
          {%- if env_tag_key in assoc_instance.turbot.tags -%}
            {%- if assoc_instance.turbot.tags[env_tag_key] in tag_value_map -%}
                {%- set assoc_instance_env = assoc_instance.turbot.tags[env_tag_key] -%}
            {%- endif -%}
          {%- endif -%}
        {%- endfor -%}
      {%- endif -%}
    {%- endfor -%}
    {#- --------------------------- -#}
    {#-     set environment tag     -#}
    {#- --------------------------- -#}
    {%- set env_tag = "null" -%}
    {%- if assoc_instance_env in tag_value_map -%}
      {%- set env_tag = '"' + tag_value_map[assoc_instance_env] + '"\n' -%}
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
    {{ new_tags }}
    TEMPLATE
}
*/