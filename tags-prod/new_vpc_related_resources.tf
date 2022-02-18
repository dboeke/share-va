resource "turbot_policy_setting" "vpc_related_resource_tag_template" {
  for_each        = var.new_vpc_referenced_tags
  resource        = turbot_smart_folder.vaec_aws_tagging.id
  type            = var.policy_map_template[each.key]
  # GraphQL to pull policy Statements
  template_input  = <<-QUERY
    - |
      {
        account: resource {
          id: get(path:"turbot.custom.aws.accountId")
          assoc_vpc_id: get(path:"${var.vpc_referenced_resource_map[each.key]}")
        }
      }
    - |
      {
        related: resources(filter:"$.VpcId:'{{$.account.assoc_vpc_id}}' resourceTypeId:'tmod:@turbot/aws-vpc-core#/resource/types/vpc'") {
          vpcs: items {
            tags: get(path:"turbot.tags")
          }
        }
        acct: resource(id:"${var.org_arn}/{{$.account.id}}") {
          tags: get(path:"turbot.tags")
        }
        resource {
          tags: get(path:"turbot.tags")
          acct_id: get(path:"turbot.custom.aws.accountId")
          parent {
            tags: get(path:"turbot.tags")
          }
        }
        tenant: resource(id:"vaectenant"){
          data
        }
        env_tag: resource(id:"envtagvalues"){
          data
        }
      }
  QUERY
  
  # Nunjucks template to set tags and check for tag validity.
  template = <<-TEMPLATE
    {%- if ($.resource.tags) and ($.env_tag.data) and ($.tenant.data) and ($.related.vpcs) -%}
    ${var.template_init}
    ${var.template_org_tags}
    ${var.template_related_conn_id}
    ${var.template_env_tag}
    ${var.template_tenant_tags}
    ${var.template_output_tags}
    {%- endif -%}
    TEMPLATE
}

