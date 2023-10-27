select date_trunc('month', class_date_time) as month_flag,
count(distinct class_id) as class_count,
sum(m1.punch_status_online)*100/count( student_id) as class_attendance_per
from truth.raw_student_attendance_master m1
where center = 'ALLEN DIGITAL' and date(class_date_time)>='2023-07-01' and category_name='REGULAR CLASS' and class_id in (select class_id from (select *,sum(punch_status_online) over(partition by class_id) as c  from 
truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) where c>=1) group by 1 order by month_flag desc
 
 
 
 select * from prod.classes where center = 'ALLEN DIGITAL' and date(class_date_time)>='2023-07-01' limit 10 
 
 
select 
date_trunc('month', class_date_time) as month_flag,
count(distinct class_id) as class_count,
sum(m1.punch_status_online)*100/count( student_id) as class_attendance_per
from truth.raw_student_attendance_master m1
where center = 'ALLEN DIGITAL' and date(class_date_time)>='2023-07-01' and category_name='REGULAR CLASS' and class_id in (select class_id from (select *,sum(punch_status_online) over(partition by class_id) as c  from 
truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) where c>=1) group by 1 order by month_flag desc
 
 
 -- Day wise attendance
 
create temp table b as(
 select date_trunc('Week',class_date_time) as class_Date,
 student_id,
 case when sum(m1.punch_status_online)*100/count( student_id)<=60 then 'Low Attendance: <60% Attendance'  
 when sum(m1.punch_status_online)*100/count( student_id)>60 then 'High Attendance:  >60% Attendance'
 else 'Other' end as Rule_Text,
 Count(distinct class_id) as class_count,
  sum(m1.punch_status_online) as attended_classes,
  sum(m1.punch_status_online)*100/count( student_id) as att_per,
     'Hi Student ID  '|| student_id|| 'Your Attendance is   '||
     case when sum(m1.punch_status_online)*100/count( student_id)<=60 then 'Low Attendance'  
 when sum(m1.punch_status_online)*100/count( student_id)>60 then 'High Attendance'
 else 'Other' end||
     --' has attendance '||
          CAST( sum(m1.punch_status_online)*100/count( student_id) as VARCHAR)|| '% for the week '
          ||date(date_trunc('Week',class_date_time)) AS description
 --sum(m1.punch_status_online)*100/count( student_id) as class_attendance_per*/
from truth.raw_student_attendance_master m1
where center = 'ALLEN DIGITAL' and date(class_date_time)>='2023-07-01' 
and category_name='REGULAR CLASS' 
and
class_id in (select class_id from (select *,sum(punch_status_online) over(partition by class_id) as c  from 
truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) where c>=1) group  by 1, 2  order by class_Date desc 
 ) 
 

 -- Create the result_table if it doesn't already exist
CREATE TABLE IF NOT EXISTS result_table (
    student_id INT,
    rule_id INT,
    description VARCHAR(255)
);

drop table analytics.rule_templates

select * from analytics.rule_templates
 
drop table analytics.rule_templates 

 -- Template Tables 
 CREATE TABLE analytics.rule_templates (
    Rule_ID INT PRIMARY KEY,
    Rule_Text VARCHAR(255),
    template_rule VARCHAR(255) 
);
 INSERT INTO analytics.rule_templates (rule_id, Rule_Text,template_rule)
values
  
 /*  (1, 'Low Attendance: <60% Attendance','Hi , Your Attendance is Lower than usual : '),
   (2, 'High Attendance:  >60% Attendance','Hi , Your Attendance is Higher than usual : '),
    (3, 'Low Marks: <60% Marks','Hi , Your Marks are Lower than usual : '),
     (4, 'High Marks: >60% Marks','Hi , Your Marks are Higher than usual : '),*/
        --(5, 'No of Classes:','Hi , Your Classes were : '),
        (6,'Last 7 Days Attendance','Hi, Your last 7 days attendance % : ')
   ;

  
  

   -- Attendance Percentage(Logic 01)
   create temp table b as(
select 
--date_trunc('Week',class_date_time) as class_Date,
 student_id,
 case when sum(m1.punch_status_online)*100/count( student_id)<=60 then 'Low Attendance: <60% Attendance'  
 when sum(m1.punch_status_online)*100/count( student_id)>60 then 'High Attendance:  >60% Attendance'
 else 'Other' end as Rule_Text,
  sum(m1.punch_status_online)*100/count( student_id) as att_per
 --sum(m1.punch_status_online)*100/count( student_id) as class_attendance_per*/
from truth.raw_student_attendance_master m1
where center = 'ALLEN DIGITAL' and date(class_date_time)>='2023-07-01' 
and category_name='REGULAR CLASS' and 
/*and student_id in (1298552,
1284442) and*/
class_id in (select class_id from (select *,sum(punch_status_online) over(partition by class_id) as c  from 
truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) where c>=1) group  by 1 )
 
 -- No of classes(Logic 2)
create temp table c as(
select 
--date_trunc('Week',class_date_time) as class_Date,
 student_id,
 case when count(distinct class_id) is not null then 'No of Classes:' 
 else 'Null' end  as Rule_Text,
 count(distinct class_id) as attended_classes
from truth.raw_student_attendance_master m1
where center = 'ALLEN DIGITAL' and date(class_date_time)>='2023-07-01' 
and category_name='REGULAR CLASS'   and
/*and student_id in (1298552,
1284442) and*/
class_id in (select class_id from (select *,sum(punch_status_online) over(partition by class_id) as c  from 
truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) where c>=1) group  by 1)
 
 -- Logical Table 03
 create temp table d as(
select 
 student_id,
 case when sum(m1.punch_status_online)*100/count( student_id) then 'Last 7 Days Attendance'  
 else 'Other' end as Rule_Text,
  sum(m1.punch_status_online)*100/count( student_id) as att_per
 --sum(m1.punch_status_online)*100/count( student_id) as class_attendance_per*/
from truth.raw_student_attendance_master m1
where center = 'ALLEN DIGITAL' 
and category_name='REGULAR CLASS' and  
 date(class_date_time) >= current_date - interval '7 days' and
class_id in (select class_id from (select *,sum(punch_status_online) over(partition by class_id) as c  from 
truth.raw_student_attendance_master
where center = 'ALLEN DIGITAL'
 ) where c>=1) group  by 1 )
 
 select * from d limit 10

 --drop table c
 drop table b
 
-- Collated Code
   select b.student_id,b1.Rule_Text,b1.rule_id,b1.template_rule||b.att_per||'%' as Metric
   from analytics.rule_templates b1 
   left join b
   on b.Rule_Text=b1.Rule_Text where student_id in (1342774,
1342799,
1342635,
1342611)
   union 
   select c.student_id,b1.Rule_Text,b1.rule_id,b1.template_rule||c.attended_classes as Metric
   from analytics.rule_templates b1 
   left join c 
   on c.Rule_Text=b1.Rule_Text where student_id in (1342774,
1342799,
1342635,
1342611)
   union
    select d.student_id,b1.Rule_Text,b1.rule_id,b1.template_rule||d.att_per||'%' as Metric
   from analytics.rule_templates b1 
   left join d
   on d.Rule_Text=b1.Rule_Text where student_id in (1342774,
1342799,
1342635,
1342611)
  

Examples :
1342774
1342799
1342635
1342611
