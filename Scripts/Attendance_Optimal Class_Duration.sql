-- People can attend classes prior to the calss start( TO CHECK)
--===== Only 50 cases found and IGNORED
select class_start_time ,class_end_time  ,class_date_time,class_id,student_id,punch_status,active_dau,live_class_clicked ,duration 
from  analytics.online_roster_v2
where 
(class_start_time)<class_date_time and punch_status=1 

-- Classes scheduled for how many students and how many attended

select 
date(class_date_time ) as class_Date
,v1.class_id 
,count(distinct v1.student_id)  as tot_stud,
sum(punch_status) as Attendance,
--sum(punch_status)*100/sum(active_dau)*1.0 as ratio_punch,
count(distinct case when Class_tot=1 then v1.student_id end ) as one_class,
--count(distinct case when Class_tot=1 then v1.student_id end )*100/sum(punch_status)*1.0 as only1class_ratio,
count(distinct case when Class_tot>1 then v1.student_id end ) as more_class
from analytics.online_roster_v2  v1
join (select student_id, date(class_date_time) as class_date ,count(distinct case when punch_status=1 then class_id end ) as Class_tot 
from analytics.online_roster_v2  group by 1,2)v2
on v1.student_id =v2.student_id  and date(v1.class_date_time) =date(v2.class_date)
--and v1.class_id =v2.class_id
--where class_date_time>='2023-07-01' 
--and v1.student_id=1070056
group by 1,2
order by class_Date desc

--Week of the day Attendance

select 
dow_week,
count(distinct class_id) as total_class,
avg(duration) as avg_duration,
sum(tot_stud) as tot_stu,
sum(attendance) as tot_attendance
--sum(tot_stud)* 100.0/sum(attendance)*1.0 as ratio
from
(
select
DATE_PART(dow,  class_date_time) as dow_week,
date(class_date_time ) as class_Date,
class_id,
duration,
class_name,
count( v2.student_id)  as tot_stud,
count( case when punch_status =1 then v2.student_id end ) as attendance,
count( case when punch_status =1 then v2.student_id end )*100/count( v2.student_id)*1.0  as ratio
--count(distinct case when punch_status>1 then v2.student_id end ) as more_class
from analytics.online_roster_v2 v2 
--where class_id in (2233595,2101946) 
group by 1,2,3,4,5
order by class_Date desc ,ratio desc
) group by dow_week order by dow_week desc

-- 

SELECT DATE_PART(day, timestamp '20220501 04:05:06.789');

select DATE_PART(dow,  class_date_time),class_date_time from analytics.online_roster_v2 where date(class_date_time) ='2023-07-17'

--- On what day of week has Hour of the day

Select
DATE_PART(dow,  class_date_time) as dow_week,
--date(class_date_time ) as class_Date,
to_char(class_date_time, 'HH24'),
case when class_name   like '%Doubt%' then 'Doubt Class' else 'Normal Class ' end as Class_Name,
count(distinct class_id) as tot_class,
count( v2.student_id)  as tot_stud,
count( case when punch_status =1 then v2.student_id end ) as attendance,
count( case when punch_status =1 then v2.student_id end )*100/count( v2.student_id)*1.0  as ratio
--count(distinct case when punch_status>1 then v2.student_id end ) as more_class
from analytics.online_roster_v2 v2 
--where class_name  not like '%Doubt%'
--where class_id in (2233595,2101946) 
group by 1,2,3
having dow_week=3
order by dow_week


--Find the timings of the courses by class -FINAL

