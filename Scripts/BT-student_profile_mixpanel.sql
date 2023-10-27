--Mixpanel attributes
drop view if exists analytics.student_profile_mixpanel;

create view analytics.student_profile_mixpanel as (
select user_id
,max(case when r = 1 then _region else null end ) as region
,max(case when r = 1 then _city else null end ) as city
,max(case when r = 1 then _brand else null end ) as mobile_brand
,max(case when r = 1 and _wifi  = 'TRUE' then 1 else 0 end ) as wifi
,avg(case when r = 1 and _wifi  = 'TRUE' then 1 else 0 end *1.0) as wifi_avg
,max(case when r = 1  then _os else null end ) as os
,max(case when r = 1  then _radio else null end ) as radio

from 
(select case when _user_id like '%{%' then json_extract_path_text(_user_id,'studentId') else _user_id end  as user_id 
,timestamp 'epoch' + "time"* interval '1 second' as dtt
,* 
,ROW_NUMBER() over(partition by case when _user_id like '%{%' then json_extract_path_text(_user_id,'studentId') else _user_id end order by time desc) as r 
from mixpanel_allen_digital._ae_session 
where timestamp 'epoch' + "time"* interval '1 second' between current_date-30 and current_date
) 
 group by 1 
);

