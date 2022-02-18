#####################################################################
## Tagging for ebs volumes, checking instance for environment tag
#####################################################################
resource "turbot_policy_setting" "volume_tag_enforcement" {
  resource = turbot_smart_folder.vaec_ebs_tagging_volumes.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/volumeTags"
  value    = "Enforce: Set tags"
}

resource "turbot_policy_setting" "volume_tag_template" {
  resource        = turbot_smart_folder.vaec_ebs_tagging_volumes.id
  type            = "tmod:@turbot/aws-ec2#/policy/types/volumeTagsTemplate"
  template_input  = <<-QUERY
  - |
    {
      instance: volume {
        id: get(path:"Attachments[0].InstanceId")
      }
      account: resource {
        id: get(path:"turbot.custom.aws.accountId")
      }
    }
  - |
    {
      acct: resource(id:"${var.org_arn}/{{$.account.id}}") {
        tags: get(path:"turbot.tags")
      }
      resource {
        tags: get(path:"turbot.tags")
        acct_id: get(path:"turbot.custom.aws.accountId")
      }
      tenant: resource(id:"vaectenant"){
        data
      }
      env_tag: resource(id:"envtagvalues"){
        data
      }
      instances: resources(filter:"$.InstanceId:'{{ $.instance['id'] }}' resourceType:tmod:@turbot/aws-ec2#/resource/types/instance") {
        items {
          tags: get(path:"turbot.tags")
        }
      }
    }
  QUERY
  
  # Nunjucks template to set tags and check for tag validity.
  template = <<-TEMPLATE
    {%- if ($.resource.tags) and ($.env_tag.data) and ($.tenant.data) and ($.instances.items) -%}
    ${var.template_init}
    ${var.template_org_tags}
    {#- ------------------------------ -#}
    {#- grab environment from instance -#}
    {#- ------------------------------ -#}
    {%- for env_tag_key in env_tags -%}
      {%- for instance in $.instances.items -%}
        {%- if env_tag_key in instance.tags -%}
          {%- if instance.tags[env_tag_key] in $.env_tag.data -%}
            {%- set env = $.env_tag.data[instance.tags[env_tag_key]] -%}
          {%- endif -%}
        {%- endif -%}
      {%- endfor -%}
    {%- endfor -%}
    ${var.template_env_tag}
    ${var.template_tenant_tags}
    ${var.template_output_tags}
    {%- endif -%}
    TEMPLATE
}
