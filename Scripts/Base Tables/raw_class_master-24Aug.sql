--Class Master -Updated on 24th Aug
select  
date(main.class_date_time)||'_'|| main.class_id as key,
current_date as Last_updated_at,
main.class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, main.zoom_info_id,m_course,center,
  subject,designation,faculty_stream,faculty_id,b.meet_id,
Scheduled_student_count,
total_Attendance
from(
 (select a.class_id
  ,class_type_id,class_name,mentor_id,a.subject_id,a.topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  --,case when batch_id is null then group_id  else null end as group_id ,
  f.subject,f.designation,f.stream as faculty_stream,f.emp_id as faculty_id 
from prod.classes a 
join prod.faculty f on  f.emp_id = a.mentor_id
--left join prod.class_batches b  on b.class_id= a.class_id 
--where a.class_id =2292447
)main 
left join
     (
     select distinct id as zoom_info_id, meet_id
     from prod.allen_prod_zoom_meet_info
     union
     select distinct id as zoom_info_id, meet_id
     from prod.zoom_meet_info
     ) b on b.zoom_info_id=main.zoom_info_id  
   left join (select class_id,count(distinct student_id) as Scheduled_student_count, 
              sum(Overall_punch_status) as total_Attendance 
              from truth.raw_student_attendance_master group by 1 )a on a.class_id= main.class_id
              )
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20

