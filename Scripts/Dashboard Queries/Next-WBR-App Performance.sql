
  SELECT
  funnel_date,
  flag,
  MAX(CASE WHEN event = 'WAU' THEN users END) AS "WAU",
     MAX(CASE WHEN event =   'WEU' THEN users END) AS "WEU",
     MAX(CASE WHEN event = 'Sessions per week' THEN users END) AS "Sessions per week",
     MAX(CASE WHEN event = 'New WEU' THEN users END) AS "New WEU",
     MAX(CASE WHEN event = 'New WAU' THEN users END) AS "New WAU"
     
FROM
  (
    SELECT
      DATE_TRUNC('week', (timestamp 'epoch' + time * INTERVAL '1 second')) AS funnel_date,
      'WAU' AS event,
      'Week' AS Flag,
      COUNT(DISTINCT _device_id) AS users
    FROM
      mixpanel_allen_next.app_launched
    GROUP BY
      funnel_date

    UNION all
    
    -- New WAU
    select first_week AS funnel_date,
'New WAU' AS event,
      'Week' AS Flag
,count(distinct _device_id) as users
from
(
select distinct _device_id, min(date_trunc('week', (timestamp 'epoch' + time * interval '1 second'))) as first_week
from  mixpanel_allen_next.app_launched
group by 1
)
group by 1
-- Sessions Per week
union all
    select date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS funnel_date,
'Sessions per week' AS event,
      'Week' AS Flag
, count(*) as users

from mixpanel_allen_next.app_launched

group by 1
union all
--New WEU
select 
start_of_week as funnel_date,
'New WEU' AS event,
      'Week' AS Flag
, count(distinct "_user_id") as users
from
(
select distinct "_user_id", min(start_of_week) as start_of_week
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
union
(
select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week
, "_user_id"
, 1 as interaction
from mixpanel_allen_next.video_start
)
union
(
select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week
, "_user_id"
, 1 as interaction
from mixpanel_allen_next.quiz_yourself_option_clicked
)
union
(
select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week
, "_user_id"
, 1 as interaction
from mixpanel_allen_next.qb_startqbank_clicked
)
union
(
select distinct date_trunc('week', (timestamp 'epoch' + time * interval '1 second')) AS start_of_week
, "_user_id"
, 1 as interaction
from mixpanel_allen_next.daily_dose_video_played
)
)
group by 1
)
group by 1


union all
    SELECT
      start_of_week AS funnel_date,
      'WEU' AS event,
      'Week' AS Flag,
      COUNT(DISTINCT "_user_id") AS users
    FROM
      (
        SELECT
          date_trunc('week', (timestamp 'epoch' + time * INTERVAL '1 second')) AS start_of_week,
          "_user_id",
          1 AS interaction
        FROM
          mixpanel_allen_next.start_test_clicked

        UNION

        SELECT
          date_trunc('week', (timestamp 'epoch' + time * INTERVAL '1 second')) AS start_of_week,
          "_user_id",
          1 AS interaction
        FROM
          mixpanel_allen_next.video_start

        UNION

        SELECT
          date_trunc('week', (timestamp 'epoch' + time * INTERVAL '1 second')) AS start_of_week,
          "_user_id",
          1 AS interaction
        FROM
          mixpanel_allen_next.quiz_yourself_option_clicked

        UNION

        SELECT
          date_trunc('week', (timestamp 'epoch' + time * INTERVAL '1 second')) AS start_of_week,
          "_user_id",
          1 AS interaction
        FROM
          mixpanel_allen_next.qb_startqbank_clicked

        UNION

        SELECT
          date_trunc('week', (timestamp 'epoch' + time * INTERVAL '1 second')) AS start_of_week,
          "_user_id",
          1 AS interaction
        FROM
          mixpanel_allen_next.daily_dose_video_played
      ) AS subquery
    GROUP BY
      start_of_week
  ) AS result
  group by funnel_date,flag
ORDER BY
  funnel_date DESC;
