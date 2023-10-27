-- Attendance Summary 

select 
DATE_TRUNC('day', punch_date) AS day_wise_punch
,count(distinct student_id) as Student_Count
from prod.student_offline_attendance 
where punch_date>='2022-01-01'
group by 1
order by day_wise_punch desc
limit 10

-- week
select 
DATE_TRUNC('week', punch_date) AS week_wise_punch
,count(distinct student_id) as Student_Count
from prod.student_offline_attendance 
where punch_date>='2022-01-01'
group by 1
order by week_wise_punch desc

--Monthly
select 
DATE_TRUNC('month', punch_date) AS month_wise_punch
,count(distinct student_id) as Student_Count
from prod.student_offline_attendance 
where punch_date>='2022-01-01'
group by 1
order by month_wise_punch desc

-- Split by center

select 
DATE_TRUNC('day', att.punch_date) AS day_wise_punch
,st.city_id
,st.center_name
,count(distinct st.student_id) as Student_Count
from prod.student st
left join 
prod.student_offline_attendance att
on st.student_id=att.student_id
where punch_date>='2022-01-01'
group by 1,2,3
order by day_wise_punch desc
limit 10

-- Split by center_name_campus

select 
DATE_TRUNC('day', att.punch_date) AS day_wise_punch
,st.center_name_campus
,count(distinct st.student_id) as Student_Count
from prod.student st
left join 
prod.student_offline_attendance att
on st.student_id=att.student_id
where punch_date>='2022-01-01'
group by 1,2
order by day_wise_punch desc
limit 10
 

-- Split by course_name

select 
course_id,
course_name,
count(distinct student_id) as a 
from prod.student 
group by 1,2
order by a desc 

-- Online or offline 

select 
center_name_campus,
count(distinct student_id) as a 
from prod.student 
group by 1
order by a desc

SELECT 
    CASE WHEN POSITION(',' IN center_name_campus) > 0 
         THEN SUBSTRING(center_name_campus, 1, POSITION(',' IN center_name_campus) - 1) 
         WHEN POSITION('-' IN center_name_campus) > 0
              THEN SUBSTRING(center_name_campus, 1, POSITION('-' IN center_name_campus) - 1) 
         ELSE center_name_campus 
    END AS CITY_name,
   center_name_campus,
    count(distinct student_id) as a 
FROM prod.student
group by 1,2
order by a desc 
;

select 
case 
	when center_name_campus='ALLEN DIGITAL' then 'ONLINE'
	else 'OFFLINE' end as STUDENT_TYPE ,
center_name_campus, 
count(distinct student_id) a 
from prod.student 
group by 1 ,2
order by a desc

select 
case 
	when center_name_campus like '%DIGITAL%' then 'ONLINE'
	else 'OFFLINE' end as STUDENT_TYPE ,
--center_name_campus, 
count(distinct student_id) a 
from prod.student 
group by 1
order by a desc














-- Check on status



select count(distinct att.student_id) as st_att,count(distinct st.student_id) as st
from prod.student  att
left join prod.student_offline_attendance
st on att.student_id=st.student_id 
where 
--st.student_id is null and 
reg_date <='2022-05-12' 
and terms_accepted_datetime is not null and status in (7,9)

select status ,count(distinct student_id) from prod.student  where reg_date <='2022-05-12' 
and terms_accepted_datetime is not null and status in (7,9) group by 1

-- Check reg date
select reg_date ,student_id , count(*) from prod.student group by 1,2 having count(*)>1

select course_id,course_name,
--stream,
count(distinct student_id ) as a 
from prod.student group by 1,2 order by a desc limit 10


