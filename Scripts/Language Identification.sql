select date(class_date_time),
case when lower(course_original_name) like '%hindi%' then 1 else 0 end as hindi, 
stream, 
count(*),
sum(punch_date), 
sum(punch_status), 

sum(case when punch_status= 1 then duration else 0 end ) as class_duration,
sum(class_attend_time) as time_students

from 
(select main.*,a.course_original_name,a.stream,max(punch_status) over(partition by main.student_id,date(class_date_time)) as punch_date 
from analytics.online_roster_v2 main 
 join prod.student as a on a.student_id= main.student_id 
 join analytics.raw_activity_summary c on c.student_id= main.student_id 
 and log_date = date(main.class_date_time) 
 where date(main.class_date_time) between date('2023-07-10') 
 and date('2023-07-18')
 and date(main.class_date_time) != date('2023-07-16'))
 
 
 
  group by 1,2,3 order by 1 desc ,3 ,2







