

--# Average duration per Class?
-- Numbers of hours converted into VOD?

select 
date_trunc('month',class_date) as Flag_month,
case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
avg(Class_no) as class_per_day,
--sum(class_no) as Classes_per_Month,
sum(Class_duration)/sum(Class_no) as Class_duration,
sum(Class_duration)/60 as hours_converted_VOD
from(
select 
date_trunc('day',c1.class_date_time) as class_date,
center as student_center,
count(distinct c1.class_id) as Class_no,
sum(c1.duration) as Class_duration
from ( select class_id, class_date_time,center, max(duration) as duration from prod.classes c1 where 
class_type_id=1 
 and date(class_date_time)>='2023-06-01'  and date(class_date_time)<=current_date group by 1,2,3 order by duration desc ) c1
group by 1,2
order by class_date desc
) group by 1,2 order by Flag_month desc,platform desc

--Total # users attending Live Classes per day
select 
date_trunc('month',class_date) as  Flag_month,
case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
sum(student_count)/count(class_date) as live_atten_per_day
from(
select 
date_trunc('day',class_date_time) as class_date,
student_center,
count(distinct case when overall_punch_status =1 then student_id end ) as student_count
from truth.raw_student_attendance_master 
where 
class_type_id=1 and date(class_date_time)>='2023-06-01' and overall_punch_status is not null
--and student_center='ALLEN DIGITAL' 
group by 1,2
order by class_date desc
) group by 1,2 order by Flag_month desc,platform desc


--# Classes per Month

select 
date_trunc('month',class_date_time) as  Flag_month,
case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
count(distinct class_id) as classes_per_month
from truth.raw_student_attendance_master rsam 
where 
 date(class_date_time)>='2023-06-01' and overall_punch_status is not null
--and student_center='ALLEN DIGITAL'
 group by 1,2 order by Flag_month desc,platform desc

 
 -- concurrent users:

select 
date_trunc('month', date) as Flag_month,
case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
avg(student_count_final) as concurent_viewer,
avg(Class_no) as parallel_live_classes
from(
select
date,
date(date) as date_new,
student_center,
--hh.date,
sum(student_count) as student_count_final,
count(distinct class_id) as Class_no,
dense_rank() OVER (PARTITION BY student_center,date_new  ORDER BY student_count_final desc) AS rank_
from 
(select * from 
(select class_date_time as start_time,
student_center,
duration,
DATEADD(minute, duration , class_date_time) as end_time,
class_id,
count(distinct student_id) as student_count
from truth.raw_student_attendance_master
where 
--student_center in ('ALLEN DIGITAL') and 
date(class_date_time)>='2023-06-01'/* remove later*/
group by 1,2,3,4,5) t1 
inner join analytics.hour_list hh
on hh.date>=start_time and hh.date<= end_time)
group by student_center,date,date_new
) where rank_=1 group by 1,2 order by Flag_month desc,platform desc