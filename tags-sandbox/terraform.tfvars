###  Check this for correct value on Prod
org_arn = "arn:aws-us-gov:organizations::348286891446:account/o-fgsg4ev0lb"
#org_arn = "arn:aws:organizations::676944191433:account/o-c3a5y4wd52"

non_vpc_resource_tags = {
  aws-acm-certificate                      = "Enforce: Set tags"
  aws-apigateway-api                       = "Enforce: Set tags"
  aws-apigateway-stage                     = "Enforce: Set tags"
  aws-appstream-fleet                      = "Enforce: Set tags"
  aws-appstream-image                      = "Enforce: Set tags"
  aws-athena-namedQuery                    = "Enforce: Set tags"
  aws-athena-workgroup                     = "Enforce: Set tags"
  aws-cloudtrail-trail                     = "Enforce: Set tags"
  aws-cloudwatch-alarm                     = "Enforce: Set tags"
  aws-codebuild-project                    = "Enforce: Set tags"
  aws-codecommit-repository                = "Enforce: Set tags"
  aws-config-rule                          = "Enforce: Set tags"
  aws-dynamodb-table                       = "Enforce: Set tags"
  aws-ec2-ami                              = "Enforce: Set tags"
  aws-ec2-autoScalingGroup                 = "Enforce: Set tags"
  aws-ec2-launchTemplate                   = "Enforce: Set tags"
  aws-ec2-targetGroup                      = "Enforce: Set tags"
  aws-ecr-repository                       = "Enforce: Set tags"
  aws-elasticache-snapshot                 = "Enforce: Set tags"
  aws-elasticsearch-domain                 = "Enforce: Set tags"
  aws-glacier-vault                        = "Enforce: Set tags"
  aws-glue-crawler                         = "Enforce: Set tags"
  aws-glue-dev-endpoint                    = "Enforce: Set tags"
  aws-glue-job                             = "Enforce: Set tags"
  aws-glue-ml-transform                    = "Enforce: Set tags"
  aws-glue-trigger                         = "Enforce: Set tags"
  aws-glue-workflow                        = "Enforce: Set tags"
  aws-inspector-assessmentTemplate         = "Enforce: Set tags"
  aws-kinesis-stream                       = "Enforce: Set tags"
  aws-kms-key                              = "Enforce: Set tags"
  aws-lambda-function                      = "Enforce: Set tags"
  aws-logs-logGroup                        = "Enforce: Set tags"
  aws-rds-dbClusterParameterGroup          = "Enforce: Set tags"
  aws-rds-dbClusterSnapshotManual          = "Enforce: Set tags"
  aws-rds-dbParameterGroup                 = "Enforce: Set tags"
  aws-rds-dbSnapshotManual                 = "Enforce: Set tags"
  aws-rds-optionGroup                      = "Enforce: Set tags"
  aws-redshift-clusterParameterGroup       = "Enforce: Set tags"
  aws-redshift-clusterSnapshotManual       = "Enforce: Set tags"
  aws-s3-bucket                            = "Enforce: Set tags"
  aws-secretsmanager-secret                = "Enforce: Set tags"
  aws-sns-topic                            = "Enforce: Set tags"
  aws-sqs-queue                            = "Enforce: Set tags"
  aws-ssm-document                         = "Enforce: Set tags"
  aws-ssm-maintenanceWindow                = "Enforce: Set tags"
  aws-stepfunctions-stateMachine           = "Enforce: Set tags"
  ####
  aws-iam-role                         = "Enforce: Set tags"
  aws-iam-user                         = "Enforce: Set tags"
  aws-route53-hostedZone               = "Enforce: Set tags"
  aws-waf-webacl                       = "Enforce: Set tags"
}

vpc_unreferenced_tags = {
  aws-vpc-core-dhcpOptions                    = "Enforce: Set tags"
  aws-ecs-cluster                             = "Enforce: Set tags"
  aws-elasticache-cacheCluster                = "Enforce: Set tags" 
  aws-workspaces-workspace                    = "Enforce: Set tags"
  aws-rds-dbCluster                           = "Enforce: Set tags"
  aws-vpc-connect-vpnConnection               = "Enforce: Set tags"
  aws-vpc-connect-customerGateway             = "Enforce: Set tags"
  aws-vpc-connect-transitGateway              = "Enforce: Set tags"
  aws-vpc-connect-transitGatewayRouteTable    = "Enforce: Set tags"
}

