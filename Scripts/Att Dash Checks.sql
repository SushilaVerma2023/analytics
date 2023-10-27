select 
scheduled,
sum(overall_punch_status),
sum(rsam.punch_status_online),
sum(rsam.punch_status_offline),
count(distinct student_id)
from truth.raw_student_attendance_master rsam
--where date(class_date_time) >= '2023-08-01'
group by 1
limit 10



select 
student_center
,count(distinct class_id)
from truth.raw_student_attendance_master
where upper(center)='ALLEN DIGITAL'
group by 1

-- gender Split

Select st.gender,count(distinct Class_id) from(
select rsam.* ,st.gender from truth.raw_student_attendance_master rsam
left join truth.raw_student_master st on st.student_id=rsam.student_id where date(class_date_time) >= '2023-08-01' and date(class_date_time)< current_date  and upper(rsam.student_center)<>'ALLEN DIGITAL') st group by 1

select 
rsdbm.scheduled,
count(distinct st.student_id ) as overallst,
count(distinct rsdbm.student_id)  as att_stu
from prod.student st  
left join truth.raw_student_attendance_master rsdbm  on st.student_id=rsdbm.student_id where st.session_id=5 and st.status=7  group by 1 limit 100



select * from truth.raw_student_attendance_master where student_id=1204850


select count(distinct case when scheduled=1 then student_id else 0 end)*100/count(distinct student_id)  as per,
 count(distinct case when scheduled=1 then student_id else 0 end )as tt,
 count(distinct student_id)
from truth.raw_student_attendance_master where date(class_date_time) >= '2023-08-01' 



-- To check how many classes in a batch per DAY

 select date_trunc('month',class_date_time) as month 
 ,batch_id,count(distinct class_id)/26 as tot_clas from truth.raw_student_attendance_master  
 group by 1,2 order by month desc
 
 -- To check how many classes in a batch per WEEK

 select date_trunc('month',class_date_time) as month 
 ,batch_id,count(distinct class_id)/4 as tot_clas from truth.raw_student_attendance_master  
 group by 1,2 order by month desc
 
 
 -- To Check no classes in a day 
  select date_trunc('month',class_date_time) as month 
 ,batch_id,count(distinct class_id )as tot_clas from truth.raw_student_attendance_master  
 group by 1,2 order by month desc
 

 -- Check scedule Class Coverage
 select 
 date_trunc('week',class_date_time),
 batch_id,
 count(distinct class_id )as tot_clas,
 count(distinct class_id )*100/20 as tot_clas,
  case when (count(distinct class_id )*100/20)>100 then 100 else (count(distinct class_id )*100/20) end  as tot_clas
 from truth.raw_student_attendance_master 
 where batch_id=78030
 group by 1,2
 
 -- QOS data 
 select * from truth.raw_qos_summary_detail limit 10
 
 
 -- Batch and class 
 
 select date_trunc('month',class_date_time) as month ,
 count(distinct class_id)/4 as tot_clas from truth.raw_student_attendance_master  
 group by 1,2 order by month desc
 
 -- 
 select * from truth.raw_student_attendance_master   limit 10
 
 
 select student_stream,count(distinct batch_id||student_id)/count(distinct batch_id) as new_
 from truth.raw_student_attendance_master where   date(class_date_time)>='2023-08-01'group by 1 limit 10
 
 
 
 select distinct overall_punch_status
 ,count(distinct student_id)
 
 select * from  truth.raw_student_attendance_master rsam where  overall_punch_status is not null limit 100
 
 select class_date_time,class_id,case when overall_punch_status is not null then rsam.student_id else 0 end as new1,
 case when overall_punch_status is null then rsam.student_id else 0 end as new2
 from truth.raw_student_attendance_master rsam where student_id=822765 and date(class_date_time)>='2023-08-01'
 
 
 --Check attendance % and coverage %
 select  sum(overall_punch_status),count(rsam.student_id),
 count(case when overall_punch_status is null then rsam.student_id  end ) as new1 ,
  count(case when overall_punch_status is not null then rsam.student_id  end ) as new2,
  sum(overall_punch_status)/(count(case when overall_punch_status is null then rsam.student_id  end )+1.0) as ratio
 from truth.raw_student_attendance_master rsam
