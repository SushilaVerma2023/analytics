
-- CHECKS ONLY
select * from truth.raw_student_first_last_actipg_catalog.pg_identity_provider ty rsfla 
--Overall data no
select count(distinct class_id)
from(
select distinct class_id ,count(distinct batch_id)  as new_ from truth.raw_student_attendance_master rsam where 
date(class_date_time)>='2023-08-01' and student_center ='ALLEN DIGITAL'
 group by 1 having new_>1
 )
 --Check
 select * from prod.class_batches where class_id =2266643 limit 10
 -- 
 
 -- FINAL CODE to BE USED IN PYTHON
 create table analytics.test_assignment
 as(
 select student_id, student_stream, student_platform_type,	course_category,center_name,center_city,
 count(distinct event_date) as date
 ,sum(attendance_record_present) as attendance,	sum(hw_assigned_record_present) as hw_assigned_present,	
 sum(hw_submitted_record_present) as hw_submitted,sum(doubt_asked_record_present) as doubt_asked,
 sum(doubt_answered_record_present) as doubt_answered,sum(test_assigned_record_present) as test_assigned,	
 sum(test_submitted_record_present) as test_submitted,	sum(total_attendance_recorded) as total_attendance,	
 sum(total_attended) as total_attended,	sum(total_classes) as total_classes,	
 sum(total_classes_scheduled_dur) as scheduled_dur,	sum(total_attended_dur_recorded) as dur_recorded,	
 sum(total_hw_assigned) as hw_assigned,	sum(total_hw_question_assigned) as total_hw_question_assigned,	
 sum(total_hw_submitted) as total_hw_submitted,	sum(total_hw_question_of_hw_submitted) as total_hw_question_of_hw_submitted,
 sum(total_hw_question_attempted) as total_hw_question_attempted,	sum(hw_right_que_submitted) as hw_right_que_submitted,
 sum(hw_wrong_que_submitted) as hw_wrong_que_submitted,	sum(hw_left_que_submitted) as hw_left_que_submitted,
 sum(total_doubts_asked) as total_doubts_asked,	sum(total_doubts_answered) as total_doubts_answered,	
 sum(total_doubts_marked_answered) as total_doubts_marked_answered,	sum(total_doubts_satisfied) as total_doubts_satisfied,
 sum(avg_doubt_resolution_time) as avg_doubt_resolution_time,	sum(total_tests_assigned) as total_tests_assigned,
 sum(total_test_questions_assigned) as total_test_questions_assigned,
 sum(total_tests_submitted) as total_tests_submitted,sum(total_test_questions_of_tests_submitted) as total_test_questions_of_tests_submitted,
 sum(total_right_que_submitted) as total_right_que_submitted,sum(total_wrong_que_submitted) as total_wrong_que_submitted,
 sum(total_left_que_submitted) as total_left_que_submitted,	sum(total_questions_attempted_of_tests_submitted) as total_questions_attempted_of_tests_submitted,	
 sum(total_max_marks_of_tests_submitted) as total_max_marks_of_tests_submitted,	sum(total_test_marks_received) as total_test_marks_received,
 sum(app_opens) as app_opens
 --sum(total_doubts_asked,	total_doubts_answered,	total_doubts_marked_answered,	total_doubts_satisfied,	avg_doubt_resolution_time,	total_tests_assigned,	total_test_questions_assigned,	total_tests_submitted,	total_test_questions_of_tests_submitted,	total_right_que_submitted,	total_wrong_que_submitted,	total_left_que_submitted,	total_questions_attempted_of_tests_submitted,	total_max_marks_of_tests_submitted,	total_test_marks_received,	app_opens,
 from truth.agg_daily_student_activity where   student_platform_type='online' 
 and event_date>'2023-03-01'
 group by 1,2,3,4,5,6 
 having sum(total_tests_assigned) >0 
 )

 
 
 --CHECK
 select count(distinct student_id) as abc
 from truth.agg_daily_student_activity where   student_platform_type='online' 
 and event_date>'2023-03-01'
 limit 10
 
 -- Scoring students (POST RUNNING PYTHON CODE)

 select student_id,
 round(score*100/4689,1) as final_score_outof100,
 percentile
 from(
 select student_id,
 (sum(coalesce (attendance,0)*0.111468)+sum(coalesce (total_tests_assigned,0)*0.020607)+sum(coalesce (total_tests_submitted,0)*0.006384)+sum(coalesce (total_test_questions_of_tests_submitted,0)*0.019489)
+sum(coalesce (total_doubts_asked,0)*0.058245)+
sum(coalesce (app_opens,0)*0.326296)+
sum(coalesce (total_test_questions_of_tests_submitted,0)/coalesce (total_tests_submitted*0.310644,1 ))+
sum(coalesce (total_attended,0)/coalesce(total_classes*0.146868,1))) as score,
sum(coalesce (total_test_marks_received/total_max_marks_of_tests_submitted,0))*100 as percentile
 from analytics.test_assignment
 group by 1
 )
 
 
 --IGNORE
 select 
 max((sum(coalesce (attendance,0)*0.111468)+sum(coalesce (total_tests_assigned,0)*0.020607)+sum(coalesce (total_tests_submitted,0)*0.006384)+sum(coalesce (total_test_questions_of_tests_submitted,0)*0.019489)
+sum(coalesce (total_doubts_asked,0)*0.058245)+
sum(coalesce (app_opens,0)*0.326296)+
sum(coalesce (total_test_questions_of_tests_submitted,0)/coalesce (total_tests_submitted,0.000005)*0.310644 )+
sum(coalesce (total_attended,0)/coalesce(total_classes,0.00000005)*0.146868))) as score,
sum(coalesce (total_test_marks_received/total_max_marks_of_tests_submitted,0))*100 as percentile
 from analytics.test_assignment
 --
 select count(distinct student_id)  as overall from   analytics.test_assignment where student_id=791221

 