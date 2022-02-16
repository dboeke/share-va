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
  - |
    {
      account: resource {
        id: get(path:"turbot.custom.aws.accountId")
      }
    }
  - |
    {
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
      }
    }
  QUERY
  
  # Nunjucks template to set tags and check for tag validity.
  template = <<-TEMPLATE
      {%- if $.resource.tags -%}
      {#- --------------------------- -#}
      {#-    initialize variables     -#}
      {#- --------------------------- -#}
      {%- set new_tags = "" -%}
      {%- set required_tags = ${jsonencode(var.required_tags)} -%}
      {%- set tag_value_map = ${jsonencode(var.wrong_tag_values)} -%}
      {#- --------------------------- -#}
      {#- set default tags from ssm   -#}
      {#- --------------------------- -#}
      {%- for org_tag, resource_tag in required_tags -%}
        {%- if $.acct.tags[org_tag] -%}
          {%- set new_tags = new_tags + '- "' + resource_tag + '": ' -%}
          {%- set new_tags = new_tags + '"' + $.acct.tags[org_tag] + '"\n' -%}
        {%- endif -%}
      {%- endfor -%}
      {#- --------------------------- -#}
      {#-     set environment tag     -#}
      {#- --------------------------- -#}
      {%- set env_tag = "null" -%}
      {%- if "Environment" in $.resource.tags -%}
        {%- if $.resource.tags["Environment"] in tag_value_map -%}
          {%- set env_tag = '"' + tag_value_map[$.resource.tags["Environment"]] + '"\n'  -%}
        {%- endif -%}
      {%- elif "environment" in $.resource.tags -%}
        {%- if $.resource.tags["environment"] in tag_value_map -%}
          {%- set env_tag = '"' + tag_value_map[$.resource.tags["environment"]] + '"\n'  -%}
        {%- endif -%}
      {%- endif -%}
      {%- if (env_tag == "null") and ("vaec:Environment" in $.resource.tags) -%}
        {%- if $.resource.tags["vaec:Environment"] in tag_value_map -%}
          {%- set env_tag = '"' + tag_value_map[$.resource.tags["vaec:Environment"]] + '"\n'  -%}
        {%- endif -%}
      {%- endif -%}
      {%- set new_tags = new_tags + '- "vaec:Environment": ' + env_tag + '\n' -%}
      {#- --------------------------- -#}
      {#-       test tenant tags      -#}
      {#- --------------------------- -#}
      {%- set tag_combo = "|" -%}
      {%- set t_approved = "" -%}
      {%- if $.resource.acct_id in $.tenant.data -%}
        {%- for t_vaecid, t_ckid in $.tenant.data[$.resource.acct_id] -%}
          {%- set t_approved = t_approved + "|" + t_vaecid + "|" + t_ckid + "|," -%}
          {%- set t_approved = t_approved + "|" + t_vaecid + "|" + "|," -%}
          {%- set t_approved = t_approved + "|" + "|" + t_ckid + "|," -%}
        {%- endfor -%}
        {%- if "tenant:VAECID" in $.resource.tags -%}
          {%- set tag_combo = tag_combo + $.resource.tags["tenant:VAECID"] -%}
        {%- endif -%}
        {%- set tag_combo = tag_combo + "|" -%}
        {%- if "tenant:CKID" in $.resource.tags -%}
          {%- set tag_combo = tag_combo + $.resource.tags["tenant:CKID"] -%}
        {%- endif -%}
        {%- set tag_combo = tag_combo + "|," -%}
        {%- if tag_combo not in t_approved -%}
          {%- set new_tags = new_tags + '- "tenant:VAECID": null\n' -%}
          {%- set new_tags = new_tags + '- "tenant:CKID": null\n' -%}
        {%- endif -%}
      {%- else -%}
        {%- set new_tags = new_tags + '- "tenant:VAECID": null\n' -%}
        {%- set new_tags = new_tags + '- "tenant:CKID": null\n' -%}
      {%- endif -%}
      {#- --------------------------- -#}
      {#-     output required tags    -#}
      {#- --------------------------- -#}
    {{ new_tags }}
    {%- endif -%}
    TEMPLATE
}