vpc_child_resource_tags = {
  aws-vpc-connect-vpcPeeringConnection = "Enforce: Set tags"
  aws-vpc-core-routeTable              = "Enforce: Set tags"
  aws-vpc-core-subnet                  = "Enforce: Set tags"
  aws-vpc-internet-elasticIp           = "Enforce: Set tags"
  aws-vpc-internet-vpcEndpoint         = "Enforce: Set tags"
  aws-vpc-internet-vpcEndpointService  = "Enforce: Set tags"
  aws-vpc-security-flowLog             = "Enforce: Set tags"
  aws-vpc-security-networkAcl          = "Enforce: Set tags"
  aws-vpc-security-securityGroup       = "Enforce: Set tags"

}

vpc_referenced_tags = {
  aws-ec2-classicLoadBalancer                = "Enforce: Set tags"
  aws-ec2-applicationLoadBalancer            = "Enforce: Set tags"
  aws-ec2-networkLoadBalancer                = "Enforce: Set tags"
  aws-ec2-instance                           = "Enforce: Set tags"
  aws-ec2-networkInterface                   = "Enforce: Set tags"
  aws-eks-cluster                            = "Enforce: Set tags"
  aws-rds-dbInstance                         = "Enforce: Set tags"
  aws-rds-subnetGroup                        = "Enforce: Set tags"
  aws-redshift-cluster                       = "Enforce: Set tags"
  aws-redshift-clusterSubnetGroup            = "Enforce: Set tags"
  aws-vpc-connect-vpnGateway                 = "Enforce: Set tags"
  aws-vpc-internet-egressOnlyInternetGateway = "Enforce: Set tags"
  aws-vpc-internet-internetGateway           = "Enforce: Set tags"
}

vpc_referenced_resource_map = {
  aws-ec2-classicLoadBalancer                = "VPCId"
  aws-ec2-applicationLoadBalancer            = "VpcId"
  aws-ec2-networkLoadBalancer                = "VpcId"
  aws-ec2-instance                           = "VpcId"
  aws-ec2-networkInterface                   = "VpcId"
  aws-rds-subnetGroup                        = "VpcId"
  aws-redshift-cluster                       = "VpcId"
  aws-redshift-clusterSubnetGroup            = "VpcId"
  aws-vpc-connect-vpnGateway                 = "VpcAttachments[0].VpcId"
  aws-vpc-internet-egressOnlyInternetGateway = "turbot.custom.VpcId"
  aws-vpc-internet-internetGateway           = "Attachments[0].VpcId"
  aws-eks-cluster                            = "resourcesVpcConfig.vpcId"
  aws-rds-dbInstance                         = "DBSubnetGroup.VpcId"
}

