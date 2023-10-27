
-- Class Details
select a.class_id||'_'||coalesce(batch_id,0)||'_'||coalesce(group_id,0) as key,
current_date as Last_updated_at,
a.class_id
  ,class_type_id,class_name,mentor_id,a.subject_id,a.topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id,case when batch_id is null then group_id  else null end as group_id ,
  f.subject,f.designation,f.stream as faculty_stream,f.emp_id as faculty_id 
from prod.classes a 
join prod.faculty f on  f.emp_id = a.mentor_id
left join prod.class_batches b  on b.class_id= a.class_id
where a.center = 'ALLEN DIGITAL' and a.class_id =2151623 and batch_id =83105
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19


-- Checks
where a.center = 'ALLEN DIGITAL' and a.class_id =2151623 and batch_id =83105
--check
select a.class_id||'_'||batch_id||'_'||group_id as key,
current_date as Last_updated_at,
a.class_id
  ,class_type_id,class_name,mentor_id,a.subject_id,a.topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id,case when batch_id is null then group_id  else null end as group_id ,
  f.subject,f.designation,f.stream as faculty_stream,f.emp_id as faculty_id 
from prod.classes a 
join prod.faculty f on  f.emp_id = a.mentor_id
left join prod.class_batches b  on b.class_id= a.class_id
where a.center = 'ALLEN DIGITAL' 
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19

--New Table 

select  
class_id||'_'||coalesce(batch_id,0)||'_'||coalesce(group_id,0) as key,
current_date as Last_updated_at,
class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, main.zoom_info_id,m_course,center,
  batch_id, group_id ,
  subject,designation,faculty_stream,faculty_id,b.meet_id,
  count(distinct student_id) as total_students
from(
select main.*,  coalesce(st_id_batch,sga.student_id) as student_id 
from 
  ( select main.*,sec.student_id as st_id_batch  from (select a.class_id
  ,class_type_id,class_name,mentor_id,a.subject_id,a.topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id,case when batch_id is null then group_id  else null end as group_id ,
  f.subject,f.designation,f.stream as faculty_stream,f.emp_id as faculty_id 
from prod.classes a 
join prod.faculty f on  f.emp_id = a.mentor_id
left join prod.class_batches b  on b.class_id= a.class_id 
where a.center = 'ALLEN DIGITAL'
)main 
left join  analytics.raw_student_date_batch_mapping  sec on  date(sec.date) = date(main.class_date_time)
and sec.batch_id = main.batch_id 
)main 
left join  prod.student_group_assoc sga on sga.group_id=main.group_id
--where class_id =2151623 and batch_id =83105
)main  
join
     (
     select distinct id as zoom_info_id, meet_id
     from prod.allen_prod_zoom_meet_info
     union
     select distinct id as zoom_info_id, meet_id
     from prod.zoom_meet_info
     ) b on b.zoom_info_id=main.zoom_info_id
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20