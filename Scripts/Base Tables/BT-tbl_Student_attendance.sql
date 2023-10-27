-- Enrollment

drop table analytics.tbl_Student_attendance

create table analytics.tbl_Student_attendance
as
(
select distinct enrollment_no ,
att.punch_date
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
 where
 --enrollment_no = 22961037
 att.punch_date>='2022-01-01'
 group by 1,2,3
 ) as att
 )
 
 -- Another check for Hevo
 
select *,
enrollment_no||to_char( punch_date,'YYMMDD')||session_id as key
 ,current_date as Last_updated_at
 from(
 select 
distinct enrollment_no ,
att.punch_date as punch_date
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
 where
-- enrollment_no = 22961037
 att.punch_date>='2022-01-01'
 group by 1,2,3
 ) as att
 )