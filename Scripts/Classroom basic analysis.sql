-- Check how many classes scheduled every week
select date_trunc('week',class_Date_time) as date_time,
count(distinct class_id) as class_count
from 
prod.classes a
where date(class_date_time)<='2022-12-31'
group by 1  order by date_time desc limit 1000

--Subject Coverage
select case when subject_name is null then 'Null' else 'ABC' end as flag,sum(coun) as count_ew
from(
select cc.subject_id,ds.subject_name ,count(distinct class_id) as coun from prod.classes cc left join prod.doubt_subject
ds 
on cc.subject_id=ds.id where date(class_date_time)<='2022-12-31'  group by 1,2 ) group by 1 order by count_ew desc 

-- No of students in class 

select date_trunc('week',class_date_time) as flag,
category_name,
count(distinct student_id) as student_count
from 
truth.raw_student_attendance_master rsam where center = 'ALLEN DIGITAL' and date(class_date_time)>='2023-09-23'
group by 1,2 order by flag desc limit 10

-- Per day how many students are attending online_class_actual_duration_seconds 

select 
flag,
count(distinct student_id) as student_count,
avg(classes) as avg_class_conducted,
avg(attended_class) as avg_att,
avg(attPer) as avg_atten_per
from(
select date_trunc('week',class_date_time) as flag,
student_id,
count(distinct class_id) as classes,
count(distinct case when punch_status_online=1 then class_id end ) as Attended_Class,
sum(overall_punch_status)*100/count(*) as attPer
from truth.raw_student_attendance_master rsam 
where date(class_date_time)<='2023-09-30' and date(class_date_time)>='2023-09-01'
and 
class_id in (select class_id from (select *,sum(overall_punch_status) over(partition by class_id) as c  from 
truth.raw_student_attendance_master
where student_center = 'ALLEN DIGITAL' and  date(class_date_time)<='2023-09-30' and date(class_date_time)>='2023-09-01'
 ) where c>1) 
 and rsam.category_name='REGULAR CLASS' 
 and student_center = 'ALLEN DIGITAL'
 --and overall_punch_status is not null
 group by 1,2 order by flag desc ) group by 1 order by flag desc limit 10
 
 -- Checking the timings of the students joining the class most of the times
 select 
 --student_id,
 sum(online_class_actual_duration_seconds)/sum(student_attendance_duration_online) as avg_duration,
 avg(online_class_actual_duration_seconds) as avg_actual_duration,
 avg(student_attendance_duration_online) as avg_student_duration,
 count(distinct class_id) as total_class,
count(distinct case when online_class_actual_duration_seconds<duration then class_id end )as class_with_less_duration
 from(
 select 
 student_id,
 class_id,
 duration,
 rsam.online_class_actual_duration_seconds/60 as online_class_actual_duration_seconds ,
 rsam.student_attendance_duration_online/60 as student_attendance_duration_online
 from
truth.raw_student_attendance_master rsam  
where
date(class_date_time)<='2023-09-20' and date(class_date_time)>='2023-09-01'and
class_id in (select class_id from (select *,sum(overall_punch_status) over(partition by class_id) as c  from 
truth.raw_student_attendance_master
where student_center = 'ALLEN DIGITAL' 
and  date(class_date_time)<='2023-09-20' and date(class_date_time)>='2023-09-01'
 ) where c>1) 
 and rsam.category_name='REGULAR CLASS' 
 and student_center = 'ALLEN DIGITAL'
 and rsam.punch_status_online=1 
 --and student_id=1209351
 )
 
 -- Miscelneous
 
select max(class_date_time) from truth.raw_student_attendance_master rsam

select date_trunc('month',class_date_time) as flag,
--category_name,
case when c<1 then 'Low attendance'
when c=1 then 'only one student'
when c>1 then 'High Attendance' 
when c is null then 'Null' else 'Others' end as cohort
,count(distinct class_id ) as count_class
from (select m1.*,sum(overall_punch_status) over(partition by m1.class_id) as c  from 
truth.raw_student_attendance_master m1
left join (select class_id,canceled from prod.classes group by 1,2) m2 on m1.class_id=m2.class_id
where center = 'ALLEN DIGITAL' and date(class_date_time)>='2023-07-01' and m2.canceled=0
 ) group by 1,2 order by flag desc ,count_class desc
 

 select count(distinct faculty_id) as count_f from truth.raw_student_attendance_master m1
 left join truth.raw_faculty_info rfi on m1.faculty_id=rfi.employee_id
 where center = 'ALLEN DIGITAL' and date(class_date_time)>='2023-07-01' and rfi.designation='Faculty'
 
 select * from (select *,sum(overall_punch_status) over(partition by class_id) as c  from 
truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL' and date(class_date_time)>='2023-07-01' 
 ) where c<=1 limit 1020
 
 select * from truth.raw_faculty_info limit 10
 
 select * from prod.classes where class_id =1651872 and canceled
 
 --Check main query l1
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
     where 
     a.class_id=1651872 and date(a.class_date_time)>= date_add('day',-360,date(current_date)) 
     and date(a.class_date_time)<= current_date and  asa.student_id is not null