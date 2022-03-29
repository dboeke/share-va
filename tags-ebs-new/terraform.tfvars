###  Check this for correct value on Prod
org_arn = "arn:aws-us-gov:organizations::348286891446:account/o-fgsg4ev0lb"

# These tags must exist
required_tags = {
  "/vaec/tag/VAECID" : "vaec:VAECID"
  "/vaec/tag/CKID" : "vaec:CKID"
}

conn_id_map = {
  "311" : "Production"
  "312" : "Stage"
  "313" : "Development"
}

conn_key_list = [
  "ConnectionID",
  "ConnectionId",
  "connectionID",
  "connectionId",
  "connectionid",
  "vaec:ConnectionID"
]

env_key_list = [
  "Environment",
  "environment",
  "vaec:environment",
  "vaec:Environment"
]

# These tags are set incorrectly
wrong_tag_values = {
  "Production" : "Production"
  "Stage" : "Stage"
  "Development" : "Development"
  "Demo" : "Development"
  "demo" : "Development"
  "DEV" : "Development"
  "Dev" : "Development"
  "dev" : "Development"
  "DEV02" : "Development"
  "Dev02" : "Development"
  "dev8" : "Development"
  "DEVELOPMENT" : "Development"
  "development" : "Development"
  "Development " : "Development"
  "Development2" : "Development"
  "Development-2" : "Development"
  "Development-A" : "Development"
  "Development-CST" : "Development"
  "Development-SBX" : "Development"
  "devl" : "Development"
  "devperf" : "Development"
  "dev-shared" : "Development"
  "DEVTEST" : "Development"
  "DR Sandbox" : "Development"
  "dr-dev" : "Development"
  "fti-dev" : "Development"
  "ivs-sandbox" : "Development"
  "ldx-dev" : "Development"
  "map-sandbox" : "Development"
  "pexip-dev" : "Development"
  "POC" : "Development"
  "poc" : "Development"
  "QA" : "Development"
  "qa" : "Development"
  "SANDBOX" : "Development"
  "Sandbox" : "Development"
  "sandbox" : "Development"
  "SQA" : "Development"
  "sqa" : "Development"
  "SQA1" : "Development"
  "SQA2" : "Development"
  "SQA3" : "Development"
  "SQA3C" : "Development"
  "SQA4" : "Development"
  "SQA5" : "Development"
  "SQA6" : "Development"
  "SQA7" : "Development"
  "Test" : "Development"
  "test" : "Development"
  "Testing" : "Development"
  "tst" : "Development"
  "UAT" : "Development"
  "uat" : "Development"
  "UAT01" : "Development"
  "UAT02" : "Development"
  "UAT03" : "Development"
  "aip-prod" : "Production"
  "dr-prod" : "Production"
  "fti-prod" : "Production"
  "ivs-prod" : "Production"
  "map-prod" : "Production"
  "prd" : "Production"
  "PROD" : "Production"
  "Prod" : "Production"
  "prod" : "Production"
  "prod8" : "Production"
  "Prod-A" : "Production"
  "prod-aux" : "Production"
  "prod-gov-internal" : "Production"
  "Prod-Ops" : "Production"
  "prod-shared" : "Production"
  "Produciton" : "Production"
  "PRODUCTION" : "Production"
  "production" : "Production"
  "Production-2" : "Production"
  "Production-A" : "Production"
  "Production-AUX" : "Production"
  "Production-BCK" : "Production"
  "Production-CM" : "Production"
  "Production-CST" : "Production"
  "Production-K" : "Production"
  "Production-L" : "Production"
  "Production-VPX" : "Production"
  "DR-PreProd" : "Stage"
  "fti-stage" : "Stage"
  "ivs-staging" : "Stage"
  "map-staging" : "Stage"
  "Pre Production" : "Stage"
  "PREPROD" : "Stage"
  "PreProd" : "Stage"
  "preprod" : "Stage"
  "Pre-Prod" : "Stage"
  "pre-prod" : "Stage"
  "PreProduction" : "Stage"
  "Pre-Production" : "Stage"
  "STAGE" : "Stage"
  "stage" : "Stage"
  "stage8" : "Stage"
  "Stage-A" : "Stage"
  "Stage-CST" : "Stage"
  "Stage-K" : "Stage"
  "Stage-L" : "Stage"
  "Stage-Ops" : "Stage"
  "STAGETEST" : "Stage"
  "StageTest" : "Stage"
  "STAGING" : "Stage"
  "Staging" : "Stage"
  "staging" : "Stage"
}


template_init = <<EOT
  {%- set req_tags = [] -%}
  {%- set null_tags = [] -%}
  {%- set env = false -%}
  {%- set conn_id = false -%}
  {%- set env_tags = ["Environment","environment","vaec:Environment"] -%}
  {%- set conn_id_map = {"311":"Production","312":"Stage","313":"Development"} -%}
  {%- set conn_key_list = ["ConnectionID","ConnectionId","connectionID","connectionId","connectionid","vaec:ConnectionID"] -%}
