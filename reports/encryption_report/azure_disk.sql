with compute_disk_count as (
    select count(*) as compute_disks, metadata #>> '{azure, subscriptionId}' as subscription_id
    from turbot_resource
    where filter = 'resourceTypeId:"tmod:@turbot/azure-compute#/resource/types/disk"'
    group by subscription_id
),
     compute_disk as (
         select id, metadata #>> '{azure, subscriptionId}' as subscription_id
         from turbot_resource
         where filter = 'resourceTypeId:"tmod:@turbot/azure-compute#/resource/types/disk"'
         group by id, subscription_id
     ),
     compute_unencrypted_disk as (
         select resource_id
         from turbot_control
         where filter = 'state:alarm controlTypeId:"tmod:@turbot/azure-compute#/control/types/diskApproved"'
         group by state, resource_id
     ),
     azure_sub as (
         select metadata #>> '{azure, subscriptionId}' as accountId
         from turbot_resource
         where filter = 'resourceTypeId:"tmod:@turbot/azure#/resource/types/subscription"'
         group by accountId
     )

select sub.accountId    as cloud_account,
       ec.compute_disks as volume_count,
       count(unenc.*)   as unencrypted_volumes
from azure_sub sub
         left join compute_disk_count ec on sub.accountId = ec.subscription_id
         left join compute_disk on sub.accountId = compute_disk.subscription_id
         left join compute_unencrypted_disk unenc on compute_disk.id = unenc.resource_id
group by sub.accountId, ec.compute_disks;