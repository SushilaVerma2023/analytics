--CTE Start- L1 -The classes scheduled for students
with l1 as 
(
select  
distinct coalesce (class_id,0)||'_'||coalesce (cast(student_id as int),0) as key,
class_id, 
class_type_id, class_name,mentor_id,subject_id, 
topic_id, class_date_time,duration,zoom_info_id,
m_course,center,batch_id,cast(group_id as int) as group_id , 
subject,designation,faculty_stream,faculty_id,
cast(student_id  as int) as student_id 
 from 
(select main.*, coalesce(st_id_batch,sga.student_id) as student_id 
from 
  ( select main.*,sec.student_id as st_id_batch  from (select a.class_id
  ,class_type_id,class_name,mentor_id,a.subject_id,a.topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,a.category_id,
  case when category_id=1 then 'REGULAR CLASS'
when category_id=2 then 'DOUBT CLASS' 
when category_id=3 then 'REVISION CLASS'
when category_id=4 then 'TUTORIAL CLASS'
when category_id=5 then 'TRAINING CLASS'
when category_id=6 then 'EXTRA CLASS'
when category_id=7 then 'MAKE-UP CLASS'
when category_id=8 then 'MERGE CLASS'
when category_id=9 then 'BOARD CLASS'
when category_id=10 then 'REVIEW CLASS'
when category_id=11 then 'SRG CLASS'
when category_id=12 then 'KVPY CLASS'
when category_id=13 then 'PCU CLASS'
when category_id=14 then 'ADJUSTMENT CLASS'
when category_id=15 then 'SUBSTITUTED CLASS'
when category_id=16 then 'OTHERS'
when category_id=17 then 'OTHER CLASS'
else 'NA' end as Category_name,
  cast(batch_id as int) as batch_id ,case when batch_id is null then group_id  else null end as group_id ,
  f.subject,f.designation,f.stream as faculty_stream,f.emp_id as faculty_id 
from prod.classes a 
join prod.faculty f on  f.emp_id = a.mentor_id
left join prod.class_batches b  on b.class_id= a.class_id 
where a.class_date>= date_add('day',-60,date(current_date)) and a.class_date<= current_date and a.publish=1
)main 
left join  analytics.raw_student_date_batch_mapping  sec on  date(sec.date) = date(main.class_date_time)
and sec.batch_id = main.batch_id 
)main 
left join  prod.student_group_assoc sga on sga.group_id=main.group_id 
) where student_id is not null 
), 
--L1 -The classes not scheduled for students and are attendeing class
l2 as (
 select distinct  class_id||'_'||cast(asa.student_id as int) as key,
 a.class_id
  ,class_type_id,class_name,a.mentor_id,a.subject_id,a.topic_id
  ,class_date_time,duration, a.zoom_info_id,m_course,center,a.category_id,
  case when category_id=1 then 'REGULAR CLASS'
when category_id=2 then 'DOUBT CLASS' 
when category_id=3 then 'REVISION CLASS'
when category_id=4 then 'TUTORIAL CLASS'
when category_id=5 then 'TRAINING CLASS'
when category_id=6 then 'EXTRA CLASS'
when category_id=7 then 'MAKE-UP CLASS'
when category_id=8 then 'MERGE CLASS'
when category_id=9 then 'BOARD CLASS'
when category_id=10 then 'REVIEW CLASS'
when category_id=11 then 'SRG CLASS'
when category_id=12 then 'KVPY CLASS'
when category_id=13 then 'PCU CLASS'
when category_id=14 then 'ADJUSTMENT CLASS'
when category_id=15 then 'SUBSTITUTED CLASS'
when category_id=16 then 'OTHERS'
when category_id=17 then 'OTHER CLASS'
else 'NA' end as Category_name,
  asa.batch_id,cast(null as int) as group_id,
  f.subject,f.designation,f.stream as faculty_stream,f.emp_id as faculty_id ,
  cast(asa.student_id as int) as student_id 
from prod.classes a 
join prod.faculty f on  f.emp_id = a.mentor_id
join
     (
     select distinct id as zoom_info_id, meet_id
     from prod.allen_prod_zoom_meet_info
     union
     select distinct id as zoom_info_id, meet_id
     from prod.zoom_meet_info
     ) b on b.zoom_info_id=a.zoom_info_id
  join
     (
     select distinct meet_id, customer_key as student_id
     from allen_digital.zoom_participants
     group by 1,2 
     ) c on c.meet_id=b.meet_id 
     join prod.student asa on c.student_id=asa.extra_field_1  
     where 
     date(a.class_date_time)>= date_add('day',-360,date(current_date)) and date(a.class_date_time)<= current_date and  asa.student_id is not null 
 ) 
 -- End of CTE
 -- Main Section
select main.* ,
--main.class_id||'_'||coalesce (main.student_id,0) as key,
current_date  as last_updated_at,
asa.center_name as student_center, 
asa.course_name as student_course, 
asa.class_value as student_class, 
asa.stream as student_stream, 
punch_status as punch_status_offline, 
case when main.l2=1 then 1 else 0 end as Scheduled,
date_diff('second',cast(class_start_time as timestamp),cast(class_end_time as timestamp)) as online_class_actual_duration_seconds, 
case when c.student_id is not null then 1 else 0 end as punch_status_online,
-- Overall flag for the students at the class level irrespective of present online or offline
case 
when center = 'ALLEN DIGITAL' and punch_status_online = 1 then 1 
when center = 'ALLEN DIGITAL' then 0 
when punch_status_online = 1 or punch_status = 1 then 1 
when punch_status = 0 then 0 
else null end 
 as Overall_punch_status,
c.duration as student_attendance_duration_online
from 
  ( 
--Creating main using CTE
select * ,0 as l2
 from l2 
 where l2.key not in (select key from l1 
 )
 union 
 select * ,1 as l2
 from l1 
 -- Joining using two CTE above
)main 
left join prod.student asa on asa.student_id = main.student_id  
--offline student attendance
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
group  by 1,2,3 
 )) a on a.student_id = main.student_id and a.punch_date = date(main.class_date_time)
left join
--Online Student attendance
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