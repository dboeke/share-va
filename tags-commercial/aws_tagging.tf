## Control Objective ID: aws_tagging_01
## Description:  Enforce default tag template and tag controls for all resource types

## Sets tagging policy for each resource type in the resource_tags map.
resource "turbot_policy_setting" "set_resource_tag_policies" {
  for_each        = var.resource_tags
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map[each.key]
  value           = each.value
}

## Sets the default tag template for all resources.
resource "turbot_policy_setting" "default_tag_template" {
  for_each        = var.resource_tags
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map_template[each.key]
  # GraphQL to pull policy Statements
  template_input  = <<-QUERY
  - |
    {
      acct: account {
        id: get(path:"Id")
      }
    }
  - |
    {
      org: resource(id:${var.org_account_turbot_id}) {
        descendants(filter: "resourceTypeId:'tmod:@turbot/aws-organizations#/resource/types/organizationalAccount' resourceTypeLevel:self {{$.acct.id}}) {
          items {
            id: get(path:"Id")
            tags: get(path:"Tags")
          }
        }
      }
      resource {
        tags: get(path: "Tags") 
          turbot {
            metadata
        }
      }
    }
  QUERY
  
  # Nunjucks template to set tags and check for tag validity.
  template = <<-TEMPLATE
  {%- set new_tags = "" -%}
  {%- set required_tags = ${jsonencode(var.required_tags)} -%}
  {%- for org_acct in $.org.descendants.items -%}
    {%- if org_acct['id'] == $.resource.turbot.metadata.aws.accountId -%}
      {%- for tag in org_acct['tags'] -%}
        {%- if tag['Key'] in required_tags -%}
          {%- set new_tags = new_tags + '- "' + required_tags[tag['Key']] + '": ' -%}
          {%- set new_tags = new_tags + '"' + tag['Value']+ '"\n' -%}
        {% endif %}
      {%- endfor -%}
    {%- endif -%}
  {%- endfor -%}
  {{ new_tags }}
  TEMPLATE
}