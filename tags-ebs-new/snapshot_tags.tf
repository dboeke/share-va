#####################################################################
## Tagging for snapshots, checking vol for environment tag
#####################################################################
resource "turbot_policy_setting" "snapshot_tag_enforcement" {
  resource = turbot_smart_folder.vaec_ebs_tagging_snapshots.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/snapshotTags"
  value    = "Check: Tags are correct"
}

resource "turbot_policy_setting" "snapshot_tag_template" {
  resource        = turbot_smart_folder.vaec_ebs_tagging_snapshots.id
  type            = "tmod:@turbot/aws-ec2#/policy/types/snapshotTagsTemplate"
  template_input  = <<-QUERY
  - |
    {
      snap: snapshot {
        assoc_vol_id: get(path:"VolumeId")
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
      vols: resources(filter:"$.VolumeId:'{{ $.snap['assoc_vol_id'] }}' resourceType:tmod:@turbot/aws-ec2#/resource/types/volume") {
        items {
          tags: get(path:"turbot.tags")
        }
      }
    }
  QUERY
  
  # Nunjucks template to set tags and check for tag validity.
  template = <<-TEMPLATE
    {%- if ($.resource.tags) and ($.env_tag.data) and ($.tenant.data) and ($.vols.items) -%}
    ${var.template_init}
    ${var.template_org_tags}
    {#- ---------------------------- -#}
    {#- grab environment from volume -#}
    {#- ---------------------------- -#}
    {%- for env_tag_key in env_tags -%}
      {%- for volume in $.vols.items -%}
        {%- if env_tag_key in volume.tags -%}
          {%- if volume.tags[env_tag_key] in $.env_tag.data -%}
            {%- set env = $.env_tag.data[volume.tags[env_tag_key]] -%}
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
