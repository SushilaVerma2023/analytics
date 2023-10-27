SELECT
  funnel_date,
  flag,
  MAX(CASE WHEN event = 'videos' THEN initiated END) AS "videos_initiated",
  max(CASE WHEN event = 'videos' THEN inititated_users END) AS "video_inititated_users",
     MAX(CASE WHEN event =   'videos' THEN completed END) AS "video_completed",
--test_flag
     MAX(CASE WHEN event = 'Test' THEN initiated END) AS "Test_initiated",
  max(CASE WHEN event = 'Test' THEN inititated_users END) AS "test_inititated_users",
     MAX(CASE WHEN event =   'Test' THEN completed END) AS "Test_completed",
     --QB Bank
          MAX(CASE WHEN event = 'QB' THEN initiated END) AS "QB_initiated",
  max(CASE WHEN event = 'QB' THEN inititated_users END) AS "QB_inititated_users",
     MAX(CASE WHEN event =   'QB' THEN completed END) AS "QB_completed"
FROM
  (
select distinct start_of_week as funnel_date,
'week' as flag,
'videos' as event
, count(distinct concat(video_id, distinct_id)) as initiated
, count(distinct distinct_id) as inititated_users
, count(distinct case when completed=1 then concat(video_id, distinct_id) end) as completed
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
union all
--Test Completed
select distinct start_of_week as funnel_date
,'week' as flag,
'Test' as event
, count(distinct concat(test_id, distinct_id)) as initiated
, count(distinct distinct_id) as inititated_users
, count(distinct case when completed=1 then concat(test_id, distinct_id) end) as completed
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
union all
--QB Test 
select distinct start_of_week as funnel_date
,'week' as flag,
'QB' as event
, qb_inititated as initiated
, section_initiating_users as inititated_users
, submitted_qb as completed
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
) group by 1,2


