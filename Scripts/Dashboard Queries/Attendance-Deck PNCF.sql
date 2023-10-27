

	Select
v2.subject,
v2.class_id,
stream,
class_value,
course_name,
gender,
count(distinct v2.class_id) as tot_class,
count(distinct v2.student_id) as Total_dist_student,
count( v2.student_id)  as Student_Class_no,
count( case when punch_status =1 then v2.student_id end )/count(distinct v2.class_id) as Students_per_Class,
count( case when punch_status =1 then v2.student_id end ) as attendance,
count( case when punch_status =1 then v2.student_id end )*100/count( v2.student_id)*1.0  as ratio
--count(distinct case when punch_status>1 then v2.student_id end ) as more_class
from analytics.online_roster_v2 v2 
inner join (select student_id, class_value,stream,gender,course_name   from prod.student st group by 1,2,3,4,5) st on st.student_id=v2.student_id
where 
class_id =1846126 and
--class_id in (2233595,2004415,1884336)  and 
  lower(v2.class_name) not like '%doubt%' and lower(stream) like 'pre-nurture' 
and date(v2.class_date_time)>='2023-06-01' and date(v2.class_date_time)<='2023-06-30'
group by 1,2,3,4,5,6
--having dow_week=0
order by subject 

-- % Attendance of student

select v2.student_id,stream,count(distinct v2.class_id) as tot_class,sum(coalesce(punch_status,0)) as attendance,
coalesce (sum(punch_status)*100/count(distinct v2.class_id),0) as att_per
from analytics.online_roster_v2 v2 
inner join prod.student st on v2.student_id=st.student_id 
where date(v2.class_date_time)>='2023-06-01' and date(v2.class_date_time)<='2023-06-30'
--and lower(v2.class_name) not like '%doubt%' and lower(stream) like 'pre-nurture'
and v2.student_id= 785389 
group by 1,2

drop table analytics.test_roaster  

select v2.student_id ,v2.class_id,st.stream,st.class_value,st.stream,st.gender,st.course_name
from analytics.online_roster_v2 v2 
inner join prod.student st on v2.student_id=st.student_id 
where date(v2.class_date_time)>='2023-06-01' and date(v2.class_date_time)<='2023-06-30' and v2.student_id= 785089 limit 10

-- to convert char to date

select class_end_time,class_start_time,cast(class_start_time as timestamp),cast(class_end_time as timestamp),
datediff('minute',cast(class_start_time as timestamp),cast(class_end_time as timestamp)) as tt
--,coast('hour',class_end_time,class_start_time) as min_du 
from analytics.online_roster_v2
group by 1,2 limit 10






