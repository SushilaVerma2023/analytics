
select student_center ,student_class,subject,tt.topic_name,
count(distinct class_id) as total_class
from truth.raw_student_attendance_master rsam 
left join prod.doubt_topics tt 
on tt.id =rsam.topic_id 
where date(class_date_time)>='2022-09-04' and  date(class_date_time)<='2023-08-31'
group by 1,2,3,4

