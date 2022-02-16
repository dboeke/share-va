resource "turbot_file" "vaec_approved_tenants" {
  parent  = "tmod:@turbot/turbot#/"
  title   = "VAEC Approved Tenant Accounts"
  akas = ["vaectenant"]
  content = <<EOT
    {
      "460514156203": {
        "AWG20170915001":"763",
        "AWG20170915001.1":"763.1",
        "AWG20170915001.2":"763.2"
      },
      "899206412154": {
        "AWG20170915001":"763",
        "AWG20170915001.1":"763.1",
        "AWG20170915001.2":"763.2"
      }
    }
    EOT
}