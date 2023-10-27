select 
--student_id,
date_trunc('month', start_time )  as date_flag,
overlap_flag,
sum(attendance)*100/count(*) as Per_Attendance,
sum(attendance) as overall_att,
count(*) as overall_count,
count(distinct class_id) as Class_count
from(
select * ,case when end_time>=previous_value then 'Overlap'else 'No' end as overlap_flag 
from (
select 
*, lead(start_time) OVER(partition by student_id ORDER BY student_id,start_time) as previous_value
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
date(class_date_time)>='2023-06-01'/* remove later*/
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
--where end_time>previous_value
) group by 1,2
