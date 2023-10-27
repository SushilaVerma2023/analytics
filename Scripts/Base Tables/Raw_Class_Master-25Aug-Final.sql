-- Main Class Snipet

select  
--main.class_id as key,
current_date as Last_updated_at,
main.class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, main.zoom_info_id,m_course,center,
  subject,designation,faculty_stream,faculty_id,b.meet_id,
  update_date ,
  publish_Date,
  main.class_canceled,
  main.adjustment_faculty,
  main.category_id,
  main.stream_id as class_stream,
  main.publish,
  main.session_id,
  main.session_name,
Scheduled_student_count,
total_Attendance
from(
 (select a.class_id
  ,class_type_id
  ,case when class_type_id=1 then 'Live Class'
when class_type_id=3 then 'Recorded Lecture' 
when class_type_id=5 then 'Webinar' 
when  class_type_id=6 then 'Offline' 
else 'Others' end as Clas_Type_Name
   ,class_name,mentor_id,a.subject_id,a.topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  update_date ,
  publish_Date,
  canceled as class_canceled,
  adjustment_faculty,
  category_id,
  stream_id,-- mostly it is blank hence take this from Student master
  publish,
  session_id,
  case when a.session_id=5 then '2023-2024'
					 when a.session_id=4 then '2022-2023'
					 when a.session_id=3 then '2021-2022'
					 when a.session_id=2 then '2020-2021'
					 when a.session_id=0 then '2019-2020'
					 else 'Blank'
			end as session_name,
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
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28



--check 

select * from truth.raw_class_master rcm limit 10