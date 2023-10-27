create table analytics.check_quality 
as(
select *,current_date as last_updated_as
from(
select st.*,zm.meet_id,at1.*,zm.id as zoom_info_id from truth.raw_qos_summary_detail st
left  join 
(select participant_id as participant_id1 ,user_name,student_id
from
(
select REPLACE(participant_id, '"', '') as participant_id ,
REPLACE(user_name, '"', '') as user_name,
rg.*
from analytics.raw_zoom_user_mapping zp 
join prod.zoom_meeting_register rg
on REPLACE(user_name, '"', '')=rg.student_email
) 
) at1 on REPLACE(st.participant_id, '"', '')=at1.participant_id1
left join prod.zoom_meet_info zm
on zm.meet_id=REPLACE(st.class_id, '"', '')
--where st.class_id='"95573219742"' and st.participant_id='"16849920"'
) group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23
)


select student_id , count(*) from analytics.check_quality  group by 1 having count(*)>1 limit 10

--Checks

select * from analytics.raw_zoom_user_mapping where participant_id='"16849920"'

-- one  email must be for student_id
select student_email,count(distinct student_id) as c from prod.zoom_meeting_register group by 1 having c>1  

select class_id,participant_id,count(*) from truth.raw_qos_summary_detail  group by 1,2,3 having count(*)>1 limit 10

select * from prod.zoom_meet_info where meet_id=95573219742  limit 10

select * from truth.raw_student_attendance_master rsam where student_id=1137247 and date(class_date_time)='2023-08-17'  limit 10

select distinct live_class_type ,count(distinct class_id) from prod.classes  where date(class_date_time) <='2023-09-01'
group by 1 


-- CHeck how many students are attending how many days(Excel)

select
student_id,
tot,
case 
	when per=0 then 'per 0'
when per<=30 then 'per<=30' 
when per>30 then 'per>30 ' end as  cohort_per,
--count(distinct case when per<=30 and per>0 then date_class end) as days_30,
count(distinct date_class) as days
--count(distinct student_id) as stu_count
from(
select * ,count(date_class) over(partition by student_id) as tot from (
select 
date_trunc('day', rsam.class_date_time) as date_class,
student_id
--count( date(class_date_time)) over(partition by student_id) as c
--,case when lower(class_name) like'doubt' then 'Doubt' else 'normal' end as Class_type
,count(distinct rsam.class_id) as total_classes
,sum(rsam.overall_punch_status) as tot_att
,sum(rsam.overall_punch_status)*100/count(distinct rsam.class_id)  as per
from truth.raw_student_attendance_master rsam 
inner join prod.classes cc on rsam.class_id=cc.class_id where rsam.center = 'ALLEN DIGITAL' 
and date(rsam.class_date_time)>='2023-08-01' and cc.publish=1
group by 1,2 order by date_class desc 
) 
) group by 1,2,3


