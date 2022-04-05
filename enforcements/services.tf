resource "turbot_smart_folder" "service_enabled" {
  parent = "tmod:@turbot/turbot#/"
  title  = "RASP AWS - Approved Services"
}

resource "turbot_policy_setting" "aws_ec2_instance_approved_usage" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/instanceApprovedUsage"
  value    = "Approved"
}

resource "turbot_policy_setting" "aws_rds_rds_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-rds#/policy/types/rdsEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_efs_efs_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-efs#/policy/types/efsEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_dynamodb_dynamodb_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-dynamodb#/policy/types/dynamodbEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_cloudtrail_cloud_trail_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-cloudtrail#/policy/types/cloudTrailEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_ecs_ecs_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-ecs#/policy/types/ecsEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_s3_s3_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-s3#/policy/types/s3Enabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_ec2_ec2_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-ec2#/policy/types/ec2Enabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_apigateway_api_gateway_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-apigateway#/policy/types/apiGatewayEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_sns_sns_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-sns#/policy/types/snsEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_ecr_ecr_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-ecr#/policy/types/ecrEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_vpc_core_vpc_service_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-vpc-core#/policy/types/vpcServiceEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_kinesis_kinesis_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-kinesis#/policy/types/kinesisEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_glacier_glacier_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-glacier#/policy/types/glacierEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_kms_kms_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-kms#/policy/types/kmsEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_lambda_lambda_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-lambda#/policy/types/lambdaEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_redshift_redshift_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-redshift#/policy/types/redshiftEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_cloudwatch_cloud_watch_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-cloudwatch#/policy/types/cloudWatchEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_elasticsearch_es_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-elasticsearch#/policy/types/esEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_athena_athena_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-athena#/policy/types/athenaEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_sqs_sqs_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-sqs#/policy/types/sqsEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_route53_route53_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-route53#/policy/types/route53Enabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_config_config_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-config#/policy/types/configEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_inspector_inspector_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-inspector#/policy/types/inspectorEnabled"
  value    = "Enabled"
}

resource "turbot_policy_setting" "aws_guardduty_guard_duty_enabled" {
  resource = turbot_smart_folder.service_enabled.id
  type     = "tmod:@turbot/aws-guardduty#/policy/types/guardDutyEnabled"
  value    = "Enabled"
}