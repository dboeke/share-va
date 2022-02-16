terraform {
  required_providers {
    turbot = {
      source = "turbot/turbot"
      version = ">= 1.8.3"
    }
  }
  required_version = ">= 0.13"
}

provider "turbot" {
  profile = var.turbot_profile
}