Select
--DATE_PART(dow,  class_date_time) as dow_week,
--date(class_date_time ) as class_Date,
case when to_char(class_date_time, 'HH24')<=12 then 'Morning Classes' 
when   to_char(class_date_time, 'HH24')>12 and to_char(class_date_time, 'HH24')<=15 then 'Afternoon classes'
when to_char(class_date_time, 'HH24')>15 then 'evening classes' end as hour_day,
--to_char(class_date_time, 'HH24'),
--case when v2.m_course in ('CLASS VI','CLASS VII','CLASS VIII','CLASS IX','CLASS X') then 'low_grade' else v2.m_course end as course_buckect,
--v2.faculty_stream,
case when st.class_value<=10 then 'Low_Grade' 
when st.class_value=11 then 'Nurture'
when st.class_value=12 then 'Enthuse'
when st.class_value>12 then 'Dropper'
else 'Misc' end as Class_value,
stream,
count(distinct class_id) as tot_class,
count( v2.student_id)  as tot_stud,
count( case when punch_status =1 then v2.student_id end )/count(distinct class_id) as per_Class,
count( case when punch_status =1 then v2.student_id end ) as attendance,
count( case when punch_status =1 then v2.student_id end )*100/count( v2.student_id)*1.0  as ratio
--count(distinct case when punch_status>1 then v2.student_id end ) as more_class
from analytics.online_roster_v2 v2 
inner join (select student_id, class_value,stream from prod.student st where session_id=5 group by 1,2,3) st on st.student_id=v2.student_id
--where class_id in (2233595,2101946) 
where  lower(v2.class_name) not like '%doubt%' 
group by 1,2,3
--having dow_week=0
order by hour_day 

-- Checking the gender Wise attendance
select st.gender,
count( v2.student_id)  as tot_stud,
count( case when punch_status =1 then v2.student_id end )/count(distinct class_id) as per_Class,
count( case when punch_status =1 then v2.student_id end ) as attendance,
count( case when punch_status =1 then v2.student_id end )*100/count( v2.student_id)*1.0  as ratio
from analytics.online_roster_v2 v2 
left join ( select student_id, gender ,max(session_id) as sess from prod.student group by 1,2 )st on v2.student_id=st.student_id
--where v2.class_id=2190094 and v2.student_id =785089
group by 1

select 
v2.gender,
count( v2.student_id)  as tot_stud,
count(distinct class_id)  from  analytics.online_roster_v2 v2 
--where class_id in (2233595,2101946) 
where lower(v2.class_name) not like '%doubt%' 
group by 1
--AND lower(v2.class_name) not like '%doubt%' AND lower(v2.class_name) not like '%doubt'


select case when st.class_value>=10 then 'Low_Grade' 
when st.class_value=11 then 'Nurture'
when st.class_value=12 then 'Enthuse'
when st.class_value>12 then 'Dropper'
else 'Misc' end as Class_value, count(distinct student_id) from  prod.student where session_id=5 and class_value =4 group by 1

select * from analytics.online_roster_v2 limit 10;



,case when a.center_name<>'ALLEN DIGITAL' and lower(a.course_original_name) not like '%test series%' then 'Offline'
	when a.center_name='ALLEN DIGITAL' and lower(a.course_original_name) like '%live%' then 'live_Digital'
	when a.center_name='ALLEN DIGITAL' and lower(a.course_original_name) not like '%record%' then 'recorded_Digital'
	when a.center_name = 'ALLEN DIGITAL' then 'olts_Digital'
	else 'Others' end as Vertical
	
	
	-- Check subject level
	Select
v2.subject,
case when st.class_value<=10 then 'Low_Grade' 
when st.class_value=11 then 'Nurture'
when st.class_value=12 then 'Enthuse'
when st.class_value>12 then 'Dropper'
else 'Misc' end as Class_value,
--stream,
count(distinct class_id) as tot_class,
count(distinct v2.student_id) as dist_stu,
count( v2.student_id)  as tot_stud,
count( case when punch_status =1 then v2.student_id end )/count(distinct class_id) as per_Class,
count( case when punch_status =1 then v2.student_id end ) as attendance,
count( case when punch_status =1 then v2.student_id end )*100/count( v2.student_id)*1.0  as ratio
--count(distinct case when punch_status>1 then v2.student_id end ) as more_class
from analytics.online_roster_v2 v2 
inner join (select student_id, class_value,stream from prod.student st where session_id=5 group by 1,2,3) st on st.student_id=v2.student_id
--where class_id in (2233595,2101946) 
where  lower(v2.class_name) not like '%doubt%' 
and date(v2.class_date_time)>='2023-06-01' and date(v2.class_date_time)<='2023-06-30'
group by 1,2
--having dow_week=0
order by subject 

	