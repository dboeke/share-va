terraform {
  required_providers {
    turbot = {
      source = "turbot/turbot"
    }
  }
  required_version = ">= 0.13"
}

provider "turbot" {
  profile = var.turbot_profile
}

variable "turbot_profile" {
  description = "Enter profile matching your turbot cli credentials."
}

resource "turbot_policy_setting" "turbot_volume_interval" {
  resource           = "tmod:@turbot/aws-ec2#/control/types/volumeCmdb"
  type               = "tmod:@turbot/turbot#/policy/types/interval"
  value              = "days: 7"
}

resource "turbot_policy_setting" "turbot_instance_interval" {
  resource           = "tmod:@turbot/aws-ec2#/control/types/instanceCmdb"
  type               = "tmod:@turbot/turbot#/policy/types/interval"
  value              = "days: 7"
}