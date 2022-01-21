#####################################################################
## Tagging for snapshots, checking vol for environment tag
#####################################################################
resource "turbot_policy_setting" "snapshot_tag_enforcement" {
  resource = turbot_smart_folder.vaec_aws_snapshot_tagging.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/snapshotTags"
  value    = "Check: Tags are correct"
}

resource "turbot_policy_setting" "snapshot_tag_template" {
  resource        = turbot_smart_folder.vaec_aws_snapshot_tagging.id
  type            = "tmod:@turbot/aws-ec2#/policy/types/snapshotTagsTemplate"
  template_input  = <<-QUERY
  - |
    {
      snap: snapshot {
        assoc_vol_id: get(path:"VolumeId")
      }
    }
  - |
    {
      snapshot {
        assoc_vol_id: get(path:"VolumeId")
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
      vols: resources(filter: "title:'{{ $.snap['assoc_vol_id'] }}' resourceType:tmod:@turbot/aws-ec2#/resource/types/volume") {
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
    {% for ssm_param in $.params.children.items %}
    - {{ ssm_param['name'] }}: "{{ ssm_param['value'] }}"
    {% endfor %}
    - volId: "{{ $.snapshot['assoc_vol_id'] }}"
    {% for key, value in $.vols.items[0].turbot.tags %}
    - {{ key }}: "{{ value }}"
    {% endfor %}
    TEMPLATE
}
