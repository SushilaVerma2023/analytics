
select 
date_trunc('week',rsam2.class_date_time) as date_class,
count( rsam2.student_id) as class_at,
sum(overall_punch_status) as pstatus,
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
left join (select *,sum(overall_punch_status) over(partition by class_id) as c  from truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) t2  on rsam.student_id=t2.student_id and rsam.class_date_time=t2.class_date_time and rsam.class_id=t2.class_id
inner join prod.classes cc on rsam.class_id=cc.class_id where rsam.center = 'ALLEN DIGITAL' 
and cc.publish=1 and rsam.scheduled=1 and lower(rsam.class_name) not like '%doubt%'
and rsam.student_id =797235 and c>0
group by 1,2,3 order by rsam.class_date_time desc
)  order by classes desc 
) raw1 on rsam2.student_id=raw1.student_id and rsam2.class_date_time=raw1.class_date_time and raw1.class_id=rsam2.class_id 
--and raw1.classes=1
 --where rsam2.student_id =1056689
 --and rsam2.class_id =1803925 
 where   rsam2.center = 'ALLEN DIGITAL' and date(rsam2.class_date_time)>='2023-09-01' and rsam2.scheduled=1  and lower(rsam2.class_name) not like '%doubt%'
 group by 1



Select
date_trunc('week',rsam2.class_date_time) as date_class,
--sum(overall_punch_status) over(partition by rsam2.class_id) as c,
sum(case when raw1.classes=1 then overall_punch_status end) as overall_punch_status1,
count( case when raw1.classes=1 then rsam2.student_id end) as classes1,
sum(case when raw1.classes=1 then overall_punch_status end)*100.00/count( case when raw1.classes=1 then rsam2.student_id end) as unique_class_per,
/*sum(case when raw1.classes>=1 then overall_punch_status end) as overall_punch_status,
count(distinct case when raw1.classes>=1 then rsam2.class_id end) as classes,
sum(case when raw1.classes>=1 then overall_punch_status end)/count(distinct case when raw1.classes>=1 then rsam2.class_id end)  as per_overall_class,*/
sum(overall_punch_status) as punch_overall,
count( rsam2.student_id) as student_count,
sum(overall_punch_status)*100.00/count( rsam2.student_id) as attper
from 
truth.raw_student_attendance_master rsam2 
left join 
(
select * ,count(class_id) over(partition by student_id,class_date_time) as classes
from(
select rsam.student_id,rsam.class_date_time,
rsam.class_id
from truth.raw_student_attendance_master rsam 
left join (select *,sum(overall_punch_status) over(partition by class_id) as c  from truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) t2  on rsam.student_id=t2.student_id and rsam.class_date_time=t2.class_date_time and rsam.class_id=t2.class_id
inner join prod.classes cc on rsam.class_id=cc.class_id where rsam.center = 'ALLEN DIGITAL' 
and cc.publish=1  and lower(rsam.class_name) not like '%doubt%'
--and rsam.student_id =797235 and c>0
group by 1,2,3 order by rsam.class_date_time desc
)  order by classes desc 
) raw1 on rsam2.student_id=raw1.student_id and rsam2.class_date_time=raw1.class_date_time and raw1.class_id=rsam2.class_id 
--and raw1.classes=1
 --where rsam2.student_id =1056689
 --and rsam2.class_id =1803925 
 where   rsam2.center = 'ALLEN DIGITAL' and date(rsam2.class_date_time)>='2023-08-01' 
 --and rsam2.scheduled=1  
 and lower(rsam2.class_name) not like '%doubt%'
 and rsam2.class_id in (select class_id from (select *,sum(overall_punch_status) over(partition by class_id) as c  from truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) where c>1)
 --and raw1.class_id is not null
 group by 1
 
 
 -- How many stduents go two classes scheduled at a time
 select 
count(distinct case when classes>1 then student_id end) as student_cout,
count(distinct class_id) as tot_class,
count(distinct student_id) as tot_stu
from (
select * ,count(class_id) over(partition by student_id,class_date_time) as classes
from(
select rsam.student_id,rsam.class_date_time,
rsam.class_id
from truth.raw_student_attendance_master rsam 
left join (select *,sum(overall_punch_status) over(partition by class_id) as c  from truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) t2  on rsam.student_id=t2.student_id and rsam.class_date_time=t2.class_date_time and rsam.class_id=t2.class_id
inner join prod.classes cc on rsam.class_id=cc.class_id where rsam.center = 'ALLEN DIGITAL' 
and cc.publish=1  and lower(rsam.class_name) not like '%doubt%' and rsam.scheduled=1
--and rsam.student_id in (797235 ,1056689)
group by 1,2,3 order by rsam.class_date_time desc
)  order by classes desc
)


select 
case when duration>=0 and duration<=30 then '0-30' 
when duration>30 and duration<=60 then '31-60'
when duration>60 and duration<=90 then '61-90'
when duration>90 and duration<=120 then '91-120'
when duration>120 then'>120' end scheduled_duration_cohort,
count(distinct student_id) as student_count
from(
select student_id, sum(duration)/60 as duration ,sum(overall_punch_status) as overall_punch_status,sum(student_attendance_duration_online/60)/60 as student_attendance_duration_online
from truth.raw_student_attendance_master rsam 
where rsam.center = 'ALLEN DIGITAL' and  lower(rsam.class_name) not like '%doubt%' and rsam.scheduled=1 and date(rsam.class_date_time)>='2023-08-01'
--and student_id =797235
group by 1
) group by 1


select 
case when student_attendance_duration_online>=0  and student_attendance_duration_online<=30 then '0-30' 
when student_attendance_duration_online>30 and student_attendance_duration_online<=60 then '31-60'
when student_attendance_duration_online>60 and student_attendance_duration_online<=90 then '61-90'
when student_attendance_duration_online>90 and student_attendance_duration_online<=120 then '91-120'
when student_attendance_duration_online>120 then'>120' end scheduled_duration_cohort,
count(distinct student_id) as student_count
from(
select student_id, sum(duration)/60 as duration ,sum(coalesce (student_attendance_duration_online,0)/60)/60 as student_attendance_duration_online
from truth.raw_student_attendance_master rsam 
where rsam.center = 'ALLEN DIGITAL' and  lower(rsam.class_name) not like '%doubt%' and rsam.scheduled=1 and date(rsam.class_date_time)>='2023-08-01'
--and student_id =790413
group by 1
) group by 1


select * from truth.raw_student_attendance_master rsam where student_id=790413 and rsam.center = 'ALLEN DIGITAL' and  lower(rsam.class_name) not like '%doubt%' and rsam.scheduled=1 and date(rsam.class_date_time)>='2023-08-01'