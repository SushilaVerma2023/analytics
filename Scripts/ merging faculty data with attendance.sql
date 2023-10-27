


-- merging faculty data with attendance 

select rsam.* ,st.gender ,tt.id as Topic_id_new,tt.topic_name,t2.fa,t2.division,t2.experience_with_allen,t2.dept as faculty_dept from truth.raw_student_attendance_master rsam
left join truth.raw_student_master st on st.student_id=rsam.student_id 
left join prod.doubt_topics tt 
on tt.id=rsam.topic_id 
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
where status_faculty='active' and designation= 'Faculty') t2
on t2.employee_id=rsam.faculty_id
where date(class_date_time) >= '2023-08-01'
limit 10


