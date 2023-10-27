-- OTP Funnel Code
-- Browse By 

SELECT
  funnel_date,
  flag,
  MAX(CASE WHEN event = 'OTP Sent' THEN users END) AS "OTP Sent",
     MAX(CASE WHEN event =   'OTP Submit' THEN users END) AS "OTP Submit",
     MAX(CASE WHEN event =  'Signed Up' THEN users END) AS "Signed Up",
  MAX(CASE WHEN event = 'Subscribed' THEN users END) AS "Subscribed",
   MAX(CASE WHEN event = 'WAU' THEN users END) AS "WAU",
     MAX(CASE WHEN event =   'WEU' THEN users END) AS "WEU",
     MAX(CASE WHEN event = 'Sessions per week' THEN users END) AS "Sessions per week",
     MAX(CASE WHEN event = 'New WEU' THEN users END) AS "New WEU",
     MAX(CASE WHEN event = 'New WAU' THEN users END) AS "New WAU"
FROM
  (
select 
DATE_TRUNC('day', otp_date) as funnel_date ,
'day' as flag,
count(distinct enrollment_no) as users,
'OTP Sent' as event
from(
select enrollment_no, max(OTP_VALIDATE) , count(distinct otp) as attempts, min(requested_on) as otp_date
		from allen_next.otp_detail  
		group by enrollment_no
		)x
	group by funnel_date 
	
union all 

select 
DATE_TRUNC('week', otp_date) AS funnel_date,
'week' as flag,
count(distinct enrollment_no) as users,
'OTP Sent' as event
from(
select enrollment_no, max(OTP_VALIDATE) , count(distinct otp) as attempts, min(requested_on) as otp_date
		from allen_next.otp_detail  
		group by enrollment_no
		)x
	group by funnel_date 

	
	union all 

	select 
DATE_TRUNC('month', otp_date) AS funnel_date,
'month' as flag,
count(distinct enrollment_no) as users,
'OTP Sent' as event
from(
select enrollment_no, max(OTP_VALIDATE) , count(distinct otp) as attempts, min(requested_on) as otp_date
		from allen_next.otp_detail  
		group by enrollment_no
		)x
	group by funnel_date
--OTP submitted
	
	union all 
	
	select DATE_TRUNC('day', reg_date) as funnel_date, 
'day' as flag,
	count(distinct enrollment_no) as users,
		'OTP Submit' as event
	from allen_next.student
	group by funnel_date 
	union all 
		select DATE_TRUNC('week', reg_date) as funnel_date, 
'week' as flag,
	count(distinct enrollment_no) as users,
		'OTP Submit' as event
	from allen_next.student
	group by funnel_date 
	union all 
		select DATE_TRUNC('month', reg_date) as funnel_date, 
'month' as flag,
	count(distinct enrollment_no) as users,
		'OTP Submit' as event
	from allen_next.student
	group by funnel_date 
	-- Signups 
	union all
	select DATE_TRUNC('day', reg_date) as funnel_date,
 'day' as flag,
	count(distinct enrollment_no) as users,
		'Signed Up' as event
	from allen_next.student
	where course_id <> '' and course_id is not null
	group by funnel_date
	union all
		select DATE_TRUNC('week', reg_date) as funnel_date,
 'week' as flag,
	count(distinct enrollment_no) as users,
		'Signed Up' as event
	from allen_next.student
	where course_id <> '' and course_id is not null
	group by funnel_date
	union all
		select DATE_TRUNC('month', reg_date) as funnel_date,
 'month' as flag,
	count(distinct enrollment_no) as users,
		'Signed Up' as event
	from allen_next.student
	where course_id <> '' and course_id is not null
	group by funnel_date
--Subscribed
	
	union all
	select DATE_TRUNC('day', first_sub) as funnel_date,
	 'day' as flag
	, count(distinct student_id) as users,
	'Subscribed' as event
	from
	(
		select student_id, min(date(TRANSACTION_DATE)) as first_sub
		from allen_next.student_transaction_response
		where fldIsDummy = 0
			and fldFeeSubmited = 1
		group by student_id
	)y
	group by funnel_date
	union all
	select DATE_TRUNC('week', first_sub) as funnel_date,
	 'week' as flag
	, count(distinct student_id) as users,
	'Subscribed' as event
	from
	(
		select student_id, min(date(TRANSACTION_DATE)) as first_sub
		from allen_next.student_transaction_response
		where fldIsDummy = 0
			and fldFeeSubmited = 1
		group by student_id
	)y
	group by funnel_date
	union all
	select DATE_TRUNC('month', first_sub) as funnel_date,
	 'month' as flag
	, count(distinct student_id) as users,
	'Subscribed' as event
	from
	(
		select student_id, min(date(TRANSACTION_DATE)) as first_sub
		from allen_next.student_transaction_response
		where fldIsDummy = 0
			and fldFeeSubmited = 1
		group by student_id
	)y
	group by funnel_date
	
	-- ANOTHER CODE
	union all
	SELECT
      DATE_TRUNC('week', (timestamp 'epoch' + time * INTERVAL '1 second')) AS funnel_date,
     
      'week' AS Flag,
      COUNT(DISTINCT _device_id) AS users,
       'WAU' AS event
    FROM
      mixpanel_allen_next.app_launched
    GROUP BY
      funnel_date

    UNION all
    
    -- New WAU
    select first_week AS funnel_date,

      'week' AS Flag
,count(distinct _device_id) as users,
'New WAU' AS event
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

      'week' AS Flag
, count(*) as users,
'Sessions per week' AS event

from mixpanel_allen_next.app_launched

group by 1
union all
--New WEU
select 
start_of_week as funnel_date,

      'week' AS Flag
, count(distinct "_user_id") as users,
'New WEU' AS event
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
   
      'week' AS Flag,
      COUNT(DISTINCT "_user_id") AS users,
         'WEU' AS event
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

        union 

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
GROUP BY
  funnel_date, flag;
 
 