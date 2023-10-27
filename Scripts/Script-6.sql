-- Added >=2022-01-01 data only 
select main.student_id||'_'||class_id as key ,current_date as last_updated_at ,main.* ,
punch_status
from 
  ( select main.*,student_id from (select a.class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id 
from allen_digital.classes  a 
join prod.class_batches b  on b.class_id= a.class_id 
)main 
join analytics.raw_student_date_batch_mapping sec on sec.batch_id = main.batch_id and date(sec.date) = date(main.class_date_time)
)main 
left join (select 
student_id ,
punch_date ,
case when dval=4 then 0
when dval=3 then 0
when dval=0 then 1
when dval=1 then 1
when dval=2 then 0
else 0 end as punch_status
from (select punch_date,student_id,a.session_id,min(case when dval ='P' then 0 when dval = 'H' then 1 when dval = 'L' then 2  
WHEN dval = 'N' then 3 when dval = 'A' then 4 else 5 end ) as dval  from allen_digital.student_offline_attendance_new main 
join prod.student a on a.enrollment_no = main.enrollment_no and a.session_id= main.session_id 
--where a.student_id=137346
group  by 1,2,3 
 )) a on a.student_id = main.student_id and a.punch_date = date(main.class_date_time)
 
 
 
 -- New table created
 select * from analytics.Raw_student_Offline_roaster limit 100
 where date(main.class_date_time)>='2022-01-01'
 
 
 select date_trunc('month',punch_date) as flag,  count(distinct student_id)
 from allen_digital.student_offline_attendance_new att
 right join prod.student st on att.enrollment_no =st.enrollment_no
 where 
   att.session_id=4 and st.session_id=4 group by 1
 
-- Check Class And Batch
  select date_trunc('month',class_date_time) as flag,
  count(distinct student_id) as st
from
(select main.*,student_id from (select a.class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id 
from allen_digital.classes  a 
join prod.class_batches b  on b.class_id= a.class_id 
)main 
left join analytics.raw_student_date_batch_mapping sec on sec.batch_id = main.batch_id and date(sec.date) = date(main.class_date_time)
) group by 1

--
select student_id,batch_id , count(*) from analytics.raw_student_date_batch_mapping group by 1,2 having count(*)>1 limit 10

select * from analytics.raw_student_date_batch_mapping limit 10


Select a.class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id 
from allen_digital.classes  a 
join prod.class_batches b  on b.class_id= a.class_id 
where batch_id=21016

-- Attendance Offline check
select date_trunc('month',punch_date) as flag,
  count(distinct student_id) as st
  from(
select 
student_id ,
punch_date ,
case when dval=4 then 0
when dval=3 then 0
when dval=0 then 1
when dval=1 then 1
when dval=2 then 0
else 0 end as punch_status
from (select punch_date,student_id,a.session_id,min(case when dval ='P' then 0 when dval = 'H' then 1 when dval = 'L' then 2  
WHEN dval = 'N' then 3 when dval = 'A' then 4 else 5 end ) as dval  from allen_digital.student_offline_attendance_new main 
join prod.student a on a.enrollment_no = main.enrollment_no and a.session_id= main.session_id 
--where a.student_id=137346
group  by 1,2,3 
 )
 ) group by 1 order by flag desc
 
 -- Check cross Join 
   select date(class_date_time) as class_date,
  class_data.student_id,
  att.student_id
from
(select main.*,student_id from (select a.class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id 
from allen_digital.classes  a 
join prod.class_batches b  on b.class_id= a.class_id 
)main 
left join analytics.raw_student_date_batch_mapping sec on sec.batch_id = main.batch_id and date(sec.date) = date(main.class_date_time)
where date(main.class_date_time) ='2022-07-22'
--and '2022-07-31'
) class_data
inner join (select date(punch_date) as punch_date,
  student_id
  from(
select 
student_id ,
punch_date ,
case when dval=4 then 0
when dval=3 then 0
when dval=0 then 1
when dval=1 then 1
when dval=2 then 0
else 0 end as punch_status
from (select punch_date,student_id,a.session_id,min(case when dval ='P' then 0 when dval = 'H' then 1 when dval = 'L' then 2  
WHEN dval = 'N' then 3 when dval = 'A' then 4 else 5 end ) as dval  from allen_digital.student_offline_attendance_new main 
join prod.student a on a.enrollment_no = main.enrollment_no and a.session_id= main.session_id 
--where a.student_id=137346
where date(punch_date)='2022-07-22' 
--and '2022-07-31'
group  by 1,2,3 
 )
 ) ) att on date(class_data.class_date_time)=date(att.punch_date) and att.student_id=class_data.student_id  
 
 
select min(start_date), max(start_date)
from analytics.test_roaster_v2 trv 
limit 100;
