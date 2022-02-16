resource "turbot_file" "vaec_approved_tenants" {
  parent  = "tmod:@turbot/turbot#/"
  title   = "VAEC Approved Tenant Accounts"
  akas = ["vaectenant"]
  content = <<EOT
    {
      "477194928391": {
        "AWG20170915001":"763",
        "AWG20170915001.1":"763.1",
        "AWG20170915001.2":"763.2"
      },
      "#272417811699": {
        "AWG20170915001":"763",
        "AWG20170915001.1":"763.1",
        "AWG20170915001.2":"763.2"
      }
    }
    EOT
}