--
drop table analytics.raw_student_roster

create table analytics.raw_student_roster as ( 
select main.student_id||class_id as key ,current_date as last_updated_at ,main.* ,
punch_status
from 
  ( select main.*,student_id from (select a.class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id 
from prod.classes a 
join prod.class_batches b  on b.class_id= a.class_id 
)main 
join analytics.raw_student_date_batch_mapping sec on sec.batch_id = main.batch_id and date(sec.date) = date(main.class_date_time)
)main 
left join (select 
student_id ,
punch_date ,
case when dval=4 then 'Absent'
when dval=3 then 'Not Marked'
when dval=0 then 'Present'
when dval=1 then 'Half Day/Late'
when dval=2 then 'Leave'
else 'Blank' end as punch_status
from (select punch_date,student_id,a.session_id,min(case when dval ='P' then 0 when dval = 'H' then 1 when dval = 'L' then 2  
WHEN dval = 'N' then 3 when dval = 'A' then 4 else 5 end ) as dval  from prod.student_offline_attendance_new main 
join prod.student a on a.enrollment_no = main.enrollment_no and a.session_id= main.session_id 
--where a.student_id=137346
group  by 1,2,3 
 )) a on a.student_id = main.student_id and a.punch_date = date(main.class_date_time)
 where date(main.class_date_time)>='2023-01-01'
 )