select count(distinct student_id )
from(

-- Students with overlapping classes for students 
select 
sum(rsam2.overall_punch_status)/count(distinct class_id) as attper
from truth.raw_student_attendance_master rsam2 
where 

-- Stduent class level 

select 
date_trunc('week',rsam2.class_date_time) as date_class,
sum(case when raw1.classes=1 then overall_punch_status end) as overall_punch_status1,
count( case when raw1.classes=1 then rsam2.student_id end) as classes1,
sum(case when raw1.classes=1 then overall_punch_status end)*100/count( case when raw1.classes=1 then rsam2.student_id end) as unique_class_per,
/*sum(case when raw1.classes>=1 then overall_punch_status end) as overall_punch_status,
count(distinct case when raw1.classes>=1 then rsam2.class_id end) as classes,
sum(case when raw1.classes>=1 then overall_punch_status end)/count(distinct case when raw1.classes>=1 then rsam2.class_id end)  as per_overall_class,*/
sum(overall_punch_status) as punch_overall,
count( rsam2.student_id) as student_count,
sum(overall_punch_status)*100/count( rsam2.student_id) as attper 
from 
truth.raw_student_attendance_master rsam2 
left join 
(
select * ,count(class_id) over(partition by student_id,class_date_time) as classes
from(
select rsam.student_id,rsam.class_date_time,
rsam.class_id
from truth.raw_student_attendance_master rsam 
inner join prod.classes cc on rsam.class_id=cc.class_id where rsam.center = 'ALLEN DIGITAL' 
and cc.publish=1 and  rsam.scheduled=1 and lower(rsam.class_name) not like '%doubt%'
--and student_id =797235
group by 1,2,3 order by rsam.class_date_time desc
)  order by classes desc 
) raw1 on rsam2.student_id=raw1.student_id and rsam2.class_date_time=raw1.class_date_time and raw1.class_id=rsam2.class_id 
--and raw1.classes=1
 --where rsam2.student_id =1056689
 --and rsam2.class_id =1803925 
 where 
 --raw1.class_id is not null and 
 rsam2.center = 'ALLEN DIGITAL' and date(rsam2.class_date_time)>='2023-08-01' and rsam2.scheduled=1 and  lower(rsam2.class_name) not like '%doubt%'
 group by 1 order by date_class desc


 --Overall attendance
 

select 
date_trunc('week',rsam2.class_date_time) as date_class,
sum(overall_punch_status)/count(distinct rsam2.class_id) as attper 
from 
truth.raw_student_attendance_master rsam2 
where rsam2.center = 'ALLEN DIGITAL' and date(rsam2.class_date_time)>='2023-08-01'
group by 1

----------   ********************IMP only non overlapping classes attendance
select 
date_trunc('week',rsam2.class_date_time) as date_class,
sum(overall_punch_status)/count(distinct rsam2.class_id) as attper from 
truth.raw_student_attendance_master rsam2 
left join 
(
select * ,count(class_id) over(partition by student_id,class_date_time) as classes
from(
select rsam.student_id,rsam.class_date_time,
rsam.class_id
from truth.raw_student_attendance_master rsam 
inner join prod.classes cc on rsam.class_id=cc.class_id where rsam.center = 'ALLEN DIGITAL' 
and cc.publish=1
--and student_id =797235
group by 1,2,3 order by rsam.class_date_time desc
)  order by classes desc 
) raw1 on rsam2.student_id=raw1.student_id and rsam2.class_date_time=raw1.class_date_time and raw1.class_id=rsam2.class_id and raw1.classes=1
 --where rsam2.student_id =1056689
 --and rsam2.class_id =1803925 
 where raw1.class_id is not null and  rsam2.center = 'ALLEN DIGITAL' and date(rsam2.class_date_time)>='2023-08-01'
 group by 1

-- at class level, class is overlapping
select sum(classes_sch) as student_count from(
select 
class_date_time ,
batch,
group_id,
count(distinct class_id ) as classes_sch
from prod.classes cc where cc.publish=1 and cc.center ='ALLEN DIGITAL'
group by 1,2,3 having classes_sch>1 order by classes_sch desc limit 100
)

select * from truth.raw_student_attendance_master rsam where  student_id=1056689

select * from prod.classes cc where class_id in (2183489,
2269640,
2269642,
2245932,
2245936) and publish=1

-- Classes are not tagged to respective batch,stream
select 
case when c_stream='' and group_id is null then 'blank' else 'OK' end as c_stream,
--case when batch='' and group_id is null then 'blank' else 'OK' end as batch,
case when (duration=0 or duration is null) and group_id is null then 'blank' else 'OK' end as duration,
count(distinct class_id) as total_class
from prod.classes cc where cc.publish=1 and cc.center ='ALLEN DIGITAL' 
--and class_date_time ='2023-07-28 17:30:00.000'
group by 1,2

--select count(*) from truth.raw_student_attendance_master rsam where lower(student_center)  like '%delhi%' and m_course in ('ENTHUSE','NURTURE')