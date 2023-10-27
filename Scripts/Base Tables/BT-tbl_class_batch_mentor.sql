-- Class - Batch - Teacher mapping

create table analytics.tbl_class_batch_mentor 
 as
 (
 select
 class_id||batch_id as key
 ,current_date as last_updated_at
 ,class_id
 ,r.class_name
 ,case when class_type_id=1 then 'Live'
 when  class_type_id=3 then 'Recorded Lecture'
 when  class_type_id=5 then 'Webinar'
 when  class_type_id=6 then 'Offline'
else 'others' end as Class_type_name
,class_date_time 
,duration 
,center 
,batch_id 
--unable to find the batch name
,r.subject_id
,s.subject_name 
,r.topic_id
,t.topic_name 
,mentor_id
,f."name" as mentor_name
 from analytics.raw_student_roster r
 left join prod.faculty f
 on r.mentor_id=f.emp_id 
 left join prod.topics t
on t.id=r.topic_id 
left join prod.subject s 
on s.id =r.subject_id 
 where date(main.class_date_time)>='2023-01-01'
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 
 )
 
 
 --QC
 select class_id,batch_id,count(*) as a from analytics.tbl_class_batch_mentor group by 1,2 having a>1 limit 10
 
 select * from analytics.tbl_class_batch_mentor where class_id=660030
 