EOT

template_org_tags = <<EOT
  {%- if "vaec:VAECID" in $.acct.tags -%}
    {%- set req_tags = (req_tags.push({"vaec:VAECID": $.acct.tags["vaec:VAECID"]}), req_tags) -%}
  {%- endif -%}
  {%- if "vaec:CKID" in $.acct.tags -%}
    {%- set req_tags = (req_tags.push({"vaec:CKID": $.acct.tags["vaec:CKID"]}), req_tags) -%}
  {%- endif -%}
EOT

template_parent_conn_id = <<EOT
  {%- for key in conn_key_list -%}
    {%- if key in $.resource.parent.tags -%}
      {%- set conn_id = $.resource.parent.tags[key] | truncate (3, false, "") -%}
    {%- endif -%}
  {%- endfor -%}
EOT

template_self_conn_id = <<EOT
  {%- for key in conn_key_list -%}
    {%- if key in $.resource.tags -%}
      {%- set conn_id = $.resource.tags[key] | truncate (3, false, "") -%}
    {%- endif -%}
  {%- endfor -%}
EOT

template_related_conn_id = <<EOT
  {%- for assoc_vpc in $.related.vpcs -%}
    {#- grab connection id from vpc -#}
    {%- for conn_tag_key in conn_key_list -%}
      {%- if conn_tag_key in assoc_vpc.tags -%}
        {%- set conn_id = assoc_vpc.tags[conn_tag_key] | truncate (3, false, "") -%}
      {%- endif -%}
    {%- endfor -%}
    {#- grab Environment from vpc -#}
    {%- for env_tag_key in env_tags -%}
      {%- if env_tag_key in assoc_vpc.tags -%}
        {%- if assoc_vpc.tags[env_tag_key] in $.env_tag.data -%}
          {%- set env = $.env_tag.data[assoc_vpc.tags[env_tag_key]] -%}
        {%- endif -%}
      {%- endif -%}
    {%- endfor -%}
  {%- endfor -%}
EOT

template_env_tag = <<EOT
  {%- if conn_id in conn_id_map -%}
    {%- set env = conn_id_map[conn_id] -%}
  {%- else -%}
    {%- for env_tag in env_tags -%}
      {%- if (not env) and (env_tag in $.resource.tags) -%}
        {%- if $.resource.tags[env_tag] in $.env_tag.data -%}
          {%- set env = $.env_tag.data[$.resource.tags[env_tag]] -%}
        {%- endif -%}
      {%- endif -%}
    {%- endfor -%}
  {%- endif -%}
  {%- if env -%}
    {%- set req_tags = (req_tags.push({"vaec:Environment":env}), req_tags) -%}
  {%- else -%}
    {%- set null_tags = (null_tags.push("vaec:Environment"), null_tags) -%}
  {%- endif -%}
EOT

template_tenant_tags = <<EOT
  {%- set tag_combo = "|" -%}
  {%- set approved_combos = "|||," -%}
  {%- if $.resource.acct_id in $.tenant.data -%}
    {%- for t_vaecid, t_ckid in $.tenant.data[$.resource.acct_id] -%}
      {%- set approved_combos = approved_combos + "|" + t_vaecid + "|" + t_ckid + "|," -%}
      {%- set approved_combos = approved_combos + "|" + t_vaecid + "|" + "|," -%}
      {%- set approved_combos = approved_combos + "|" + "|" + t_ckid + "|," -%}
    {%- endfor -%}
    {%- if "tenant:VAECID" in $.resource.tags -%}
      {%- set tag_combo = tag_combo + $.resource.tags["tenant:VAECID"] -%}
    {%- endif -%}
    {%- set tag_combo = tag_combo + "|" -%}
    {%- if "tenant:CKID" in $.resource.tags -%}
      {%- set tag_combo = tag_combo + $.resource.tags["tenant:CKID"] -%}
    {%- endif -%}
    {%- set tag_combo = tag_combo + "|," -%}
    {%- if tag_combo not in approved_combos -%}
      {#- invalid vaecid:ckid combo -#}
      {%- set null_tags = (null_tags.push("tenant:VAECID"), null_tags) -%}
      {%- set null_tags = (null_tags.push("tenant:CKID"), null_tags) -%}
    {%- endif -%}
  {%- else -%}
    {#- account not authorized to use tenant tags -#}
    {%- set null_tags = (null_tags.push("tenant:VAECID"), null_tags) -%}
    {%- set null_tags = (null_tags.push("tenant:CKID"), null_tags) -%}
  {%- endif -%}
EOT

template_output_tags = <<EOT
{%- set cf = "\n" -%}
{%- for tag in req_tags -%}
  {%- for key, value in tag -%}
    "{{ key }}": "{{ value }}"{{ cf }}
  {%- endfor -%}
{%- endfor -%}
{%- for null_tag in null_tags -%}
    "{{ null_tag }}": null{{ cf }}
{%- endfor -%}
EOT

