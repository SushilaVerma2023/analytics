select count(distinct employee_id) from truth.raw_faculty_info where status_faculty='active' and designation= 'Faculty' limit 10
select * from  truth.raw_faculty_info limit 10 


--- Main


select at1.experience_with_allen 
from 
truth.raw_faculty_info f1
left join 
analytics.gdrive_gdrive_upload_faculty_feedback fd1
on f1.employee_id=fd1.emp_id 
left join 
analytics.gdrive_gdrive_upload_faculty_attributes at1 
on at1.coding=fd1.coding
--where at1.coding='A-724'
where status_faculty='active' and designation= 'Faculty'
limit 10




select DATE_TRUNC('week',class_date_time),
sum(overall_punch_status)*100.0/count(*) ,
sum(case when c > 0 then overall_punch_status else 0 end )*100.00/sum(case when c > 0 then 1 else 0 end )
from 
(select *,sum(overall_punch_status) over(partition by class_id) as c  from truth.raw_student_attendance_master atm
left join 
(select *
from 
truth.raw_faculty_info f1
left join 
analytics.gdrive_gdrive_upload_faculty_feedback fd1
on f1.employee_id=fd1.emp_id 
left join 
analytics.gdrive_gdrive_upload_faculty_attributes at1 
on at1.coding=fd1.coding
--where at1.coding='A-724'
where status_faculty='active' and designation= 'Faculty') t2 on atm.faculty_id=t2.employee_id
where atm.center = 'ALLEN DIGITAL'
 ) group by 1 order by 1 desc 





select * from truth.raw_student_attendance_master where faculty_id =10224
limit 10

select *
from 
truth.raw_faculty_info f1
left join 
analytics.gdrive_gdrive_upload_faculty_feedback fd1
on f1.employee_id=fd1.emp_id 
left join 
analytics.gdrive_gdrive_upload_faculty_attributes at1 
on at1.coding=fd1.coding
--where at1.coding='A-724'
where status_faculty='active' and designation= 'Faculty' and employee_id=10149


select * from truth.raw_student_attendance_master rsam where class_id =2292445

select DATE_TRUNC('week',class_date_time),
sum(overall_punch_status)*100.0/count(*) ,
sum(case when c > 0 then overall_punch_status else 0 end )*100.00/sum(case when c > 0 then 1 else 0 end )
from 
(select *,sum(overall_punch_status) over(partition by class_id) as c  from truth.raw_student_attendance_master atm
 where class_id=2292445) group by 1 order by 1 desc
