with ec2_volumes_count as (
    select count(*) as ec2_vols, metadata #>> '{aws, accountId}' as accountId
    from turbot_resource
    where filter = 'resourceTypeId:"tmod:@turbot/aws-ec2#/resource/types/volume"'
    group by accountId
),
     ec2_volumes as (
         select id, metadata #>> '{aws, accountId}' as accountId
         from turbot_resource
         where filter = 'resourceTypeId:"tmod:@turbot/aws-ec2#/resource/types/volume"'
         group by id, accountId
     ),
     ec2_unencrypted_volumes as (
         select resource_id
         from turbot_control
         where filter = 'state:alarm controlTypeId:"tmod:@turbot/aws-ec2#/control/types/volumeApproved"'
         group by state, resource_id
     ),
     aws_accounts as (
         select metadata #>> '{aws, accountId}' as accountId
         from turbot_resource
         where filter = 'resourceTypeId:"tmod:@turbot/aws#/resource/types/account"'
         group by accountId
     )
select acc.accountId  as cloud_account,
       ec.ec2_vols    as volume_count,
       count(unenc.*) as unencrypted_volumes
from aws_accounts acc
         left join ec2_volumes_count ec on acc.accountId = ec.accountId
         left join ec2_volumes on acc.accountId = ec2_volumes.accountId
         left join ec2_unencrypted_volumes unenc on ec2_volumes.id = unenc.resource_id
group by acc.accountId, ec.ec2_vols;