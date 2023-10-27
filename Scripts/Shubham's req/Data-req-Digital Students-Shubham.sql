--LOGIC
select count(distinct student_id)
from(
select 
student_id,
count(*)
/*count(distinct batch_id_att ) as batch_id_att1,
count(distinct batch_id_st) as batch_id_st1*/
from(
select rsam.student_id,
rs.enrollment_no ,
student_center,
rs.course_name,
rs.student_stream,
--rsam.batch_id as batch_id_att,
rs.batch_id as batch_id_st,
rs.batch_name,
count(distinct class_id) as class_count,
sum(overall_punch_status) as att,
sum(overall_punch_status)*100/count(distinct class_id) as overallattendance,
sum(case when date(rsam.class_date_time )>='2023-08-01' and date(rsam.class_date_time )<='2023-08-31' then rsam.punch_status_online end) as att_30day,
count(distinct case when date(rsam.class_date_time )>='2023-08-01' and date(rsam.class_date_time )<='2023-08-31' then rsam.class_id end) as class_30day,
sum(case when date(rsam.class_date_time )>='2023-08-01' and date(rsam.class_date_time )<='2023-08-31' then rsam.punch_status_online end)*100/
count(distinct case when date(rsam.class_date_time )>='2023-08-01' and date(rsam.class_date_time )<='2023-08-31' then rsam.class_id end) as attper30days
from truth.raw_student_attendance_master rsam 
left join truth.raw_student_master rs 
on rsam.student_id=rs.student_id
where rsam.center = 'ALLEN DIGITAL' and rs.session_name='2023-2024' and rsam.batch_id is not null
--and rsam.student_id =789227 
--and date(rsam.class_date_time )
group by 1,2,3,4,5,6,7
) group by 1 having count(*)>1
)



--select student_id,batch_id,max(class_date_time)  from truth.raw_student_attendance_master rsam  where student_id =977542 group by 1,2

-- Requirement - Shubham wanted to see the student attendace in last 30 days and overall and slit of batch whenever any change happened for the student
--MAIN CODE
select 
student_id,
enrollment_no,
student_center,
course_name,
student_stream,
total_marks,
total_question,
right_que,
marks_received,
total_time,
feature_type,
last_test_date,
max(batch_id) as batch_id,
sum(case when  Batch_flag='New Batch' then class_count end) as NB_class_count,
sum(case when Batch_flag='New Batch' then attendance end) as NB_attendance,
sum(case when Batch_flag='New Batch' then overallattendance end) as NB_overallattendanceper,
sum(case when Batch_flag='New Batch' then class_30day end )as NB_class_30day,
sum(case when Batch_flag='New Batch' then att_30day end )as NB_att_30day,
sum(case when Batch_flag='New Batch' then attper30days end) as NB_attper30days,
sum(case when  Batch_flag='Old Batch' then class_count end) as OB_class_count,
sum(case when Batch_flag='Old Batch' then attendance end )as OB_attendance,
sum(case when Batch_flag='Old Batch' then overallattendance end) as OB_overallattendanceper,
sum(case when Batch_flag='Old Batch' then class_30day end )as OB_class_30day,
sum(case when Batch_flag='Old Batch' then att_30day end )as OB_att_30day,
sum(case when Batch_flag='Old Batch' then attper30days end) as OB_attper30days
from(
select
rsam.student_id,
rs.enrollment_no ,
student_center,
rs.course_name,
rs.student_stream,
t2.batch_id,
total_marks,
total_question,
right_que,
marks_received,
total_time,
feature_type,
last_test_date,
--rs.batch_id as batch_st,
case when t2.batch_id=coalesce (rsam.batch_id,rsam.group_id) then 'New Batch' else 'Old Batch' end as Batch_flag,
--rsam.batch_id as batch_id_att,
count(distinct class_id) as class_count,
sum(overall_punch_status) as attendance,
sum(overall_punch_status)*100/count(distinct class_id) as overallattendance,
sum(case when date(rsam.class_date_time )>='2023-08-01' and date(rsam.class_date_time )<='2023-08-31' then rsam.punch_status_online end) as att_30day,
count(distinct case when date(rsam.class_date_time )>='2023-08-01' and date(rsam.class_date_time )<='2023-08-31' then rsam.class_id end) as class_30day,
sum(case when date(rsam.class_date_time )>='2023-08-01' and date(rsam.class_date_time )<='2023-08-31' then rsam.punch_status_online end)*100/
count(distinct case when date(rsam.class_date_time )>='2023-08-01' and date(rsam.class_date_time )<='2023-08-31' then rsam.class_id end) as attper30days
from truth.raw_student_attendance_master rsam 
left join 
(select coalesce (at1.batch_id,at1.group_id) as batch_id,at1.student_id 
from truth.raw_student_attendance_master at1
join ( select student_id,max(class_date_time) as new_date 
from truth.raw_student_attendance_master at2 
--where student_id = 977542
group by 1) at2
on at1.student_id= at2.student_id and at1.class_date_time =at2.new_date) t2 
on rsam.student_id=t2.student_id and coalesce (rsam.batch_id,rsam.group_id)=t2.batch_id
left join truth.raw_student_master rs 
on rsam.student_id=rs.student_id
left join (select student_id,total_marks,total_question,right_que,marks_received,total_time,feature_type,max(test_attempt_date) as last_test_date
from truth.raw_test_student_detail rsdbm   where marks_received is not null
group by 1,2,3,4,5,6,7) st on st.student_id=rsam.student_id
where rsam.center = 'ALLEN DIGITAL' and rs.session_name='2023-2024' 
--and rsam.batch_id is not null 
--and rsam.student_id=977542
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
) group by 1,2,3,4,5,6,7,8,9,10,11,12

--Check

select * from truth.raw_student_attendance_master at2 where student_id=982084 

-- Adding Test Details As well
select student_id,total_marks,total_question,right_que,marks_received,total_time,feature_type,max(test_attempt_date) as last_test_date
from truth.raw_test_student_detail rsdbm where student_id=982084  and marks_received is not null
group by 1,2,3,4,5,6,7


select * from truth.raw_test_student_detail where student_id=977542 
limit 10

