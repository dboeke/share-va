
resource "turbot_policy_setting" "aws_ec2_volume_tags_template" {
  resource       = turbot_smart_folder.vaec_aws_tagging.id
  type           = "tmod:@turbot/aws-ec2#/policy/types/volumeTagsTemplate"
  template_input = <<EOT
{
  region {
    name: get(path:"Name")
    children(filter:"'/vaec/tag/' resourceTypeId:tmod:@turbot/aws-ssm#/resource/types/ssmParameter resourceTypeLevel:self") {
      items {
        name: get(path: "Name")
        value: get(path: "Value")
      }
    }
  }
  resource {
    attachments: get(path:"Attachments")
    parent {
      children(filter: "resourceTypeLevel:self resourceType:tmod:@turbot/aws-ec2#/resource/types/instance limit:5000") {
        items {
          instanceId:get(path: "InstanceId")
          turbot {
            tags
          }
        }
      }
    }
  }
}
EOT
  template       = <<EOT
{%- set result = "" -%}
{%- set required_tags = {"/vaec/tag/CKID":"vaec:CKID","/vaec/tag/VAECID":"vaec:VAECID"} -%}
{%- for ssm_param in $.region.children.items %}
{%- if ssm_param.name in required_tags -%}
{%- set result = result + required_tags[ssm_param.name] | dump + ": " + ssm_param.value | dump + "\n" -%}
{% endif %}
{%- endfor -%}
{%- if $.region.name in ["us-gov-east-1", "us-gov-west-1"] -%}
    {%- set volumeAttachment = $.resource.attachments[0] -%}
    {# The volume is attached to an instance #} 
    {%- if volumeAttachment | length != 0 -%}
        {%- for instances in $.resource.parent.children.items -%}
            {%- if instances.instanceId == volumeAttachment.InstanceId -%}
                {% for tagKey, tagValue in instances.turbot.tags %}
                    {%- if tagKey == "vaec:Environment" -%}
                      {%- set result = result + tagKey | dump + ": " + tagValue | dump  + "\n" -%}
                    {%- endif -%}
                {% endfor %}
            {%- endif -%}
        {%- endfor -%}
    {%- endif -%}  
{%- endif -%}
{%- if result -%}
{{ result }}
{%- else -%}
[]
{%- endif -%}
EOT
}