-- Feature usage
select 
event_id
,page_name
,activity_detail
,sum(student_count) as student_count
from
(
select
date_trunc('day',log_date) as flag,
main.event_id,
a.page_name,
a.activity_detail,
count(distinct main.student_id) as student_count
from allen_digital_reporting.activity_log main 
join allen_digital_reporting.event_activity_log  a on a.id = main.event_id  
inner join 
(select student_id ,date(class_date_time) as class_Date, max(punch_status) as punch_status  from analytics.online_roster_v2 
where  active_dau=1  and live_class_clicked=0 and date(class_date_time)>='2023-07-05' group by 1,2
having max(punch_status) is null) v2 on v2.class_Date=main.log_date and v2.student_id=main.student_id
group by 1,2,3,4
order by flag desc 
)group by 1,2,3

--QC Above

select
--date_trunc('day',log_date) as flag,
log_date,
main.event_id,
a.page_name,
a.activity_detail,
main.student_id
from allen_digital_reporting.activity_log main 
join allen_digital_reporting.event_activity_log  a on a.id = main.event_id  
inner join 
(select student_id ,date(class_date_time) as class_Date, max(punch_status) as punch_status  from analytics.online_roster_v2 
where  active_dau=1  and live_class_clicked=0 and date(class_date_time)>='2023-07-05' group by 1,2
having max(punch_status) is null) v2 on v2.class_Date=main.log_date and v2.student_id=main.student_id
where main.student_id=984229
group by 1,2,3,4,5
order by log_date desc 


-- Feature explore Along with Test Clicked(General check)
select date_trunc('week',log_date) as flag, 
sum(Schedule) as Schedule,
sum(digital_material) as digital_material , 
sum(test_report_page) as test_report_page,
sum(Doubt_Solution) as Doubt_Solution,
sum(Change_Password) as Change_Password,
sum(Choose_Course) as Change_Password,
sum(Excercise_Solution) as Excercise_Solution,
sum(Solution_Report) as Solution_Report,
sum(password) as password,
sum(test_videos) as test_videos ,
sum(test_start) as test_start ,
sum(Notice_Board) as Notice_Board,
sum(login) as login,
count(distinct student_id) as student_count
from analytics.raw_activity_summary ras 
--where student_id= 1135728
where test_start<>0
group by 1

-- Feature usage
select date_trunc('week',log_date) as flag, 
count(distinct case when Schedule<>0 then student_id  end)*100/count(distinct student_id) as  Schedule,
count(distinct case when digital_material<>0 then student_id else 0 end)*100/count(distinct student_id) as  digital_material,
count(distinct case when test_report_page<>0 then student_id  end)*100/count(distinct student_id) as  test_report_page,
count(distinct case when Doubt_Solution<>0 then student_id  end)*100/count(distinct student_id) as  Doubt_Solution,
count(distinct case when Choose_Course<>0 then student_id  end)*100/count(distinct student_id) as  Choose_Course,
count(distinct case when Excercise_Solution<>0 then student_id  end)*100/count(distinct student_id) as  Excercise_Solution,
count(distinct case when Solution_Report<>0 then student_id  end)*100/count(distinct student_id) as  Solution_Report,
count(distinct case when test_videos<>0 then student_id  end)*100/count(distinct student_id) as  test_videos,
count(distinct case when test_start<>0 then student_id  end)*100/count(distinct student_id) as  test_start,
count(distinct case when Notice_Board<>0 then student_id  end)*100/count(distinct student_id) as  Notice_Board,
count(distinct case when login<>0 then student_id  end)*100/count(distinct student_id) as  login,
/*sum(Schedule) as Schedule,
sum(digital_material) as digital_material , 
sum(test_report_page) as test_report_page,
sum(Doubt_Solution) as Doubt_Solution,
sum(Change_Password) as Change_Password,
sum(Choose_Course) as Choose_Course,
sum(Excercise_Solution) as Excercise_Solution,
sum(Solution_Report) as Solution_Report,
sum(password) as password,
sum(test_videos) as test_videos ,
sum(test_start) as test_start ,
sum(Notice_Board) as Notice_Board,
sum(login) as login,*/
count(distinct student_id) as student_count
from analytics.raw_activity_summary ras 
--where student_id= 1135728
--where test_start<>0
group by 1




-- MISC



-- Group Conact to check 

select * from analytics.activity_online where student_id =1069384

select * from allen_digital_reporting.activity_log where student_id =1069384

select * from
allen_digital_reporting.activity_log main 
join allen_digital_reporting.event_activity_log  a on a.id = main.event_id where student_id =1069384 and log_date='2023-06-22'

select * from analytics.city_tier limit 10

select * from analytics.raw_activity_summary 

select
min(log_date) 
from analytics.raw_activity_summary

select distinct page_name from prod.event_activity_log limit 1000


select * from  analytics.online_roster_v2 where student_id =1069384 and limit 19