## Mapping of resource name to resource tag policy
policy_map = {
  aws-acm-certificate                        = "tmod:@turbot/aws-acm#/policy/types/certificateTags"
  aws-amplify-app                            = "tmod:@turbot/aws-amplify#/policy/types/appTags"
  aws-apigateway-api                         = "tmod:@turbot/aws-apigateway#/policy/types/apiTags"
  aws-apigateway-stage                       = "tmod:@turbot/aws-apigateway#/policy/types/stageTags"
  aws-appstream-fleet                        = "tmod:@turbot/aws-appstream#/policy/types/fleetTags"
  aws-appstream-image                        = "tmod:@turbot/aws-appstream#/policy/types/imageTags"
  aws-appstream-imageBuilder                 = "tmod:@turbot/aws-appstream#/policy/types/imageBuilderTags"
  aws-athena-namedQuery                      = "tmod:@turbot/aws-athena#/policy/types/namedQueryTags"
  aws-athena-workgroup                       = "tmod:@turbot/aws-athena#/policy/types/workgroupTags"
  aws-backup-backupPlan                      = "tmod:@turbot/aws-backup#/policy/types/backupPlanTags"
  aws-backup-backupVault                     = "tmod:@turbot/aws-backup#/policy/types/backupVaultTags"
  aws-cloudformation-stack                   = "tmod:@turbot/aws-cloudformation#/policy/types/stackTags"
  aws-cloudfront-distribution                = "tmod:@turbot/aws-cloudfront#/policy/types/distributionTags"
  aws-cloudfront-streamingDistribution       = "tmod:@turbot/aws-cloudfront#/policy/types/streamingDistributionTags"
  aws-cloudtrail-trail                       = "tmod:@turbot/aws-cloudtrail#/policy/types/trailTags"
  aws-cloudwatch-alarm                       = "tmod:@turbot/aws-cloudwatch#/policy/types/alarmTags"
  aws-codebuild-project                      = "tmod:@turbot/aws-codebuild#/policy/types/projectTags"
  aws-codecommit-repository                  = "tmod:@turbot/aws-codecommit#/policy/types/repositoryTags"
  aws-config-rule                            = "tmod:@turbot/aws-config#/policy/types/ruleTags"
  aws-dax-cluster                            = "tmod:@turbot/aws-dax#/policy/types/clusterTags"
  aws-directoryservice-directory             = "tmod:@turbot/aws-directoryservice#/policy/types/directoryTags"
  aws-docdb-dbCluster                        = "tmod:@turbot/aws-docdb#/policy/types/dbClusterTags"
  aws-docdb-dbInstance                       = "tmod:@turbot/aws-docdb#/policy/types/dbInstanceTags"
  aws-dynamodb-table                         = "tmod:@turbot/aws-dynamodb#/policy/types/tableTags"
  aws-ec2-ami                                = "tmod:@turbot/aws-ec2#/policy/types/amiTags"
  aws-ec2-applicationLoadBalancer            = "tmod:@turbot/aws-ec2#/policy/types/applicationLoadBalancerTags"
  aws-ec2-autoScalingGroup                   = "tmod:@turbot/aws-ec2#/policy/types/autoScalingGroupTags"
  aws-ec2-classicLoadBalancer                = "tmod:@turbot/aws-ec2#/policy/types/classicLoadBalancerTags"
  aws-ec2-instance                           = "tmod:@turbot/aws-ec2#/policy/types/instanceTags"
  aws-ec2-launchTemplate                     = "tmod:@turbot/aws-ec2#/policy/types/launchTemplateTags"
  aws-ec2-networkInterface                   = "tmod:@turbot/aws-ec2#/policy/types/networkInterfaceTags"
  aws-ec2-networkLoadBalancer                = "tmod:@turbot/aws-ec2#/policy/types/networkLoadBalancerTags"
  aws-ec2-snapshot                           = "tmod:@turbot/aws-ec2#/policy/types/snapshotTags"
  aws-ec2-targetGroup                        = "tmod:@turbot/aws-ec2#/policy/types/targetGroupTags"
  aws-ec2-volume                             = "tmod:@turbot/aws-ec2#/policy/types/volumeTags"
  aws-ecr-repository                         = "tmod:@turbot/aws-ecr#/policy/types/repositoryTags"
  aws-ecs-cluster                            = "tmod:@turbot/aws-ecs#/policy/types/clusterTags"
  aws-efs-fileSystem                         = "tmod:@turbot/aws-efs#/policy/types/fileSystemTags"
  aws-eks-cluster                            = "tmod:@turbot/aws-eks#/policy/types/clusterTags"
  aws-elasticache-cacheCluster               = "tmod:@turbot/aws-elasticache#/policy/types/cacheClusterTags"
  aws-elasticache-snapshot                   = "tmod:@turbot/aws-elasticache#/policy/types/snapshotTags"
  aws-elasticbeanstalk-application           = "tmod:@turbot/aws-elasticbeanstalk#/policy/types/applicationTags"
  aws-elasticbeanstalk-environment           = "tmod:@turbot/aws-elasticbeanstalk#/policy/types/environmentTags"
  aws-elasticsearch-domain                   = "tmod:@turbot/aws-elasticsearch#/policy/types/domainTags"
  aws-emr-cluster                            = "tmod:@turbot/aws-emr#/policy/types/clusterTags"
  aws-fsx-backup                             = "tmod:@turbot/aws-fsx#/policy/types/backupTags"
  aws-fsx-fileSystem                         = "tmod:@turbot/aws-fsx#/policy/types/fileSystemTags"
  aws-glacier-vault                          = "tmod:@turbot/aws-glacier#/policy/types/vaultTags"
  aws-glue-crawler                           = "tmod:@turbot/aws-glue#/policy/types/crawlerTags"
  aws-glue-dev-endpoint                      = "tmod:@turbot/aws-glue#/policy/types/devEndpointTags"
  aws-glue-job                               = "tmod:@turbot/aws-glue#/policy/types/jobTags"
  aws-glue-ml-transform                      = "tmod:@turbot/aws-glue#/policy/types/mlTransformTags"
  aws-glue-trigger                           = "tmod:@turbot/aws-glue#/policy/types/triggerTags"
  aws-glue-workflow                          = "tmod:@turbot/aws-glue#/policy/types/workflowTags"
  aws-guardduty-detector                     = "tmod:@turbot/aws-guardduty#/policy/types/detectorTags"
  aws-guardduty-ipSet                        = "tmod:@turbot/aws-guardduty#/policy/types/ipSetTags"
  aws-guardduty-threatIntelSet               = "tmod:@turbot/aws-guardduty#/policy/types/threatIntelSetTags"
  aws-iam-role                               = "tmod:@turbot/aws-iam#/policy/types/roleTags"
  aws-iam-user                               = "tmod:@turbot/aws-iam#/policy/types/userTags"
  aws-inspector-assessmentTemplate           = "tmod:@turbot/aws-inspector#/policy/types/assessmentTemplateTags"
  aws-kinesis-stream                         = "tmod:@turbot/aws-kinesis#/policy/types/streamTags"
  aws-kms-key                                = "tmod:@turbot/aws-kms#/policy/types/keyTags"
  aws-lambda-function                        = "tmod:@turbot/aws-lambda#/policy/types/functionTags"
  aws-logs-logGroup                          = "tmod:@turbot/aws-logs#/policy/types/logGroupTags"
  aws-mq-broker                              = "tmod:@turbot/aws-mq#/policy/types/brokerTags"
  aws-mq-configuration                       = "tmod:@turbot/aws-mq#/policy/types/configurationTags"
  aws-msk-cluster                            = "tmod:@turbot/aws-msk#/policy/types/clusterTags"
  aws-neptune-dbCluster                      = "tmod:@turbot/aws-neptune#/policy/types/dbClusterTags"
  aws-neptune-dbInstance                     = "tmod:@turbot/aws-neptune#/policy/types/dbInstanceTags"
  aws-qldb-ledger                            = "tmod:@turbot/aws-qldb#/policy/types/ledgerTags"
  aws-ram-resourceShare                      = "tmod:@turbot/aws-ram#/policy/types/resourceShareTags"
  aws-rds-dbCluster                          = "tmod:@turbot/aws-rds#/policy/types/dbClusterTags"
  aws-rds-dbClusterParameterGroup            = "tmod:@turbot/aws-rds#/policy/types/dbClusterParameterGroupTags"
  aws-rds-dbClusterSnapshotManual            = "tmod:@turbot/aws-rds#/policy/types/dbClusterSnapshotManualTags"
  aws-rds-dbInstance                         = "tmod:@turbot/aws-rds#/policy/types/dbInstanceTags"
  aws-rds-dbParameterGroup                   = "tmod:@turbot/aws-rds#/policy/types/dbParameterGroupTags"
  aws-rds-dbSnapshotManual                   = "tmod:@turbot/aws-rds#/policy/types/dbSnapshotManualTags"
  aws-rds-optionGroup                        = "tmod:@turbot/aws-rds#/policy/types/optionGroupTags"
  aws-rds-subnetGroup                        = "tmod:@turbot/aws-rds#/policy/types/subnetGroupTags"
  aws-redshift-cluster                       = "tmod:@turbot/aws-redshift#/policy/types/clusterTags"
  aws-redshift-clusterParameterGroup         = "tmod:@turbot/aws-redshift#/policy/types/clusterParameterGroupTags"
  aws-redshift-clusterSnapshotManual         = "tmod:@turbot/aws-redshift#/policy/types/clusterSnapshotManualTags"
  aws-redshift-clusterSubnetGroup            = "tmod:@turbot/aws-redshift#/policy/types/clusterSubnetGroupTags"
  aws-route53-hostedZone                     = "tmod:@turbot/aws-route53#/policy/types/hostedZoneTags"
  aws-s3-bucket                              = "tmod:@turbot/aws-s3#/policy/types/bucketTags"
  aws-secretsmanager-secret                  = "tmod:@turbot/aws-secretsmanager#/policy/types/secretTags"
  aws-securityhub-hub                        = "tmod:@turbot/aws-securityhub#/policy/types/hubTags"
  aws-sns-topic                              = "tmod:@turbot/aws-sns#/policy/types/topicTags"
  aws-sqs-queue                              = "tmod:@turbot/aws-sqs#/policy/types/queueTags"
  aws-ssm-document                           = "tmod:@turbot/aws-ssm#/policy/types/documentTags"
  aws-ssm-maintenanceWindow                  = "tmod:@turbot/aws-ssm#/policy/types/maintenanceWindowTags"
  aws-stepfunctions-stateMachine             = "tmod:@turbot/aws-stepfunctions#/policy/types/stateMachineTags"
  aws-vpc-connect-customerGateway            = "tmod:@turbot/aws-vpc-connect#/policy/types/customerGatewayTags"
  aws-vpc-connect-transitGateway             = "tmod:@turbot/aws-vpc-connect#/policy/types/transitGatewayTags"
  aws-vpc-connect-transitGatewayRouteTable   = "tmod:@turbot/aws-vpc-connect#/policy/types/transitGatewayRouteTableTags"
  aws-vpc-connect-vpcPeeringConnection       = "tmod:@turbot/aws-vpc-connect#/policy/types/vpcPeeringConnectionTags"
  aws-vpc-connect-vpnConnection              = "tmod:@turbot/aws-vpc-connect#/policy/types/vpnConnectionTags"
  aws-vpc-connect-vpnGateway                 = "tmod:@turbot/aws-vpc-connect#/policy/types/vpnGatewayTags"
  aws-vpc-core-dhcpOptions                   = "tmod:@turbot/aws-vpc-core#/policy/types/dhcpOptionsTags"
  aws-vpc-core-routeTable                    = "tmod:@turbot/aws-vpc-core#/policy/types/routeTableTags"
  aws-vpc-core-subnet                        = "tmod:@turbot/aws-vpc-core#/policy/types/subnetTags"
  aws-vpc-core-vpc                           = "tmod:@turbot/aws-vpc-core#/policy/types/vpcTags"
  aws-vpc-internet-egressOnlyInternetGateway = "tmod:@turbot/aws-vpc-internet#/policy/types/egressOnlyInternetGatewayTags"
  aws-vpc-internet-elasticIp                 = "tmod:@turbot/aws-vpc-internet#/policy/types/elasticIpTags"
  aws-vpc-internet-internetGateway           = "tmod:@turbot/aws-vpc-internet#/policy/types/internetGatewayTags"
  aws-vpc-internet-natGateway                = "tmod:@turbot/aws-vpc-internet#/policy/types/natGatewayTags"
  aws-vpc-internet-vpcEndpoint               = "tmod:@turbot/aws-vpc-internet#/policy/types/vpcEndpointTags"
  aws-vpc-internet-vpcEndpointService        = "tmod:@turbot/aws-vpc-internet#/policy/types/vpcEndpointServiceTags"
  aws-vpc-security-flowLog                   = "tmod:@turbot/aws-vpc-security#/policy/types/flowLogTags"
  aws-vpc-security-networkAcl                = "tmod:@turbot/aws-vpc-security#/policy/types/networkAclTags"
  aws-vpc-security-securityGroup             = "tmod:@turbot/aws-vpc-security#/policy/types/securityGroupTags"
  aws-waf-webacl                             = "tmod:@turbot/aws-waf#/policy/types/webaclTags"
  aws-workspaces-workspace                   = "tmod:@turbot/aws-workspaces#/policy/types/workspaceTags"
}

