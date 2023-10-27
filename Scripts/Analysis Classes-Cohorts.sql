


-- check 
select * from truth.raw_student_attendance_master where student_center in ('ALLEN DIGITAL') and 
date(class_date_time)>='2023-06-01'limit 102

-- Total days attended vs overall attendance ratio
select 
student_id,
count(distinct date(class_date_time)) as total_days,
count(distinct case when overall_punch_status=1 then date(class_date_time) end ) as attended_days,
count(distinct case when overall_punch_status=1 then date(class_date_time) end )*100/count(distinct date(class_date_time)) as attended_days_per,
sum(overall_punch_status)*100/count(distinct class_id) as class_attendance_per
from truth.raw_student_attendance_master rsam 
where 
student_center in ('ALLEN DIGITAL') and 
date(class_date_time)>='2023-06-01'/* remove later*/
--and student_id in (1056689,786482,787958)
and lower(class_name) not like '%doubt%' and 
class_id in (select class_id from (select *,sum(overall_punch_status) over(partition by class_id) as c  from 
truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) where c>1)
group by 1


