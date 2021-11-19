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
  {
    region {
        children(filter:"'/vaec/tag/' resourceTypeId:tmod:@turbot/aws-ssm#/resource/types/ssmParameter resourceTypeLevel:self") {
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
{%- set required_tags = {"/vaec/tag/CKID":"vaec:CKID","/vaec/tag/VAECID":"vaec:VAECID"} -%}
{%- set tag_value_map = {"PreProd":"Stage","Production-SDC-new-volume":"Production","dev":"Development","development":"Development","stage":"Stage","vlm-admin-dev":"Development","Stage":"Stage","Development":"Development","Production":"Production"} -%}
{%- for ssm_param in $.region.children.items %}
{%- if ssm_param.name in required_tags -%}
- "{{required_tags[ssm_param.name]}}": "{{ssm_param.value}}"
{% endif %}
{%- endfor -%}
{%- if "vaec:Environment" in $.resource.turbot.tags -%}
 {%- if $.resource.turbot.tags["vaec:Environment"] in tag_value_map -%}
- "vaec:Environment": "{{tag_value_map[$.resource.turbot.tags["vaec:Environment"]]}}"
{% endif -%}
{%- endif -%}
{%- for badEnvTag in ["Environment","environment"] -%}
  {%- if badEnvTag in $.resource.turbot.tags -%}
    {%- if "vaec:Environment" not in $.resource.turbot.tags -%}
- "vaec:Environment": {{$.resource.turbot.tags[badEnvTag]}}
{% endif %}
- "{{badEnvTag}}": undefined
  {%- endif -%}
{%- endfor -%}
  TEMPLATE
}
