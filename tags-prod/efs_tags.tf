#####################################################################
## Tagging for EFS
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
      enis: resources(filter:"$.NetworkInterfaceId:'{{ $.eni['mounts'][0]['NetworkInterfaceId'] }}' resourceType:tmod:@turbot/aws-ec2#/resource/types/networkInterface") {
        items {
          tags: get(path:"turbot.tags")
        }
      }
    }
  QUERY
  
  # Nunjucks template to set tags and check for tag validity.
  template = <<-TEMPLATE
    {%- if ($.resource.tags) and ($.env_tag.data) and ($.tenant.data) and ($.enis.items) -%}
    ${var.template_init}
    ${var.template_org_tags}
    {#- ---------------------------- -#}
    {#-   grab environment from ENI  -#}
    {#- ---------------------------- -#}
    {%- for env_tag_key in env_tags -%}
      {%- for eni in $.enis.items -%}
        {%- if env_tag_key in eni.tags -%}
          {%- if eni.tags[env_tag_key] in $.env_tag.data -%}
            {%- set env = $.env_tag.data[eni.tags[env_tag_key]] -%}
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

