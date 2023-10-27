--Merged Online and Offline attendance

select main.* ,
main.class_id||'_'||coalesce (main.student_id,0) as key,
current_date  as last_updated_at,
asa.center_name as student_center, 
asa.course_name as student_course, 
asa.class_value as student_class, 
asa.stream as student_stream, 
punch_status as punch_status_offline,  
date_diff('second',cast(class_start_time as timestamp),cast(class_end_time as timestamp)) as online_class_actual_duration_seconds, 
case when c.student_id is not null then 1 else 0 end as punch_status_online,
case when  (case when c.student_id is not null then 1 else 0 end)=1 then 1 
when punch_status=1 then 1 else 0 end as Overall_punch_status,
c.duration as student_attendance_duration_online
from 
  ( select main.*, coalesce(st_id_batch,sga.student_id) as student_id 
from 
  ( select main.*,sec.student_id as st_id_batch  from (select a.class_id
  ,class_type_id,class_name,mentor_id,a.subject_id,a.topic_id
  ,class_date_time,duration as class_duration_planned, zoom_info_id,m_course as class_course ,center as class_center ,
  batch_id,case when batch_id is null then group_id  else null end as group_id ,
  f.subject as faculty_subject,f.designation as faculty_designation,f.stream as faculty_stream,f.emp_id as faculty_id ,

  add_Date   as class_creation_date, 
  publish_date as class_publish_date  
from prod.classes a 
join prod.faculty f on  f.emp_id = a.mentor_id
left join prod.class_batches b  on b.class_id= a.class_id 
where DATE(a.class_date_time) >= date('2023-08-01')
)main 

left join  analytics.raw_student_date_batch_mapping  sec on  date(sec.date) = date(main.class_date_time)
and sec.batch_id = main.batch_id 
)main 
left join  prod.student_group_assoc sga on sga.group_id=main.group_id 
)main 
left join prod.student asa on asa.student_id = main.student_id  
left join (select 
student_id ,
punch_date ,
case when dval=4 then 0
when dval=3 then 0
when dval=0 then 1
when dval=1 then 1
when dval=2 then 0
else 0 end as punch_status
from (select punch_date,student_id,main.session_id,
min(case when dval ='P' then 0 when dval = 'H' then 1 when dval = 'L' then 2  
WHEN dval = 'N' then 3 when dval = 'A' then 4 else 5 end) as dval 
  from prod.student_offline_attendance_new main 
join prod.student a on 
a.enrollment_no = main.enrollment_no
 and a.session_id= main.session_id 
group  by 1,2,3 limit 10
 )) a on a.student_id = main.student_id and a.punch_date = date(main.class_date_time)
left join
     (
     select distinct id as zoom_info_id, meet_id
     from prod.allen_prod_zoom_meet_info
     union
     select distinct id as zoom_info_id, meet_id
     from prod.zoom_meet_info
     ) b on b.zoom_info_id=main.zoom_info_id
  left join (select meet_id,min(join_time) as class_start_time, max(leave_time) as class_end_time 
    from allen_digital.zoom_participants group by 1 
  ) eee on eee.meet_id = b.meet_id    
  left join
     (
     select distinct meet_id, customer_key as student_id,sum(duration) as duration
     from allen_digital.zoom_participants
     group by 1,2 
     ) c on c.meet_id=b.meet_id and c.student_id=asa.extra_field_1 
     
    select class_id,batch_id ,count(*) from
 (select class_id,batch_id from truth.raw_student_attendance_master  group by 1,2) group by 1,2 having count(*)>1 limit 10 
 
 
 
