

-- Metrics For Leaders
--1. Total # users attending Live Classes per day

select 
date_trunc('month',Flag_month) as  Flag_month,
case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
avg(live_atten_per_day) as live_atten_per_day
from(

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
) group by 1,2
order by Flag_month desc,platform desc
--  Number of Concurrent viewers? -

select 
date_trunc('month', Flag_month) as Flag_month,
case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
avg(student_count) as concurent_viewer,
avg(total_class) as parallel_live_classes
from(
select 
date_trunc('day', class_date) as Flag_month,
student_center,
--case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
max(student_count) as student_count,
max(Class_no) as total_class
from (
select
date_trunc('hour',class_date_time) as class_date,
student_center,
--hh.date,
count(distinct student_id) as student_count,
count(distinct class_id) as Class_no,
ROW_NUMBER() OVER (PARTITION BY student_center  ORDER BY student_count desc) AS row_num
--avg(duration) as Class_duration
from truth.raw_student_attendance_master m1 
--left join analytics.hour_list hh
--on m1.class_date_time=hh.date
where 
class_type_id=1 and 
student_center in ('ALLEN DIGITAL') and
date(class_date_time)='2023-08-01' and  overall_punch_status is not null
group by class_date,student_center
order by class_date desc
) where row_num=1
group by 1,2
) group by 1,2 order by Flag_month desc,platform desc

-- concurrent users:

select 
date_trunc('month', date) as Flag_month,
case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
avg(student_count_final) as concurent_viewer,
avg(Class_no) as parallel_live_classes
from(
select
date,
student_center,
--hh.date,
sum(student_count) as student_count_final,
count(distinct class_id) as Class_no,
dense_rank() OVER (PARTITION BY student_center  ORDER BY student_count_final desc) AS rank_
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
group by student_center,date
) where rank_=1 group by 1,2

-- # Classes per Month

select 
class_date as month_flag,
case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
avg(Class_no) as class_per_month
from(
select 
date_trunc('month',class_date_time) as class_date,
student_center,
count(distinct class_id) as Class_no
from truth.raw_student_attendance_master 
where 
 --student_center='ALLEN DIGITAL' and
 class_type_id=1
 and date(class_date_time)>='2023-08-01'and and overall_punch_status is not null
group by 1,2
order by class_date desc
) group by 1,2


--• Total live classes per day
--  Average duration per Class? -
select 
date_trunc('month',class_date) as month_flag,
case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
avg(Class_no) as class_per_day,
avg(Class_duration) as Class_duration,
sum(Class_duration) as Numbers_hours_converted  
from(
select 
date_trunc('day',class_date_time) as class_date,
student_center,
count(distinct class_id) as Class_no,
avg(duration) as Class_duration
from truth.raw_student_attendance_master 
where 
class_type_id=1 
 and date(class_date_time)>='2023-06-01' and overall_punch_status is not null
group by 1,2
order by class_date desc
) group by 1,2

-- • Average duration per Class? -


--Overall Join 

select *  from( 
select 
class_date as month_flag,
case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
avg(Class_no) as class_per_month
from(
select 
date_trunc('month',class_date_time) as class_date,
student_center,
count(distinct class_id) as Class_no
from truth.raw_student_attendance_master 
where 
 --student_center='ALLEN DIGITAL' and
 class_type_id=1
 and date(class_date_time)>='2023-06-01'and  overall_punch_status is not null
group by 1,2
order by class_date desc
) group by 1,2
) l1 left join (
select 
date_trunc('month',class_date) as month_flag,
case when student_center='ALLEN DIGITAL' then 'Online' else 'Offline' end as platform,
avg(Class_no) as class_per_day,
sum(Class_duration)/sum(Class_no) as Class_duration,
--avg(Class_duration) as avg_duartion
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
) group by 1,2 

) l2 on l1.month_flag=l2.month_flag and l1.platform=l2.platform



select min(class_date_time) ,  max(class_date_time)from truth.raw_student_attendance_master 


select * from prod.tblclassvideomapping limit 10


select count(distinct t1.student_id )
from truth.raw_student_attendance_master t1
left join truth.raw_student_master rsm 
on t1.student_id =rsm.student_id 
where 
--center <>student_center and
session_name='2023-2024'

-- Creating Hour list
drop table  analytics.hour_list
create table analytics.hour_list
as (
select date_add('hour',-3*(number-4) ,current_date) as date  from analytics.number_list  order by 1 )

-- check 
select min(date) from analytics.hour_list limit 10


select
date_trunc('hour',class_date_time) as class_date,
student_center,
hh.date,
count(distinct student_id) as student_count,
count(distinct class_id) as Class_no,
--ROW_NUMBER() OVER (PARTITION BY student_center,class_date ORDER BY student_count desc) AS row_num
--avg(duration) as Class_duration
from truth.raw_student_attendance_master m1 
left join analytics.hour_list hh
on m1.class_date_time=hh.date
where 
class_type_id=1 and 
student_center in ('ALLEN DIGITAL') and
date(class_date_time)='2023-08-01' and  overall_punch_status is not null
group by class_date_time,student_center,date
order by class_date desc


select student_id,class_id,class_date_time as start_time, duration,DATEADD(minute, duration , class_date_time) as end_time
from truth.raw_student_attendance_master
where 
class_type_id=1 and 
student_center in ('ALLEN DIGITAL') and class_id=2269623 and student_id=1086169 and
date(class_date_time)='2023-08-01' and  overall_punch_status is not null limit 10


--To 
select class_date_time as start_time, duration,DATEADD(minute, duration , class_date_time) as end_time, class_id,date
from truth.raw_student_attendance_master t1 
inner join analytics.hour_list hh
on hh.date>=class_date_time and hh.date<= DATEADD(minute, duration , class_date_time)
--and DATEADD(minute, duration , class_date_time)<=hh.date
where 
class_type_id=1 and 
student_center in ('ALLEN DIGITAL') and class_id=2266515 and 
--and class_id=2269623 and student_id=1086169 and
--date(class_date_time)='2023-08-01' and  
overall_punch_status is not null 
group by 1,2,3,4,5


--Edge Case Class_id= 2266515

-- Using new 



select
date,
student_center,
--hh.date,
sum(student_count) as student_count_final,
count(distinct class_id) as Class_no,
dense_rank() OVER (PARTITION BY student_center  ORDER BY student_count_final desc) AS rank_
from 
(select * from 
(select class_date_time as start_time,
student_center,
duration,
DATEADD(minute, duration , class_date_time) as end_time,
class_id,
count(distinct student_id) as student_count
from truth.raw_student_attendance_master
where student_center in ('ALLEN DIGITAL') and date(class_date_time)='2023-08-01'
group by 1,2,3,4,5) t1 
inner join analytics.hour_list hh
on hh.date>=start_time and hh.date<= end_time)
group by student_center,date