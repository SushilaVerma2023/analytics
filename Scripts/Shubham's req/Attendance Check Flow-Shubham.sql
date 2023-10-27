

select  
date(sor.class_date_time) as date_col,
center,
student_id,
punch_status,
count(distinct zoom_info_id) as zoom_info_id,
count(distinct sor.class_id) as class
from analytics.Check_online_Attendance sor where date(sor.class_date_time) >='2023-06-01' 
and upper(center) like '%BHUBANESWAR%' 
group by 1,2,3,4


 
 
select 
sum(case when  center='ALLEN DIGITAL' then punch_status end ) as Digital_punch,
sum(case when  center<>'ALLEN DIGITAL' then punch_status end ) as Digital_punch,
sum(punch_status) as overall
from  analytics.Check_online_Attendance sor 
where date(sor.class_date_time) >='2023-06-01' 


select 
sum(case when  center='ALLEN DIGITAL' then punch_status end ) as Digital_punch,
sum(case when  center<>'ALLEN DIGITAL' then punch_status end ) as Digital_punch,
sum(punch_status) as overall
 from   analytics.Check_online_Attendance sor 
 left join prod.student st on sor.student_id=st.student_id 
where date(sor.class_date_time) >='2023-06-01' and st.center_name<>'ALLEN DIGITAL'


select 
center_contri
,count(distinct student_id) as st_tot
from(
select 
student_id,
sum(case when upper(center)='ALLEN DIGITAL' then punch_status end )/sum(punch_status) as center_contri
from analytics.Check_online_Attendance sor where date(sor.class_date_time) >='2023-07-01' and student_id=1071933 group by 1 
--having center_contri<1
) group by 1


select 
center,sum(punch_status) as overall 
from analytics.Check_online_Attendance sor where date(sor.class_date_time)
between '2023-07-01' and '2023-07-31' and
student_id=1071933 group by 1

select 
student_id,
count(distinct center) as c_o
--sum(case when upper(center)='ALLEN DIGITAL' then punch_status end )/sum(punch_status) as center_contri
from analytics.Check_online_Attendance sor where  punch_status=1
 group by 1 having c_o>1
 
 
 select date_trunc('week', class_date_time) as flag,
 student_id,
 subject,
sum(case when punch_status=1 then 1 end ) as att_class, 
count(distinct class_id) as tot_clas
 from  analytics.Check_online_Attendance sor where student_id=1127298 
 group by 1,2,3 order by flag desc
 
 
 select * from analytics.Check_online_Attendance sor where date(sor.class_date_time)
between '2023-07-01' and '2023-07-10' and student_id=1191498

-- New and repeat user 
select 
a.class_id,
date(class_date_time) as class_date,
case when class_date_time=min_date then 'new' else 'repeat' end as repeat_flag,
count(a.student_id) as st_ct
from analytics.Check_online_Attendance a
left join (select student_id, min(date(class_date_time)) as min_date from analytics.Check_online_Attendance where punch_status =1 group by 1) b
on a.student_id=b.student_id
where 
--a.student_id=1255887 and 
date(a.class_date_time)
between '2023-07-01' and '2023-07-10' and punch_status=1
group by 1,2,3
order by class_date desc

-- Top 80 Split
select 
student_id,
center,
att,
total_class,
percentile_cont(0.50) within group (order by att desc) over (partition by center)  as percentile
from(
select 
center,
student_id,
sum(coalesce (punch_status,0)) as att,
count(distinct class_id) as total_class
from  analytics.Check_online_Attendance a
where  date(a.class_date_time)
between '2023-07-01' and '2023-07-31' and student_id=1256274
--and center ='BHUBANESWAR'
group by 1,2
order by att desc 
) group by 1,2,3,4 order by att desc


-- Check
select  
center,
student_id,
batch_id,
sum(coalesce (punch_status,0)) as att,
count(distinct class_id) as total_class
from  analytics.Check_online_Attendance a
where  date(a.class_date_time)
between '2023-07-01' and '2023-07-31'  and batch_id=96980
--and student_id=1256274
group by 1,2,3
order by att desc

-- Batch level
select 
student_id,
center,
att,
total_class,
percentile_cont(0.10) within group (order by att desc) over (partition by center)  as percentile
from(
select 
center,
student_id,
sum(coalesce (punch_status,0)) as att,
count(distinct class_id) as total_class
from  analytics.Check_online_Attendance a
where  date(a.class_date_time)
between '2023-07-01' and '2023-07-31' 
and center ='BHUBANESWAR' 
--and student_id=1256274
group by 1,2
order by att desc 
) group by 1,2,3,4 order by att desc


select min(class_date_time),max(class_date_time) from   analytics.Check_online_Attendance

select * from prod.user_login limit 10


select date_trunc('day', punch_date) as new_,dval , count(distinct enrollment_no) 
from prod.student_offline_attendance_new  where session_id=5 
group by 1,2 order by new_ desc limit 1000

select * from allen_next.tbl_rec_vod_jw_details trvjd  limit 10

select * from allen_next.view_rec_video vrv limit 10

select q1,
count(distinct class_id)
from
(
select class_id,
count(distinct id ) as q1
from prod.rec_vod_details 
where class_id =2138240
group by 1  )group by 1 limit 10


select * from prod.classes where class_id =2138242 limit 10 


select * from  prod.rec_vod_details where class_id =2306523



