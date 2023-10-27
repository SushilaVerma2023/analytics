
select course,sccity,course,batch, count(*) from prod.batchinfo  group by 1,2,3,4 limit 10


select * from prod.student_activity_log l1
left join prod.activity_log l2
on l1.student_id =l2.student_id 
where l1.student_id =256162 limit 100

select distinct attempt_number  from  prod.student_activity_log limit 10


select id,student_id, count(*) from prod.student_activity_log group by 1,2  
--having count(*) > 1

select * from prod.activity_log
--where id=68857
limit 10

select * from prod.student_activity_log
where student_id ='713297' and test_id =40500 and q_no=1 and time_of_activity ='2022-11-13 08:10:25.000' order by student_id, test_id, q_no , task, time_of_activity
limit 20

select student_id, test_id, q_no , task, time_of_activity, count(*)
from prod.student_activity_log where student_id ='713297' group by 1,2,3,4,5 having count(*)>1


select * from prod.activity_log
where student_id =211 and log_date ='2021-03-23' and log_time ='1970-01-01 23:34:26.000'
limit 10

select student_id, log_date, log_time , event_id , count(*) from prod.activity_log where student_id =211 
group by 1,2,3,4 having count(*)>1

select distinct session_id from prod.student where student_id =95340 limit 10

--student table
select student_id,count(*)   from prod.student  group by 1 having count(*) >1 limit 10

--Courses table 
select course_id , count(*) from prod.courses  group by 1 having count(*)>1 limit 10

-- doubt_answer

select dq_ans_id,count(*) from prod.doubt_answer group by 1 having count(*)>1 limit 2

select distinct shared_reference_id  from prod.doubt_answer

--doubt_mantor_answer

select * from prod.prod.doubt_mentor_answer dma where reply_id=14344 limit 10

select * from prod.prod.doubt_answer dma  where reply_id= 14344 limit 10

-- Are these two above tables same?

select id,count(*) from prod.exam_type group by 1 having count(*)>1 limit 10

select * from prod.exam_type limit 10

--Faculty
select emp_id, count(*) from prod.faculty  group by 1 having count(*)>1 limit 10

--faculty_batch_mapping
select emp_id,batch_id,topic_id ,subject_id,add_date ,count(*) from prod.faculty_batch_mapping 
where emp_id =21567
group by 1,2,3,4,5 having count(*)>1 limit 10

--Faculty_offline_attendance
select emp_id,punch_in_datetime,count(*) from prod.Faculty_offline_attendance group by 1,2 having  count(*)>1 limit 10

select * from  prod.Faculty_offline_attendance where emp_id =16096 and punch_in_datetime='2022-03-25 09:47:00.000'

--question_10<<< TO KNOW MORE>>>>>

select title,count(*) from prod.quiz group by 1 having count(*)>1 limit 19

select * from prod.quiz limit 10
--limit 10

--quiz_ques_lib
select quiz_id,serial_no ,template_id,count(*) from prod.quiz_ques_lib 
--where quiz_id=3 
--where quiz_id is null 
group by 1,2,3 
having count(*)>1

select * from prod.quiz_ques_lib where quiz_id =15 limit 10

--quiz_student
select student_id,quiz_id ,count(*) from prod.quiz_student where viwed >0 group by 1,2 having count(*)>1

select * from prod.quiz_student where submitted  <>0 limit 10

select * from prod.quiz_student where student_id= 839125 and quiz_id=1196 limit 10

-- quiz_student_ans

select student_id,quiz_id,question_id ,count(*) from prod.quiz_student_ans group by 1,2,3 having count(*)>1 limit 10

select * from prod.quiz_student_ans where student_id =1039063 and quiz_id =1100 and question_id=10 limit 10

-- result_examimation

select student_id,test_id,count(*) from prod.result_examination group by 1,2 having count(*)>1 limit 10

select * from prod.result_examination where student_id=814113 and test_id =85915 limit 10


select * from prod.result_examination where student_id=814113 limit 19

-- result_examination_detail'

select * from prod.result_examination e1
left join prod.result_examination_detail e2 
on e1.result_examination_id =e2.result_examination_id 
and e1.student_id=e2.student_id 
where e1.student_id =121636
limit 10

select * from prod.result_examination_detail where result_examination_id= 10534503 limit 10

-- Test

select * from prod.test_question where test_id =87115 and question_no =3440200 limit 10

select * from prod.test order by 1 limit 10

select * from prod.result_examination_section where student_id =814113 and test_id =80494limit 10
---

select * from prod.result_examination_summary where test_id =8049 limit 10

select * from prod.result_examination_Topic where test_id =8049   limit 10
--where student_id =814113 and test_id =80494 limit 10

select * from prod.student_activity_log limit 10


select test_id,question_no ,is_bonus_ques, count(*) from prod.test_question  group by 1,2,3 having count(*)>1


select * from prod.test limit 10
