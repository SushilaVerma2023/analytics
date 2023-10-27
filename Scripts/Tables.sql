
 
 -- Student Attribute Table

 create table analytics.Raw_student
 as
 (
select 
st.student_id,
st.enrollment_no,
st.student_name,
st.fname as father_name,
st.mname as Mother_name,
st.city_id,
st.state_id,
case when st.session_id=5 then '2023-2024'
when st.session_id=4 then '2022-2023'
when st.session_id=3 then '2021-2022'
when  st.session_id=2 then '2020-2021'
when st.session_id=0 then '0-2019-2020'
else 'Blank' end as Session_name,
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
st.class_value,-- to identify the course name use Stream and Class_value combination
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
from prod.student  st 
--where st.student_id =95337 limit 10
)

-- QC
select 
case when st.session_id=5 then '2023-2024'
when st.session_id=4 then '2022-2023'
when st.session_id=3 then '2021-2022'
when  st.session_id=2 then '2020-2021'
when st.session_id=0 then '0-2019-2020'
else 'Blank' end as Session_name
,student_id, enrollment_no, count(*) from prod.student  st group by 1,2,3 having count(*)>1 limit 10


select enrollment_no, count(distinct course_name) co from prod.student st 
where course_name ='CRASH COURSE FOR NEET-UG PHASE-I'
group by 1 having co>1 limit 100

select distinct course_name , count(distinct student_id ) as ao from prod.student st group by 1 order by ao desc 

select *,count(*) over(partition by enrollment_no ) as c  from prod.student where 
enrollment_no  in 
(select enrollment_no  from prod.student where course_name ='TALLENTPRO XI JEE M+A PHASE-I' and session_id  = 4 )
  order by c desc,enrollment_no  limit 100
  
  -- 
  /* Home Work:
    
  1. Check for the talent pro is it specific to any city conducting these tests 
  2. **How to categorise the Course Name in a proper manner?**
  
  
  */
  

 -- FIANL TABLE - Enrollment

 select distinct enrollment_no ,
DATE_TRUNC('month', att.punch_date) AS month_wise_punch,
DATE_TRUNC('week', att.punch_date) AS week_wise_punch,
DATE_TRUNC('Day', att.punch_date) AS Day_wise_punch
 ,session_id
 --, dval
 ,case when att.dval='A' then 'Absent'
when att.dval='N' then 'Not Marked'
when att.dval='P' then 'Present'
when att.dval='H' then 'Half Day/Late'
when att.dval='L' then 'Leave'
else 'Blank' end as punch_status_new
from
(
select 
enrollment_no,
session_id,
punch_date,
min( case when  dval='null' then 'z' else dval end ) as dval
 from  prod.student_offline_attendance_new as att 
 where enrollment_no = 22961037
 group by 1,2,3
 ) as att
 






-- SKIP THIS --

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
    END AS Study_City_name
from prod.student  st 
left join
prod.student_offline_attendance att
on st.student_id =att.student_id
where att.student_id=469522 
limit 10



-- Class - Batch - Teacher mapping

create table analytics.tbl_class_batch_mentor 
 as
 (select 
 class_id
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
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13
 )

----EXPLOREING
select  topic_id ,subject_id
, count(distinct class_id) a 
from prod.classes 
group by 1 ,2
order by a desc

--limit 10

select Count(distinct c.emp_id) as faculty ,count(distinct f.mentor_id) as class_mentor
from prod.classes  f
left join
prod. faculty c 
on c.emp_id =f.mentor_id 
where f.mentor_id is null

select emp_id,batch_id,topic_id,subject_id,add_date,count(*) from prod.faculty_batch_mapping
-- whereemp_id=21567
group by 1,2,3,4,5 having count(*)>1 limit 10

select * from prod.class_batches where class_id= 17173 limit 10

select * from prod.classes where class_id =17173 limit 10

select * from prod.batchinfo limit 10

--*****Anuj Sent

-- 709107371.269169.sql 11:46:11 AM
create table analytics.raw_student_date_batch_mapping as (
select date(a.date_add) as date ,student_id,min(batch_id)as batch_id 
from (
select student_id,batch_id,date(change_date) as date
,lead(date(change_date),1) over(partition by student_id order by change_date) as till  
from prod.student_batch_log order by student_id  
)main 
join analytics.date_list a on a.date_add between main.date and main.till 
group by 1,2 
)


drop table analytics.raw_student_roster 

create table analytics.raw_student_roster as ( 
select main.* ,
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
--where a.student_id=469522
group  by 1,2,3 
 )) a on a.student_id = main.student_id and a.punch_date = date(main.class_date_time)
 )
 
-- Doubt Question Mapping 
 

 select dq_id , count(*) from prod.doubt_question group by 1 having count(*)>1 limit 10
 
 
 select dq_id , count(*) from prod.doubt_answer group by 1 having count(*)>1 limit 10

 select * from prod.doubt_answer where dq_id=20982
 
 select dq.dq_id
 ,dq.student_id
 ,dq.topic_id
 ,dq.doubt_text
 ,dq.image_path as dq_image_path
 ,dq.audio_path as dq_audio_path
 ,case when dq."type"=1 then 'Text'
 when dq."type"=2 then 'Image'
 when dq."type"=3 then 'Camera Image'
 when dq."type"=4 then 'Audio'
 when dq."type"=4 then 'Image and Audio'
else 'others' end as Type_name
 ,dq.add_date  as dq_add_Date
 ,case when dq.satisfy =1 then 'Yes'
 else 'No' end as Satisfy
 ,dq.faculty_id
 ,dq.deleted as dq_deleted
 ,dq.deleted_datetime
 ,dq.deleted_user_id
 ,case when dq.shared_doubt=0 then 'No' else 'Yes'
 end as Shared_doubt
 --answer data
 ,da.dq_ans_id
 ,case when da.user_type=2 then 'faculty'
 when da.user_type=3 then 'Student'
 when da.user_type=0 then '0-Not defined'
 else 'Others' end as dq_User_type
 ,da.answer_text
 ,da.image_path as da_image_path
 ,da.audio_path as da_audio_path
 ,da.reply_id as reply_user_id
 ,da.audio_path as da_audio_path
 ,case when da."type"=1 then 'Text'
 when da."type"=2 then 'Image'
 when da."type"=3 then 'Camera Image'
 when da."type"=4 then 'Audio'
 when da."type"=4 then 'Image and Audio'
else 'others' end as da_Type_name
,da.add_date as da_add_Date
, da.deleted_datetime as da_deleted_date_time
 ,da.deleted_user_id as da_deleted_user_id
 from prod.doubt_question dq
 left join prod.doubt_answer da
 on dq.dq_id=da.dq_id
 where dq.dq_id=20982
 
 
  
 
 
 select * from prod.doubt_mentor_question where dq_id =20982 
 
 select * 
 from prod.doubt_question limit 10
 
select * from prod.doubt_answer where dq_id =20982 limit 10