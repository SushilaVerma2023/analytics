--Raw_student_Offline_roaster

select min(class_date_time),max(class_date_time),max(last_updated_at) 
from analytics.Raw_student_Offline_roaster limit 10

--raw_student
select min(add_date),max(add_date),max(last_updated_at) from analytics.raw_student limit 10

--student_profile_mixpanel_events

select count(*) from analytics.student_profile_mixpanel_events limit 10

-- date_list
select min(date) from analytics.date_list dl limit 10

--raw_student_date_batch_mapping

select min(date),max(date) from analytics.raw_student_date_batch_mapping limit 10

--test_roaster
select test_id,student_id,count(*) from analytics.test_roaster group by 1,2 having count(*) >1 limit 10

-- raw_activity_summary
select * from analytics.raw_activity_summary limit 10

-- raw_student_detailed_results 

select test_id,student_id,question_no_h,result_examination_detail_id, count(*) 
from analytics.raw_student_detailed_results group by 1,2,3,4
having count(*)>1 limit 10

Select min(exam_date),max(exam_date) from analytics.raw_student_detailed_results  limit 10

select * from  analytics.raw_student_detailed_results rs
where student_id=1155162 and question_no_h=379407 and test_id=92912  and exam_date 

--tbl_doubts

select min(dq_add_date),max(dq_add_date) from analytics.tbl_doubts  limit 10

-- tbl_class_batch_mentor
select min(class_Date_time),max(class_date_time) from analytics.tbl_class_batch_mentor limit 10