-- base table
select 
st.student_id,
st.student_name,
st.fname as father_name,
DATE_TRUNC('month', att.punch_date) AS month_wise_punch,
DATE_TRUNC('week'`, att.punch_date) AS week_wise_punch,
DATE_TRUNC('Day', att.punch_date) AS Day_wise_punch,
att.punch_date,
att.punch_status,
case when att.punch_status='A' then 'Absent'
when att.punch_status='N' then 'Not Marked'
when att.punch_status='P' then 'Present'
when att.punch_status='H' then 'Half Day/Late'
when att.punch_status='L' then 'Leave'
else 'Blank' end as punch_status_new,
st.city_id,
st.state_id,
st.status as status,
case when st.status=7 then 'Active'
when st.status=8 then 'Inactive'
when st.status=9 then 'Enrolled'
else 'Blank' end as student_status,
case 
	when center_name_campus like '%DIGITAL%' then 'ONLINE'
	else 'OFFLINE' end as STUDENT_TYPE ,
	st.dob,
	datediff('year', st.dob, CURRENT_DATE) AS student_age,
	st.gender,
st.stream,
st.course_id,
st.course_name,
st.course_original_name,
st.studycode,
st.batch_id,
st.batch_name,
st.center_name,
st.center_name_campus,
CASE WHEN POSITION(',' IN st.center_name_campus) > 0 
         THEN SUBSTRING(st.center_name_campus, 1, POSITION(',' IN st.center_name_campus) - 1) 
         WHEN POSITION('-' IN st.center_name_campus) > 0
              THEN SUBSTRING(st.center_name_campus, 1, POSITION('-' IN st.center_name_campus) - 1) 
         ELSE st.center_name_campus 
    END AS CITY_name
from prod.student  st 
left join
prod.student_offline_attendance att
on st.student_id =att.student_id
where att.student_id=469522 limit 10


--check 
select mname, count(distinct student_id) from prod.student st group by 1

left join 
prod.student_offline_attendance att on st.student_id =att.student_id where st.student_id=95337 limit 10


select * from prod.faculty where center_name ='KOTA'  and subject ='Mathematics' 


 
 --and enrollment_no =22021413 

---  =============MISCELLENIOUS=================================
 
 
-- Student Attribute Table

select 
st.student_id,
st.enrollment_no,
st.student_name,
st.fname as father_name,
st.mname as Mother_name,
st.city_id,
st.state_id,
--st.status as status,
case when st.status=7 then 'Active'
when st.status=8 then 'Inactive'
when st.status=9 then 'Enrolled'
else 'Blank' end as student_status,
case 
	when center_name_campus like '%DIGITAL%' then 'ONLINE'
	else 'OFFLINE' end as STUDENT_PLATFORM_TYPE ,
	st.dob,
	datediff('year', st.dob, CURRENT_DATE) AS student_age,
	st.gender,
st.stream,
st.course_id,
st.course_name,
st.course_original_name,
st.studycode,
st.batch_id,
st.batch_name,
st.center_name,
st.center_name_campus,
--st.batch_session,
CASE WHEN POSITION(',' IN st.center_name_campus) > 0 
         THEN SUBSTRING(st.center_name_campus, 1, POSITION(',' IN st.center_name_campus) - 1) 
         WHEN POSITION('-' IN st.center_name_campus) > 0
              THEN SUBSTRING(st.center_name_campus, 1, POSITION('-' IN st.center_name_campus) - 1) 
         ELSE st.center_name_campus 
    END AS CITY_name
from prod.student  st  where st.student_id =95337 limit 10

-- Attendence table 

	select enrollment_no ,punch_date,session_id , count(*)  as o
	from prod.student_offline_attendance_new rsr 
	where dval='null'
	 group by 1,2,3 having  o =1 limit 10
 
 --limit 19


 --and punch_date ='2022-07-01'

 
 ---
 

 select  enrollment_no ,punch_date,session_id, min( case when  dval='null' then 'z' else dval end ) as min_val
 from  prod.student_offline_attendance_new 
 --and dval is not null 
 group by 1,2,3 having min_val='z' limit 10
 
 select  enrollment_no, session_id, punch_date, count(distinct dval)as o
  from  prod.student_offline_attendance_new 
 where dval not in ('null')
 group by 1,2,3
 having o>1 limit 10
  
 select * from  prod.student_offline_attendance_new 
 where enrollment_no = 22961037 
 and punch_date ='2023-01-28' and session_id=4
 limit 10
 
select * from prod.student  st limit 10
--

select 
att.enrollment_no ,
DATE_TRUNC('month', att.punch_date) AS month_wise_punch,
DATE_TRUNC('week', att.punch_date) AS week_wise_punch,
DATE_TRUNC('Day', att.punch_date) AS Day_wise_punch
--att.punch_date,
--att.punch_status
/*case when att.punch_status='A' then 'Absent'
when att.punch_status='N' then 'Not Marked'
when att.punch_status='P' then 'Present'
when att.punch_status='H' then 'Half Day/Late'
when att.punch_status='L' then 'Leave'
else 'Blank' end as punch_status_new*/
from prod.student_offline_attendance_new att limit 10
--where att.student_id='95337'