left join truth.raw_student_master st on st.student_id=rsam.student_id 
where date(class_date_time) >= '2023-08-01'  and date(class_date_time)>='2023-08-01' and  rsam.student_id=872406 limit 100
 
--check Class Completion %


select sum(student_attendance_duration_online/60) as st_att_duration,sum(duration)
 from truth.raw_student_attendance_master rsam where student_id=
7253 and date(class_date_time)>='2023-08-01'


-- Schedule Classes 

select 
date_trunc('week',class_date_time) as wow ,
count(distinct class_id) as class_c
--count(distinct case when sum(overall_punch_status)>0  then class_id end )as classes_att
from truth.raw_student_attendance_master where batch_id=43469 and date(class_date_time)>='2023-08-01'
group by 1



-- Batch overall check (Query is used in Data set)

select count(*) from (
select main.*,case when a.classes is null then 0 else classes end as classes 
from (select date_trunc('week',date) as week ,lm.batch_id,rsm.student_platform_type,rsm.student_stream,count(distinct lm.student_id) as students
from analytics.raw_student_date_batch_mapping  lm
left join truth.raw_student_master rsm 
on rsm.student_id=lm.student_id
where date>='2023-08-01'
group by 1 ,2,3,4 )main 
left join (select date_trunc('week',date(class_date_time)) as week,batch_id,count(distinct class_id) as classes 
from truth.raw_student_attendance_master  group by 1,2 )a on a.week = main.week and a.batch_id = main.batch_id 
group by 1,2,3,4,5,6
order by classes desc)
 limit 10
 
 

-- Adding center in batches
 
 

 select main.*,case when a.classes is null then 0 else classes end as classes 
from (select date_trunc('week',date) as week ,lm.batch_id,rsm.student_platform_type,rsm.student_stream,rsm.center_name,rsm.center_city,count(distinct lm.student_id) as students
from analytics.raw_student_date_batch_mapping  lm
 join truth.raw_student_master rsm 
on rsm.student_id=lm.student_id and session_name='2023-2024'
where date>='2023-08-01' and rsm.student_platform_type='2.offline' 
group by 1 ,2,3,4,5,6 having students>=5 )main 
left join (select date_trunc('week',date(class_date_time)) as week,batch_id,count(distinct class_id) as classes 
from truth.raw_student_attendance_master  group by 1,2 )a on a.week = main.week and a.batch_id = main.batch_id 
--where main.batch_id=100029
group by 1,2,3,4,5,6,7 ,8
limit 10


--
select distinct center_name from truth.raw_student_master limit 10



--Zoom Chat 
select count(distinct class_id) from 
(select date(left(reverse(split_part(reverse(path),'/',1)),10)) as date_time ,
substring(reverse(split_part(reverse(path),'/',1)),20,
len(split_part(reverse(path),'/',1))
) as class_name  ,
 split_part(split_part(split_part(lower(context),'from',2),'to',1),':',1) as sender,
 split_part(split_part(split_part(lower(context),'from',2),'to',1),':',2) as sender_id,
 split_part(split_part(split_part(lower(context),'from',2),'to',2),':',1) as receiver , 
 split_part(split_part(split_part(lower(context),'from',2),'to',2),':',2) as receiver_id  , 
 text , i as index 
  from zoom_chat.zoom_chat_raw) zcr    inner join prod.classes cl on cl.class_name=trim(zcr.class_name)
  and zcr.date_time=date(cl.class_date_time) limit 100
  
  
  
  select * from prod.classes where class_name='Biological Classification-09'
 
 