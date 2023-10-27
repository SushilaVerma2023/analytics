
select distinct  first_week as funnel_date,
  'week' as flag, engaged_users as Enagaged_users

, round(Test*100/nullif(engaged_users,0),0) as "% via Test"

, round(Videos*100/nullif(engaged_users,0),0) as "% via Videos"

, round(QB*100/nullif(engaged_users,0),0) as "% via QB"

, round(Home*100/nullif(engaged_users,0),0) as "% via Home"

from

(

select distinct first_week

, count(user_id) as engaged_users

, count(distinct case when event_type='Test' then user_id end) as Test

, count(distinct case when event_type='Videos' then user_id end) as Videos

, count(distinct case when event_type='QB' then user_id end) as QB

, count(distinct case when event_type='Home' then user_id end) as Home

from

(

select distinct case when (test_time < video_time or video_time is null) and (test_time<home_time or home_time is null) and (test_time<home_time1 or home_time1 is null) and (test_time < qb_time or qb_time is null) then 'Test'

when (home_time < video_time or video_time is null) and (home_time<test_time or test_time is null) and (home_time<home_time1 or home_time1 is null) and (home_time < qb_time or qb_time is null) then 'Home'

when (home_time1 < video_time or video_time is null) and (home_time1<test_time or test_time is null) and (home_time1<home_time or home_time is null) and (home_time1 < qb_time or qb_time is null) then 'Home'

when (video_time < home_time or home_time is null) and (video_time<test_time or test_time is null) and (video_time<home_time1 or home_time1 is null) and (video_time < qb_time or qb_time is null) then 'Videos'

when (qb_time < home_time or home_time is null) and (qb_time<test_time or test_time is null) and (qb_time<home_time1 or home_time1 is null) and (qb_time<video_time or video_time is null) then 'QB'

end as event_type, user_id, first_week

from

(

select distinct first_week

, "_user_id" as user_id

from

(

select distinct "_user_id" , min(start_of_week) as first_week

from

(

select distinct *

from

(

select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week

, "_user_id"

, 1 as interaction

from mixpanel_allen_next.start_test_clicked

)

union all

(

select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week

, "_user_id"

, 1 as interaction

from mixpanel_allen_next.video_start

)

union all

(

select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week

, "_user_id"

, 1 as interaction

from mixpanel_allen_next.quiz_yourself_option_clicked

)

union all

(

select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week

, "_user_id"

, 1 as interaction

from mixpanel_allen_next.qb_startqbank_clicked

)

union all

(

select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week

, "_user_id"

, 1 as interaction

from mixpanel_allen_next.daily_dose_video_played

)

)

group by 1

)

)

left join

(

select distinct min(timestamp 'epoch' + time * interval '1 second') AS test_time

, "_user_id" as user_id

from mixpanel_allen_next.start_test_clicked

group by 2

)

using(user_id)

left join

(

select distinct min(timestamp 'epoch' + time * interval '1 second') AS video_time

, "_user_id" as user_id

from mixpanel_allen_next.video_start

group by 2

)

using(user_id)

left join

(

select distinct min(timestamp 'epoch' + time * interval '1 second') AS home_time

, "_user_id" as user_id

from mixpanel_allen_next.quiz_yourself_option_clicked

group by 2

)

using(user_id)

left join

(

select distinct min(timestamp 'epoch' + time * interval '1 second') AS qb_time

, "_user_id" as user_id

from mixpanel_allen_next.qb_startqbank_clicked

group by 2

)

using(user_id)

left join

(

select distinct min(timestamp 'epoch' + time * interval '1 second') AS home_time1

, "_user_id" as user_id

from mixpanel_allen_next.daily_dose_video_played

group by 2

)

using(user_id)

)

group by 1

)

order by 1 desc


