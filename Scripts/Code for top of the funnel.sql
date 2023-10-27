--Code for top of the funnel


select
  date(launch_time) as app_date,
  case when d.distinct_id is not null then 1 else 0 end as has_login,
  case when e.distinct_id is not null then 1 else 0 end as has_app_update,
  case when datediff('second', launch_time, home_pg_time) between 0 and 2 then 'A0: 0-2'
    when datediff('second', launch_time, min(home_pg_time)) between 2 and 5 then 'A1: 2-5'
    when datediff('second', launch_time, min(home_pg_time)) between 5 and 10 then 'B: 5-10'
    when datediff('second', launch_time, min(home_pg_time)) between 10 and 20 then 'C: 10-20'
    when datediff('second', launch_time, min(home_pg_time)) between 20 and 30 then 'D: 20-30'
    when datediff('second', launch_time, min(home_pg_time)) >= 30 then 'E: >30'
    else 'NA' end as time_to_home,
  count(distinct a.distinct_id) as distinct_users,
  count(distinct case when splash_vw=1 then a.distinct_id end) as splash_screen_users,
  count(distinct case when hp=1 then a.distinct_id end) as hp_view_users,
  count(distinct concat(launch_time,a.distinct_id)) as total_launched,
  count(distinct case when splash_vw=1 then concat(launch_time,a.distinct_id) end) as splash_count,
  count(distinct case when hp=1 then concat(launch_time,a.distinct_id) end) as home_count
from
(
  select distinct distinct_id, (timestamp 'epoch' + time * interval '1 second') launch_time
  from mixpanel_allen_digital.app_launched al
  where _app_version_string='1.4.5'
    and date((timestamp 'epoch' + time * interval '1 second')) >= '2023-08-20'
) a
left join
(
  select distinct distinct_id, (timestamp 'epoch' + time * interval '1 second') splash_time, 1 as splash_vw
  from mixpanel_allen_digital.screen_viewed al
  where _app_version_string='1.4.5' and screen_name='screen_splash'
) b
on a.distinct_id=b.distinct_id
and datediff('second', launch_time, splash_time) between 0 and 30
left join
(
  select distinct distinct_id, (timestamp 'epoch' + time * interval '1 second') home_pg_time, 1 as hp
  from mixpanel_allen_digital.screen_viewed al
  where _app_version_string='1.4.5' and screen_name='screen_home'
) c
on a.distinct_id=b.distinct_id
and datediff('second', splash_time, home_pg_time) between 0 and 60
left join
(
  --- log in initiated
  select distinct distinct_id, (timestamp 'epoch' + time * interval '1 second') as log_in_time
  from mixpanel_allen_digital.login_initiated
  where date((timestamp 'epoch' + time * interval '1 second')) >= '2023-08-20'
)d
on a.distinct_id=d.distinct_id
and datediff('second', launch_time, log_in_time) between -5 and 30
left join
(
  --- app updated
  select distinct distinct_id, (timestamp 'epoch' + time * interval '1 second') as update_time
  from mixpanel_allen_digital.ae_updated
  where date((timestamp 'epoch' + time * interval '1 second')) >= '2023-08-20'
)e
on a.distinct_id=e.distinct_id
and datediff('second', launch_time, update_time) between -5 and 30
group by 1,2,3,4
;