## Mapping of resource name to resource tag policy template
policy_map_template = {
  aws-acm-certificate                        = "tmod:@turbot/aws-acm#/policy/types/certificateTagsTemplate"
  aws-amplify-app                            = "tmod:@turbot/aws-amplify#/policy/types/appTagsTemplate"
  aws-apigateway-api                         = "tmod:@turbot/aws-apigateway#/policy/types/apiTagsTemplate"
  aws-apigateway-stage                       = "tmod:@turbot/aws-apigateway#/policy/types/stageTagsTemplate"
  aws-appstream-fleet                        = "tmod:@turbot/aws-appstream#/policy/types/fleetTagsTemplate"
  aws-appstream-image                        = "tmod:@turbot/aws-appstream#/policy/types/imageTagsTemplate"
  aws-appstream-imageBuilder                 = "tmod:@turbot/aws-appstream#/policy/types/imageBuilderTagsTemplate"
  aws-athena-namedQuery                      = "tmod:@turbot/aws-athena#/policy/types/namedQueryTagsTemplate"
  aws-athena-workgroup                       = "tmod:@turbot/aws-athena#/policy/types/workgroupTagsTemplate"
  aws-backup-backupPlan                      = "tmod:@turbot/aws-backup#/policy/types/backupPlanTagsTemplate"
  aws-backup-backupVault                     = "tmod:@turbot/aws-backup#/policy/types/backupVaultTagsTemplate"
  aws-cloudformation-stack                   = "tmod:@turbot/aws-cloudformation#/policy/types/stackTagsTemplate"
  aws-cloudfront-distribution                = "tmod:@turbot/aws-cloudfront#/policy/types/distributionTagsTemplate"
  aws-cloudfront-streamingDistribution       = "tmod:@turbot/aws-cloudfront#/policy/types/streamingDistributionTagsTemplate"
  aws-cloudtrail-trail                       = "tmod:@turbot/aws-cloudtrail#/policy/types/trailTagsTemplate"
  aws-cloudwatch-alarm                       = "tmod:@turbot/aws-cloudwatch#/policy/types/alarmTagsTemplate"
  aws-codebuild-project                      = "tmod:@turbot/aws-codebuild#/policy/types/projectTagsTemplate"
  aws-codecommit-repository                  = "tmod:@turbot/aws-codecommit#/policy/types/repositoryTagsTemplate"
  aws-config-rule                            = "tmod:@turbot/aws-config#/policy/types/ruleTagsTemplate"
  aws-dax-cluster                            = "tmod:@turbot/aws-dax#/policy/types/clusterTagsTemplate"
  aws-directoryservice-directory             = "tmod:@turbot/aws-directoryservice#/policy/types/directoryTagsTemplate"
  aws-docdb-dbCluster                        = "tmod:@turbot/aws-docdb#/policy/types/dbClusterTagsTemplate"
  aws-docdb-dbInstance                       = "tmod:@turbot/aws-docdb#/policy/types/dbInstanceTagsTemplate"
  aws-dynamodb-table                         = "tmod:@turbot/aws-dynamodb#/policy/types/tableTagsTemplate"
  aws-ec2-ami                                = "tmod:@turbot/aws-ec2#/policy/types/amiTagsTemplate"
  aws-ec2-applicationLoadBalancer            = "tmod:@turbot/aws-ec2#/policy/types/applicationLoadBalancerTagsTemplate"
  aws-ec2-autoScalingGroup                   = "tmod:@turbot/aws-ec2#/policy/types/autoScalingGroupTagsTemplate"
  aws-ec2-classicLoadBalancer                = "tmod:@turbot/aws-ec2#/policy/types/classicLoadBalancerTagsTemplate"
  aws-ec2-instance                           = "tmod:@turbot/aws-ec2#/policy/types/instanceTagsTemplate"
  aws-ec2-launchTemplate                     = "tmod:@turbot/aws-ec2#/policy/types/launchTemplateTagsTemplate"
  aws-ec2-networkInterface                   = "tmod:@turbot/aws-ec2#/policy/types/networkInterfaceTagsTemplate"
  aws-ec2-networkLoadBalancer                = "tmod:@turbot/aws-ec2#/policy/types/networkLoadBalancerTagsTemplate"
  aws-ec2-snapshot                           = "tmod:@turbot/aws-ec2#/policy/types/snapshotTagsTemplate"
  aws-ec2-targetGroup                        = "tmod:@turbot/aws-ec2#/policy/types/targetGroupTagsTemplate"
  aws-ec2-volume                             = "tmod:@turbot/aws-ec2#/policy/types/volumeTagsTemplate"
  aws-ecr-repository                         = "tmod:@turbot/aws-ecr#/policy/types/repositoryTagsTemplate"
  aws-ecs-cluster                            = "tmod:@turbot/aws-ecs#/policy/types/clusterTagsTemplate"
  aws-efs-fileSystem                         = "tmod:@turbot/aws-efs#/policy/types/fileSystemTagsTemplate"
  aws-eks-cluster                            = "tmod:@turbot/aws-eks#/policy/types/clusterTagsTemplate"
  aws-elasticache-cacheCluster               = "tmod:@turbot/aws-elasticache#/policy/types/cacheClusterTagsTemplate"
  aws-elasticache-snapshot                   = "tmod:@turbot/aws-elasticache#/policy/types/snapshotTagsTemplate"
  aws-elasticbeanstalk-application           = "tmod:@turbot/aws-elasticbeanstalk#/policy/types/applicationTagsTemplate"
  aws-elasticbeanstalk-environment           = "tmod:@turbot/aws-elasticbeanstalk#/policy/types/environmentTagsTemplate"
  aws-elasticsearch-domain                   = "tmod:@turbot/aws-elasticsearch#/policy/types/domainTagsTemplate"
  aws-emr-cluster                            = "tmod:@turbot/aws-emr#/policy/types/clusterTagsTemplate"
  aws-fsx-backup                             = "tmod:@turbot/aws-fsx#/policy/types/backupTagsTemplate"
  aws-fsx-fileSystem                         = "tmod:@turbot/aws-fsx#/policy/types/fileSystemTagsTemplate"
  aws-glacier-vault                          = "tmod:@turbot/aws-glacier#/policy/types/vaultTagsTemplate"
  aws-glue-crawler                           = "tmod:@turbot/aws-glue#/policy/types/crawlerTagsTemplate"
  aws-glue-dev-endpoint                      = "tmod:@turbot/aws-glue#/policy/types/devEndpointTagsTemplate"
  aws-glue-job                               = "tmod:@turbot/aws-glue#/policy/types/jobTagsTemplate"
  aws-glue-ml-transform                      = "tmod:@turbot/aws-glue#/policy/types/mlTransformTagsTemplate"
  aws-glue-trigger                           = "tmod:@turbot/aws-glue#/policy/types/triggerTagsTemplate"
  aws-glue-workflow                          = "tmod:@turbot/aws-glue#/policy/types/workflowTagsTemplate"
  aws-guardduty-detector                     = "tmod:@turbot/aws-guardduty#/policy/types/detectorTagsTemplate"
  aws-guardduty-ipSet                        = "tmod:@turbot/aws-guardduty#/policy/types/ipSetTagsTemplate"
  aws-guardduty-threatIntelSet               = "tmod:@turbot/aws-guardduty#/policy/types/threatIntelSetTagsTemplate"
  aws-iam-role                               = "tmod:@turbot/aws-iam#/policy/types/roleTagsTemplate"
  aws-iam-user                               = "tmod:@turbot/aws-iam#/policy/types/userTagsTemplate"
  aws-inspector-assessmentTemplate           = "tmod:@turbot/aws-inspector#/policy/types/assessmentTemplateTagsTemplate"
  aws-kinesis-stream                         = "tmod:@turbot/aws-kinesis#/policy/types/streamTagsTemplate"
  aws-kms-key                                = "tmod:@turbot/aws-kms#/policy/types/keyTagsTemplate"
  aws-lambda-function                        = "tmod:@turbot/aws-lambda#/policy/types/functionTagsTemplate"
  aws-logs-logGroup                          = "tmod:@turbot/aws-logs#/policy/types/logGroupTagsTemplate"
  aws-mq-broker                              = "tmod:@turbot/aws-mq#/policy/types/brokerTagsTemplate"
  aws-mq-configuration                       = "tmod:@turbot/aws-mq#/policy/types/configurationTagsTemplate"
  aws-msk-cluster                            = "tmod:@turbot/aws-msk#/policy/types/clusterTagsTemplate"
  aws-neptune-dbCluster                      = "tmod:@turbot/aws-neptune#/policy/types/dbClusterTagsTemplate"
  aws-neptune-dbInstance                     = "tmod:@turbot/aws-neptune#/policy/types/dbInstanceTagsTemplate"
  aws-qldb-ledger                            = "tmod:@turbot/aws-qldb#/policy/types/ledgerTagsTemplate"
  aws-ram-resourceShare                      = "tmod:@turbot/aws-ram#/policy/types/resourceShareTagsTemplate"
  aws-rds-dbCluster                          = "tmod:@turbot/aws-rds#/policy/types/dbClusterTagsTemplate"
  aws-rds-dbClusterParameterGroup            = "tmod:@turbot/aws-rds#/policy/types/dbClusterParameterGroupTagsTemplate"
  aws-rds-dbClusterSnapshotManual            = "tmod:@turbot/aws-rds#/policy/types/dbClusterSnapshotManualTagsTemplate"
  aws-rds-dbInstance                         = "tmod:@turbot/aws-rds#/policy/types/dbInstanceTagsTemplate"
  aws-rds-dbParameterGroup                   = "tmod:@turbot/aws-rds#/policy/types/dbParameterGroupTagsTemplate"
  aws-rds-dbSnapshotManual                   = "tmod:@turbot/aws-rds#/policy/types/dbSnapshotManualTagsTemplate"
  aws-rds-optionGroup                        = "tmod:@turbot/aws-rds#/policy/types/optionGroupTagsTemplate"
  aws-rds-subnetGroup                        = "tmod:@turbot/aws-rds#/policy/types/subnetGroupTagsTemplate"
  aws-redshift-cluster                       = "tmod:@turbot/aws-redshift#/policy/types/clusterTagsTemplate"
  aws-redshift-clusterParameterGroup         = "tmod:@turbot/aws-redshift#/policy/types/clusterParameterGroupTagsTemplate"
  aws-redshift-clusterSnapshotManual         = "tmod:@turbot/aws-redshift#/policy/types/clusterSnapshotManualTagsTemplate"
  aws-redshift-clusterSubnetGroup            = "tmod:@turbot/aws-redshift#/policy/types/clusterSubnetGroupTagsTemplate"
  aws-route53-hostedZone                     = "tmod:@turbot/aws-route53#/policy/types/hostedZoneTagsTemplate"
  aws-s3-bucket                              = "tmod:@turbot/aws-s3#/policy/types/bucketTagsTemplate"
  aws-secretsmanager-secret                  = "tmod:@turbot/aws-secretsmanager#/policy/types/secretTagsTemplate"
  aws-securityhub-hub                        = "tmod:@turbot/aws-securityhub#/policy/types/hubTagsTemplate"
  aws-sns-topic                              = "tmod:@turbot/aws-sns#/policy/types/topicTagsTemplate"
  aws-sqs-queue                              = "tmod:@turbot/aws-sqs#/policy/types/queueTagsTemplate"
  aws-ssm-document                           = "tmod:@turbot/aws-ssm#/policy/types/documentTagsTemplate"
  aws-ssm-maintenanceWindow                  = "tmod:@turbot/aws-ssm#/policy/types/maintenanceWindowTagsTemplate"
  aws-stepfunctions-stateMachine             = "tmod:@turbot/aws-stepfunctions#/policy/types/stateMachineTagsTemplate"
  aws-vpc-connect-customerGateway            = "tmod:@turbot/aws-vpc-connect#/policy/types/customerGatewayTagsTemplate"
  aws-vpc-connect-transitGateway             = "tmod:@turbot/aws-vpc-connect#/policy/types/transitGatewayTagsTemplate"
  aws-vpc-connect-transitGatewayRouteTable   = "tmod:@turbot/aws-vpc-connect#/policy/types/transitGatewayRouteTableTagsTemplate"
  aws-vpc-connect-vpcPeeringConnection       = "tmod:@turbot/aws-vpc-connect#/policy/types/vpcPeeringConnectionTagsTemplate"
  aws-vpc-connect-vpnConnection              = "tmod:@turbot/aws-vpc-connect#/policy/types/vpnConnectionTagsTemplate"
  aws-vpc-connect-vpnGateway                 = "tmod:@turbot/aws-vpc-connect#/policy/types/vpnGatewayTagsTemplate"
  aws-vpc-core-dhcpOptions                   = "tmod:@turbot/aws-vpc-core#/policy/types/dhcpOptionsTagsTemplate"
  aws-vpc-core-routeTable                    = "tmod:@turbot/aws-vpc-core#/policy/types/routeTableTagsTemplate"
  aws-vpc-core-subnet                        = "tmod:@turbot/aws-vpc-core#/policy/types/subnetTagsTemplate"
  aws-vpc-core-vpc                           = "tmod:@turbot/aws-vpc-core#/policy/types/vpcTagsTemplate"
  aws-vpc-internet-egressOnlyInternetGateway = "tmod:@turbot/aws-vpc-internet#/policy/types/egressOnlyInternetGatewayTagsTemplate"
  aws-vpc-internet-elasticIp                 = "tmod:@turbot/aws-vpc-internet#/policy/types/elasticIpTagsTemplate"
  aws-vpc-internet-internetGateway           = "tmod:@turbot/aws-vpc-internet#/policy/types/internetGatewayTagsTemplate"
  aws-vpc-internet-natGateway                = "tmod:@turbot/aws-vpc-internet#/policy/types/natGatewayTagsTemplate"
  aws-vpc-internet-vpcEndpoint               = "tmod:@turbot/aws-vpc-internet#/policy/types/vpcEndpointTagsTemplate"
  aws-vpc-internet-vpcEndpointService        = "tmod:@turbot/aws-vpc-internet#/policy/types/vpcEndpointServiceTagsTemplate"
  aws-vpc-security-flowLog                   = "tmod:@turbot/aws-vpc-security#/policy/types/flowLogTagsTemplate"
  aws-vpc-security-networkAcl                = "tmod:@turbot/aws-vpc-security#/policy/types/networkAclTagsTemplate"
  aws-vpc-security-securityGroup             = "tmod:@turbot/aws-vpc-security#/policy/types/securityGroupTagsTemplate"
  aws-waf-webacl                             = "tmod:@turbot/aws-waf#/policy/types/webaclTagsTemplate"
  aws-workspaces-workspace                   = "tmod:@turbot/aws-workspaces#/policy/types/workspaceTagsTemplate"
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
  {%- set approved_combos = "" -%}
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
