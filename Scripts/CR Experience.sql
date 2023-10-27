
select 
date_col,
student_id,
total_attendance,
count(distinct class_id)
from(

select 
date(sor.class_date_time) as date_col,
student_id,
sor.class_id,
cl.class_type_id,
 case when punch_status=1 then 'attempted' else 'not attempted' end  as total_attendance
from analytics.student_online_roster sor 
left join prod.classes cl on cl.class_id=sor.class_id
where date(sor.class_date_time) >='2023-08-05' and student_id=981390
group by 1,2,3,4,5  

) group by 1,2,3 limit 100



select 
date(sor.class_date_time) as date_col,
student_id,
cl.class_type_id,
punch_status,
count(distinct sor.class_id) as class
-- case when punch_status=1 then 'attempted' else 'not attempted' end  as total_attendance
from analytics.student_online_roster sor 
left join prod.classes cl on cl.class_id=sor.class_id
where date(sor.class_date_time) >='2023-08-05' and student_id=981390
group by 1,2,3,4



-- offline check
select 
cl.class_type_id,count(*)
from analytics.student_online_roster sor 
left join prod.classes cl on cl.class_id=sor.class_id
group by 1



