create table analytics.atten_offline_check as select main.*,a.* from (
(select main.*, coalesce(st_id_batch,sga.student_id) as student_id 
from 
  ( select main.*,sec.student_id as st_id_batch  from (select a.class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id,case when batch_id is null then group_id  else null end as group_id 
from prod.classes a 
left join prod.class_batches b  on b.class_id= a.class_id 
where a.center <> 'ALLEN DIGITAL'
)main 
left join  analytics.raw_student_date_batch_mapping  sec on  date(sec.date) = date(main.class_date_time)
and sec.batch_id = main.batch_id 
--where sec.student_id=665276
)main 
left join  prod.student_group_assoc sga on sga.group_id=main.group_id 
) main 
join prod.student asa on asa.student_id = main.student_id
left join (select 
student_id as st ,extra_field_1,
punch_date ,
case when dval=4 then 0
when dval=3 then 0
when dval=0 then 1
when dval=1 then 1
when dval=2 then 0
else 0 end as punch_status
from (select punch_date,student_id,a.extra_field_1 ,a.session_id,min(case when dval ='P' then 0 when dval = 'H' then 1 when dval = 'L' then 2  
WHEN dval = 'N' then 3 when dval = 'A' then 4 else 5 end ) as dval  from prod.student_offline_attendance_new main 
join prod.student a on a.enrollment_no = main.enrollment_no and a.session_id= main.session_id  
--where student_id=665276
group  by 1,2,3 ,4
 )) a on  a.punch_date = date(main.class_date_time) and a.st = main.student_id 
 ) 
 
 select * from analytics.atten_offline_check  where punch_status is not null limit 10
 
 select main.*,sec.student_id as st_id_batch  from (select a.class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id,case when batch_id is null then group_id  else null end as group_id 
from prod.classes a 
left join prod.class_batches b  on b.class_id= a.class_id 
--where a.center <> 'ALLEN DIGITAL'
where batch_id=64741
)main 
left join  analytics.raw_student_date_batch_mapping  sec on  date(sec.date) = date(main.class_date_time)
and sec.batch_id = main.batch_id 
where sec.student_id=665276

select * from analytics.raw_student_roster rsr  limit 10

Select * from analytics.test_roaster limit 10

select 
student_id ,extra_field_1,
punch_date ,
case when dval=4 then 0
when dval=3 then 0
when dval=0 then 1
when dval=1 then 1
when dval=2 then 0
else 0 end as punch_status
from (select punch_date,student_id,a.extra_field_1 ,a.session_id,min(case when dval ='P' then 0 when dval = 'H' then 1 when dval = 'L' then 2  
WHEN dval = 'N' then 3 when dval = 'A' then 4 else 5 end ) as dval  from prod.student_offline_attendance_new main 
join prod.student a on a.enrollment_no = main.enrollment_no and a.session_id= main.session_id  
where student_id=339388
group  by 1,2,3 ,4
 )

 create table analytics.off_att_01 as (
 select main.*, coalesce(st_id_batch,sga.student_id) as student_id 
from 
  ( select main.*,sec.student_id as st_id_batch  from (select a.class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id,case when batch_id is null then group_id  else null end as group_id 
from prod.classes a 
left join prod.class_batches b  on b.class_id= a.class_id 
where a.center <> 'ALLEN DIGITAL'
)main 
left join  analytics.raw_student_date_batch_mapping  sec on  date(sec.date) = date(main.class_date_time)
and sec.batch_id = main.batch_id 
--where sec.student_id=665276
)main 
left join  prod.student_group_assoc sga on sga.group_id=main.group_id
)