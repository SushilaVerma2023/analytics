
create table analytics.Check_online_Attendance as
(
select distinct key,last_updated_at,class_id,class_type_id,class_name,mentor_id,subject_id,topic_id,class_date_time,
duration,zoom_info_id,m_course,center,batch_id,student_id,
attendance
as punch_status,class_attend_time,
class_end_time,
class_start_time,active_dau,live_class_clicked

,faculty_id,subject,faculty_stream,designation
from
(select main.student_id||'_'||class_id as key ,current_date as last_updated_at ,main.* ,class_end_time,
class_start_time,
case when c.student_id is null then null else 1 end as attendance
,c.duration as class_attend_time ,

case when activity_online.student_id is null then 0 else 1 end as active_dau, 
coalesce(live_class_clicked,0) as live_class_clicked

from (select main.*, coalesce(st_id_batch,sga.student_id) as student_id 
from 
  ( select main.*,sec.student_id as st_id_batch  from (select a.class_id
  ,class_type_id,class_name,mentor_id,a.subject_id,a.topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id,case when batch_id is null then group_id  else null end as group_id ,
  f.subject,f.designation,f.stream as faculty_stream,f.emp_id as faculty_id 
from prod.classes a 
join prod.faculty f on  f.emp_id = a.mentor_id
left join prod.class_batches b  on b.class_id= a.class_id 
where date(class_date_time)>='2023-06-01'
--where a.center = 'ALLEN DIGITAL'
)main 

left join  analytics.raw_student_date_batch_mapping  sec on  date(sec.date) = date(main.class_date_time)
and sec.batch_id = main.batch_id 
)main 
left join  prod.student_group_assoc sga on sga.group_id=main.group_id 
) main 
join prod.student asa on asa.student_id = main.student_id
join
     (
     select distinct id as zoom_info_id, meet_id
     from prod.allen_prod_zoom_meet_info
     union
     select distinct id as zoom_info_id, meet_id
     from prod.zoom_meet_info
     ) b on b.zoom_info_id=main.zoom_info_id
  join (select meet_id,min(join_time) as class_start_time, max(leave_time) as class_end_time 
    from allen_digital.zoom_participants group by 1 
  ) eee on eee.meet_id = b.meet_id    
  
  left join (select main.student_id,log_date,max(Case when event_id= 38 then 1 else 0 end ) as live_class_clicked  from allen_digital_reporting.activity_log main 
join prod.student a on a.student_id= main.student_id 
--and a.center_name = 'ALLEN DIGITAL'
group by 1,2) as activity_online on activity_online.student_id = asa.student_id and activity_online.log_date = date(main.class_Date_time) 
  
  
  left join
     (
     select distinct meet_id, customer_key as student_id,sum(duration) as duration
     from allen_digital.zoom_participants
     group by 1,2 
   
     ) c on c.meet_id=b.meet_id and c.student_id=asa.extra_field_1  
     )
 )