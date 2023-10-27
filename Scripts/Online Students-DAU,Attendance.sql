

select * from analytics.online_roster_v2 
where punch_status is null  and active_dau=1  and live_class_clicked=0 and date(class_date_time)>='2023-07-05'
limit 100


select punch_status
,live_class_clicked
,active_dau
,count(distinct student_id)
from analytics.online_roster_v2 
group by 1,2,3


select active_dau ,
punch_status,
count(distinct student_id) as st
from analytics.online_roster_v2 
where student_id in(
853484,1067302) 
group by 1,2 
order by st desc

-- Main
select 
date_trunc('month', class_date_time) as day_flag,
v1.subject,
count(distinct v1.student_id) as Total_st,
sum(active_dau) as DAU,
sum(live_class_clicked) as Classes_clicked,
sum(punch_status) as Attendance,
count(distinct case when Class_tot=1 then v1.student_id end ) as one_class,
count(distinct case when Class_tot>1 then v1.student_id end ) as more_class
--count(punch_status) over (partition by student_id,class_id,date(class_date_time) ) as cnt
from analytics.online_roster_v2  v1
join (select student_id ,subject, date(class_date_time) as class_date ,count(distinct case when punch_status=1 then class_id end ) as Class_tot 
from analytics.online_roster_v2  group by 1,2,3)v2
on v1.student_id =v2.student_id  and date(v1.class_date_time) =date(v2.class_date)
and v1.subject=v2.subject
--where v1.student_id in(853484,1067302,1069378)
group by 1,2

-- Students who attempt lot of tests which subject
-- Class Scheduled vs how many attempted

select date_trunc('month', class_date_time) as day_flag,
v1.subject,
count(distinct class_id) as total_class_conducted,
count(distinct v1.student_id) as Total_st,
sum(active_dau) as DAU,
sum(live_class_clicked) as Classes_clicked,
sum(live_class_clicked)*100/sum(active_dau) as ratio_clicked,
sum(punch_status) as Attendance,
sum(punch_status)*100/sum(active_dau) as ratio_punch,
count(distinct case when Class_tot=1 then v1.student_id end ) as one_class,
count(distinct case when Class_tot=1 then v1.student_id end )*100/sum(punch_status) as only1class_ratio,
count(distinct case when Class_tot>1 then v1.student_id end ) as more_class
from analytics.online_roster_v2  v1
join (select student_id ,subject, date(class_date_time) as class_date ,count(distinct case when punch_status=1 then class_id end ) as Class_tot 
from analytics.online_roster_v2  group by 1,2,3)v2
on v1.student_id =v2.student_id  and date(v1.class_date_time) =date(v2.class_date)
and v1.subject=v2.subject
--where class_date_time>='2023-07-01' 
--and v1.student_id=1070056
group by 1,2
--limit 10





--Class Timings
select  to_char(class_date_time, 'HH24:MI:SS'),
subject,
count(distinct class_id) as total_classes,
--count(distinct student_id) as tot_stu,
--date_trunc('hour', class_date_time),
--class_date_time,
sum(punch_status) as Attendance,
count(distinct student_id) as Student_count
from analytics.online_roster_v2
--where student_id =1067302
group by 1,2

-- Based on Hour of the day
select  to_char(class_date_time, 'HH24'),
count(distinct class_id) as total_classes,
--count(distinct student_id) as tot_stu,
--date_trunc('hour', class_date_time),
--class_date_time,
sum(punch_status) as Attendance,
count(distinct case when punch_status=1 then student_id end) as Student_count
from analytics.online_roster_v2
--where student_id =1067302
group by 1;


-- Class Scheduled vs how many attempted

select *
from analytics.online_roster_v2  v1
where student_id =810844 and date(class_date_time) ='2023-07-25'


select date_trunc('day', class_date_time) as day_flag,
v1.student_id,
count(distinct v1.class_id) as total_class_conducted,
sum(v1.class_attend_time)/60 as class_attend_time,
/*count(distinct class_id) as total_class_conducted,
count(distinct v1.student_id) as Total_st,
sum(active_dau) as DAU,
sum(live_class_clicked) as Classes_clicked,
sum(live_class_clicked)*100/sum(active_dau) as ratio_clicked,
sum(punch_status) as Attendance,
sum(punch_status)*100/sum(active_dau) as ratio_punch,*/
count(distinct case when Class_tot=1 then v1.student_id end ) as one_class
/*count(distinct case when Class_tot=1 then v1.student_id end )*100/sum(punch_status) as only1class_ratio,
count(distinct case when Class_tot>1 then v1.student_id end ) as more_class*/
from analytics.online_roster_v2  v1
join (select student_id , date(class_date_time) as class_date ,count(distinct case when punch_status=1 then class_id end ) as Class_tot 
from analytics.online_roster_v2  group by 1,2)v2
on v1.student_id =v2.student_id  and date(v1.class_date_time) =date(v2.class_date)
--and v1.subject=v2.subject
--where class_date_time>='2023-07-01' 
where date(class_date_time) ='2023-07-25'
--v1.student_id=810844 and
group by 1,2
having one_class=1

-- Total classes attempted
select 
class_date_time,
count(distinct class_id) as total_classes,
sum(punch_status) as attempted
select *
from analytics.online_roster_v2
where  punch_status =1 limit 10
group by 1

-- People who are attending the Classes with Random/No info

select count(distinct zm.customer_key) from allen_digital.zoom_participants zm
left join prod.student st on zm.customer_key=st.extra_field_1 
--where st.student_id is null limit  10

select 
sum(key)/count(distinct class_id) as avg_class
from(
select cl.class_id 
--zm.customer_key
,count(distinct zm.customer_key) as key
from allen_digital.zoom_participants zm
left join prod.student st on zm.customer_key=st.extra_field_1 
left join allen_digital.zoom_meet_info zn on zn.meet_id = zm.meet_id
left join prod.classes cl on cl.zoom_info_id= zn.id
--where st.student_id is null
where class_id is not null
group by 1 
)

select 
allen_digital.zoom_participants
select * from
allen_digital.zoom_meet_info where id=1035237 limit 10



select * from prod.classes where zoom_info_id =1035237 limit 10

select meet_id ,customer_key ,count(*) from prod.zoom_participants group by 1,2 having count(*)>1 limit 10
