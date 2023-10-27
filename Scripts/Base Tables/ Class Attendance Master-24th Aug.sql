

-- Class Attendance Master-24th Aug 
with l1 as 
(
select  
coalesce (class_id,0)||'_'||coalesce (cast(student_id as int),0) as key,
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
  ,class_date_time,duration, zoom_info_id,m_course,center,
  cast(batch_id as int) as batch_id ,case when batch_id is null then group_id  else null end as group_id ,
  f.subject,f.designation,f.stream as faculty_stream,f.emp_id as faculty_id 
from prod.classes a 
join prod.faculty f on  f.emp_id = a.mentor_id
left join prod.class_batches b  on b.class_id= a.class_id 
where a.class_date >= date('2023-08-01')
)main 
left join  analytics.raw_student_date_batch_mapping  sec on  date(sec.date) = date(main.class_date_time)
and sec.batch_id = main.batch_id 
)main 
left join  prod.student_group_assoc sga on sga.group_id=main.group_id 
)
), l2 as (
 select distinct  class_id||'_'||cast(asa.student_id as int) as key,
 a.class_id
  ,class_type_id,class_name,a.mentor_id,a.subject_id,a.topic_id
  ,class_date_time,duration, a.zoom_info_id,m_course,center,
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
     where date(a.class_date_time) >= date('2023-08-01')
 ) 


select * ,0 as l2
--,case when l1.student_id then 1 else 0 end as Scheduled
 from l2 
 where l2.key not in (select key from l1 
 )
 
 union 
 
 select * ,case when l1.student_id then 1 else 0 end as l2
 from l1
 