-- Number of classes Conducted

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
--
select * from  analytics.online_roster_v2  where faculty_id =15936 limit 100

-- Subject wise attendace 
select 
date_trunc('month',class_Date) as flag_month, 
subject,
sum(total_classes) as total_classes,
sum(Attendance)/sum(total_classes) as ratio
from(
select  
date(class_date_time) as class_Date,
subject,
count(distinct class_id) as total_classes,
sum(punch_status) as Attendance,
count(distinct case when punch_status=1 then student_id end) as Student_count
from analytics.online_roster_v2
where subject not in('Science')
--where student_id =1067302
group by 1,2 ) group by 1,2


-- Faculty wise
select 
--date_trunc('day',class_Date) as flag_month, 
faculty_id,
sum(total_classes) as total_classes,
sum(Attendance)/sum(total_classes) as ratio
from(
select  
date(class_date_time) as class_Date,
faculty_id,
count(distinct class_id) as total_classes,
sum(punch_status) as Attendance,
count(distinct case when punch_status=1 then student_id end) as Student_count
from analytics.online_roster_v2
where subject not in('Science')
--where student_id =1067302
group by 1,2 ) group by 1

-- Deep dive on faculty why lot of Students  have joined the Class
 
select  
date(class_date_time) as class_Date,
faculty_id,
count(distinct class_id) as total_classes,
sum(punch_status) as Attendance,
count(distinct case when punch_status=1 then student_id end) as Student_count
from analytics.online_roster_v2
where subject not in('Science')
--where student_id =1067302
and faculty_id =15936
group by 1,2 