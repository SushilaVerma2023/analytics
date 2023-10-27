-- Overall Time Duration gap between classes
select 
DATEDIFF(minute , end_time, next_value) as Time_day,
/*case 
when DATEDIFF(minute , end_time, next_value)<-10 then 'overlap'
when DATEDIFF(minute , end_time, next_value)<0 and DATEDIFF(minute , end_time, next_value)>=-10 then '-0-10min'
when DATEDIFF(minute , end_time, next_value)=0 then '0min'
when DATEDIFF(minute , end_time, next_value)>0 and DATEDIFF(minute , end_time, next_value)<=1  then '0-1min'
when DATEDIFF(minute , end_time, next_value)>1 and DATEDIFF(minute , end_time, next_value)<=5 then '1-5min'
when DATEDIFF(minute , end_time, next_value)>5 and DATEDIFF(minute , end_time, next_value)<=10 then '5-10min'
when DATEDIFF(minute , end_time, next_value)>10 and DATEDIFF(minute , end_time, next_value)<=20 then '10-20min'
when DATEDIFF(minute , end_time, next_value)>20 and DATEDIFF(minute , end_time, next_value)<=30 then '20-30min'
when DATEDIFF(minute , end_time, next_value)>30 and DATEDIFF(minute , end_time, next_value)<=50 then '30-50min'
--when DATEDIFF(minute , end_time, next_value)<-10 and DATEDIFF(minute , end_time, next_value)>=-20 then '-10-20min'
--when DATEDIFF(minute , end_time, next_value)<-20 and DATEDIFF(minute , end_time, next_value)>=-30 then '-20-30min'
--when DATEDIFF(minute , end_time, next_value)<-30 and DATEDIFF(minute , end_time, next_value)>=-40 then '-30-40min'
--when DATEDIFF(minute , end_time, next_value)<=-40 then '<=-40 mins'
when DATEDIFF(minute , end_time, next_value)>50 then '>50mins'
else 'Last Class'  end as cohorts,*/
count(distinct student_id) as student_cnt,
count(distinct class_id) as class_cnt,
avg(duration) as avg_duration,
--MEDIAN(duration) as median_duration,
sum(next_punch_cnt) as next_punch_cnt,
sum(next_punch_cnt)*100/count(next_punch_cnt) as attandance
--then 'Overlap'else 'No' end as overlap_flag 
from (
select 
*, lead(start_time) OVER(partition by student_id,date(start_time) ORDER BY student_id,start_time) as next_value,
lead(attendance) OVER(partition by student_id,date(start_time) ORDER BY student_id,start_time) as next_punch_cnt
from(
select class_date_time as start_time,
student_center,
duration,
DATEADD(minute, duration , class_date_time) as end_time,
student_id,
class_id,
sum(overall_punch_status) as attendance
from truth.raw_student_attendance_master
where 
student_center in ('ALLEN DIGITAL') and 
date(class_date_time)>='2023-08-01'/* remove later*/
--and student_id in (798584,1319955)
--and student_id=982959
--and student_id=792478
and lower(class_name) not like '%doubt%' and class_id in (select class_id from (select *,sum(overall_punch_status) over(partition by class_id) as c  from 
truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) where c>1)
group by 1,2,3,4,5,6
order by start_time desc
)  
--where duration<>0
) 
group by 1
--where end_time>previous_value




