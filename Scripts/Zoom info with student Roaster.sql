-- Added >=2023-01-01 data only 
select 
*
from(
select main.student_id||'_'||class_id as key ,current_date as last_updated_at ,main.* ,
punch_status
from 
  ( select main.*,student_id from (select a.class_id
  ,class_type_id,class_name,mentor_id,subject_id,topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id 
from prod.classes a 
join prod.class_batches b  on b.class_id= a.class_id 
)main 
join (
--Batch time info
select 
date(a.date) ||'_' || student_id as id, 
date(a.date) as date ,student_id,min(batch_id)as batch_id 
from (select student_id,batch_id,date(change_date) as date ,lead(date(change_date),1)
      over(partition by student_id order by change_date) as till  from prod.student_batch_log order by student_id  )main 
join analytics.date_list a on a.date between main.date and main.till 
where a.date >= date_add('day',-7,date(current_date))
group by 1,2 ,3
--End Batch time info
) sec on sec.batch_id = main.batch_id and date(sec.date) = date(main.class_date_time)
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
 ) a inner join 
 --Zoom info records
 (select class_id,b.zoom_info_id, duration, student_id, b.meet_id, join_time, leave_time,
DATEDIFF('minutes', join_time, leave_time) as diff 
 from
     (
     select distinct class_id, zoom_info_id, duration
     from prod.classes
     where class_type_id=1
     ) a
 join
     (
     select distinct id as zoom_info_id, meet_id
     from prod.zoom_meet_info
     ) b
 on a.zoom_info_id=b.zoom_info_id
 join
     (
     select distinct meet_id, cast(join_time as datetime) as join_time, cast(leave_time as datetime) as leave_time, customer_key as student_id
     from prod.zoom_participants
     ) c
 on b.meet_id=c.meet_id)
  --End Zoom info recordsb 
 on a.zoom_info_id=b.zoom_info_id limit 10
 
 
 
 -----------------------------------------------------
 
 

     
     
     