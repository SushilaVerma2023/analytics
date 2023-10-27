select min(log_date)  from analytics.raw_activity_summary   

-- Activity done by feature

select 
date_trunc('week',log_date) as flag ,
'week' as Cadence,
count(distinct student_id) as users,
count(distinct case when doubt_solution>0 then student_id  else null end )as doubt_solution ,
count(distinct case when test_report_page>0 then student_id else null end) as test_report_page,
count(distinct case when login>0 then student_id else null end) as login,
count(distinct case when excercise_solution>0 then student_id else null end) as excercise_solution,
count(distinct case when test_report_page>0 then student_id else null end) as test_report_page,
count( distinct case when notice_board>0 then student_id else null end) as notice_board
from 
analytics.raw_activity_summary
--where student_id in (1001224,499)
--log_date>='2023-07-01'
group by 1
--order by week_flag desc
union  all
select 
date_trunc('day',log_date) as flag ,
'day' as Cadence,
count(distinct student_id) as users,
count(distinct case when doubt_solution>0 then student_id  else null end )as doubt_solution ,
count(distinct case when test_report_page>0 then student_id else null end) as test_report_page,
count(distinct case when login>0 then student_id else null end) as login,
count(distinct case when excercise_solution>0 then student_id else null end) as excercise_solution,
count(distinct case when test_report_page>0 then student_id else null end) as test_report_page,
count( distinct case when notice_board>0 then student_id else null end) as notice_board
from 
analytics.raw_activity_summary
--where student_id in (1001224,499)
--log_date>='2023-07-01'
group by 1
--order by week_flag desc
union all
select 
date_trunc('month',log_date) as flag ,
'month' as Cadence,
count(distinct student_id) as users,
count(distinct case when doubt_solution>0 then student_id  else null end )as doubt_solution ,
count(distinct case when test_report_page>0 then student_id else null end) as test_report_page,
count(distinct case when login>0 then student_id else null end) as login,
count(distinct case when excercise_solution>0 then student_id else null end) as excercise_solution,
count(distinct case when test_report_page>0 then student_id else null end) as test_report_page,
count( distinct case when notice_board>0 then student_id else null end) as notice_board
from 
analytics.raw_activity_summary
--where student_id in (1001224,499)
--log_date>='2023-07-01'
group by 1
--order by week_flag desc

-- WAU
select 
week_flag,
event,
max(case when event='WAU' then users else null end  ) as WAU
from(
select DATE_TRUNC('week',log_date) as week_flag
,'WAU' as event
,count(distinct student_id ) as users from allen_digital_reporting.activity_log 
group by 1 order by week_flag desc limit 10
)group by 1,2

--

select 
date_trunc('week',log_date) as week_flag ,
count(distinct student_id) as users
from 
analytics.raw_activity_summary
--where student_id in (1001224,499)
--log_date>='2023-07-01'
group by 1
order by week_flag desc

-- No of installs
select
date
,package_name 
,country
,sum(daily_user_installs ) as a
from ga_digital.play_console_dump_installs_by_country pcdribc 
where date>='2023-01-01' and country='IN'
group by 1,2,3
having a>0
order by date desc
limit 10

-- No of signups

select rs.student_platform_type,
count(student_id) 
from analytics.raw_student rs 
group by 1 
limit 10


