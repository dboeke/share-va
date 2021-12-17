provider "aws" {
  region = "us-gov-west-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

variable "vpc_id" {}

resource "aws_security_group" "turbot_api" {
  name        = "turbot_api_for_vaec"
  description = "Allow api traffic and vaec scanning"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ScienceLogicWinRM_TCP" {
  type              = "ingress"
  from_port         = 5985
  to_port           = 5986
  protocol          = "tcp"
  cidr_blocks       = ["10.249.163.96/27","10.249.166.64/27"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "ScienceLogic WinRM TCP"
}

resource "aws_security_group_rule" "ScienceLogicWinRMUDP" {
  type              = "ingress"
  from_port         = 5985
  to_port           = 5986
  protocol          = "udp"
  cidr_blocks       = ["10.249.163.96/27","10.249.166.64/27"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "ScienceLogic WinRM UDP"
}

resource "aws_security_group_rule" "ping" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["10.249.166.64/27","10.247.2.0/23","10.249.163.96/27"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "Ping for Discovery"
}

resource "aws_security_group_rule" "EnCaseforensics" {
  type              = "ingress"
  from_port         = 4445
  to_port           = 4446
  protocol          = "tcp"
  cidr_blocks       = ["10.247.2.210/32","10.247.2.230/32","10.247.2.246/32"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "EnCase forensics"
}

resource "aws_security_group_rule" "ePOtoMcAfeeagent" {
  type              = "ingress"
  from_port         = 8079
  to_port           = 8079
  protocol          = "tcp"
  cidr_blocks       = ["10.248.17.0/25","10.249.16.0/25"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "ePO to McAfee agent"
}

resource "aws_security_group_rule" "NessusScanAccess" {
  type              = "ingress"
  from_port         = 139
  to_port           = 139
  protocol          = "tcp"
  cidr_blocks       = ["10.249.16.0/25"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "Nessus Scan Access"
}

resource "aws_security_group_rule" "NessusScan" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "all"
  cidr_blocks       = ["10.247.2.40/32","10.247.2.44/32"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "Nessus Scan"
}

resource "aws_security_group_rule" "SADRtoMcAfeeagent" {
  type              = "ingress"
  from_port         = 8082
  to_port           = 8082
  protocol          = "udp"
  cidr_blocks       = ["10.224.36.128/25","10.249.16.0/25","10.184.16.0/25","10.206.222.128/25","10.248.17.0/25"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "SADR to McAfee agent"
}

resource "aws_security_group_rule" "PKICARPCDynamic" {
  type              = "ingress"
  from_port         = 49152
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["10.204.98.0/25"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "PKI CA RPC Dynamic"
}

resource "aws_security_group_rule" "PKICAKerberosTCP" {
  type              = "ingress"
  from_port         = 88
  to_port           = 88
  protocol          = "tcp"
  cidr_blocks       = ["10.204.98.0/25"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "PKI CA Kerberos TCP"
}

resource "aws_security_group_rule" "PKICAKerberosUDP" {
  type              = "ingress"
  from_port         = 88
  to_port           = 88
  protocol          = "udp"
  cidr_blocks       = ["10.204.98.0/25"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "PKI CA Kerberos UDP"
}

resource "aws_security_group_rule" "api_to_api" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "all"
  source_security_group_id = aws_security_group.turbot_api.id
  security_group_id        = aws_security_group.turbot_api.id
  description              = "Allow all traffic between Containers"
}

resource "aws_security_group_rule" "ScienceLogicSNMP" {
  type              = "ingress"
  from_port         = 161
  to_port           = 161
  protocol          = "udp"
  cidr_blocks       = ["10.249.163.96/27"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "ScienceLogic SNMP"
}

resource "aws_security_group_rule" "PKICARPC" {
  type              = "ingress"
  from_port         = 135
  to_port           = 135
  protocol          = "tcp"
  cidr_blocks       = ["10.204.98.0/25"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "PKI CA RPC"
}

resource "aws_security_group_rule" "RelayagenttoBigFixclient" {
  type              = "ingress"
  from_port         = 52311
  to_port           = 52311
  protocol          = "udp"
  cidr_blocks       = ["10.247.2.214/32"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "Relay agent to BigFix client"
}

resource "aws_security_group_rule" "Nessusweb" {
  type              = "ingress"
  from_port         = 8834
  to_port           = 8834
  protocol          = "udp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "Nessus web"
}

resource "aws_security_group_rule" "loopback" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["127.0.0.1/32"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "Loopback - to avoid adding the default egress rule"
}

resource "aws_security_group_rule" "NessusScanAccess445" {
  type              = "ingress"
  from_port         = 445
  to_port           = 445
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "Nessus Scan Access"
}

resource "aws_security_group" "turbot_alb" {
  name        = "turbot_alb_for_vaec"
  description = "Allow inbound traffic to alb and connection to api"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "alb_inbound" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.turbot_api.id
  description       = "allow inbound https"
}

resource "aws_security_group_rule" "alb_to_api" {
  type                     = "ingress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.turbot_alb.id
  security_group_id        = aws_security_group.turbot_api.id
  description              = "HTTPS from LB to API Containers"
}

resource "aws_security_group_rule" "alb_to_api_highports" {
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.turbot_alb.id
  security_group_id        = aws_security_group.turbot_api.id
  description              = "HTTPS high ports from LB to API Containers"
}

resource "aws_security_group_rule" "from_alb_to_api" {
  type                     = "egress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.turbot_api.id
  security_group_id        = aws_security_group.turbot_alb.id
  description              = "HTTPS from LB to API Containers"
}

resource "aws_security_group_rule" "from_alb_to_api_highports" {
  type                     = "egress"
  from_port                = 32768
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.turbot_api.id
  security_group_id        = aws_security_group.turbot_alb.id
  description              = "HTTPS high ports from LB to API Containers"
}