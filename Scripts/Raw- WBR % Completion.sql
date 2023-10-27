
select distinct start_of_week
, count(distinct concat(video_id, distinct_id)) as videos_initiated
, count(distinct distinct_id) as video_inititated_users
, count(distinct case when completed=1 then concat(video_id, distinct_id) end) as videos_completed
from
(
select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week
, video_id
, distinct_id
from mixpanel_allen_next.video_start vs
)
left join
(
select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week
, distinct_id, video_id, 1 as completed
from mixpanel_allen_next.mark_as_complete_confirmed
)
using(start_of_week, distinct_id, video_id)
group by 1
order by 1 desc

--Test Completed
select distinct start_of_week
, count(distinct concat(test_id, distinct_id)) as Test_initiated
, count(distinct distinct_id) as Test_inititated_users
, count(distinct case when completed=1 then concat(test_id, distinct_id) end) as Test_completed
from
(
select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week
, test_id
, distinct_id
from mixpanel_allen_next.start_test_clicked vs
)
left join
(
select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week
, distinct_id, test_id, 1 as completed
from mixpanel_allen_next.submit_test_yes
)
using(start_of_week, distinct_id, test_id)
group by 1
order by 1 desc

--QB Test 
select distinct start_of_week
, qb_inititated
, section_initiating_users
, submitted_qb
from
(
select date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week
, count(*) as qb_inititated
, count(distinct distinct_id) as section_initiating_users
from mixpanel_allen_next.qb_startqbank_clicked vs
group by 1
)
left join
(
select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week
, count(*) as submitted_qb
from mixpanel_allen_next.qb_submit_clicked
group by 1
)
using(start_of_week)

order by 1 desc


