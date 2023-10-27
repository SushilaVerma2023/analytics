
-- Recorded content Viewed( Digital material->recorded content)

select 
distinct account_type,count(*) 
from mixpanel_allen_digital.revision_video_viewed rvv where "_user_id" is null group by 1 limit 10

select _app_version_string,_app_build_number,_os,max(len(duration)) as new1, min(len(duration)) as new2 
from mixpanel_allen_digital.revision_video_viewed group by 1,2,3 order by max(len(duration)) desc

select * from  mixpanel_allen_digital.revision_video_viewed where duration ='' and
--_user_id=181 and
class_title ='()' limit 10


select 
max(date((timestamp 'epoch' + time * interval '1 second'))) as maxdate
,min(date((timestamp 'epoch' + time * interval '1 second'))) as mindate
from  mixpanel_allen_digital.revision_video_viewed  


select * from mixpanel_allen_digital."_identify" where "_device_id" ='96D5092D-026C-4427-B54C-183C11FB3661'limit 19


select  m1."_device_id",count(distinct m2."_user_id") as users
--distinct m1."_device_id",m2."_user_id"  
from  mixpanel_allen_digital.revision_video_viewed m1
left join mixpanel_allen_digital."_identify" m2 on m1."_device_id" =m2."_device_id"  
where m1. "_user_id" is null group by 1 having users=1 limit 200

select * from  mixpanel_allen_digital.revision_video_viewed limit 10


select "time",_user_id,_mp_api_timestamp_ms,"_identified_id" ,distinct_id, count(*)
from mixpanel_allen_digital."_identify" group by 1,2,3,4,5 having count(*)>1  limit 10


select * from  mixpanel_allen_digital."_identify" where "_user_id" ='{"studentId":"821423"}'
and "_mp_api_timestamp_ms" =1684166326156 and "_identified_id" ='1217300' and distinct_id='1217300' 
and "time" 

select  distinct_id, count(*)
from mixpanel_allen_digital."_identify" group by 1 having count(*)>1  limit 10

select * from mixpanel_allen_digital."_identify" where "_device_id" ='18c2283f-e2e2-4cad-838b-287126dccb7d'

select *
from  mixpanel_allen_digital.revision_video_viewed m1
left join mixpanel_allen_digital."_identify" m2 on m1."_device_id" =m2."_device_id"  
where m1. "_user_id" is null limit 10
