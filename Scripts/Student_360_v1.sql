-- Base Table 
create temp table b as (



create table analytics.checkattendance as (
WITH Metrics AS (
    SELECT
        student_id,
        batch_id,
        center,
        sum(case when date(class_date_time) >= current_date - interval '7 days' 
        then overall_punch_status end) * 100 / COUNT(case when date(class_date_time) >= current_date - interval '7 days' 
        then Class_id end )  as Attendance_7D,
        sum(case when date(class_date_time) >= current_date - interval '10 days' 
        then overall_punch_status end) * 100 / COUNT(case when date(class_date_time) >= current_date - interval '10 days' 
        then Class_id end )  as Attendance_10D,
          sum(case when date(class_date_time) >= current_date - interval '30 days' 
        then overall_punch_status end) * 100 / COUNT(case when date(class_date_time) >= current_date - interval '30 days' 
        then Class_id end )  as Attendance_30D,
           sum(case when date(class_date_time) >= current_date - interval '600 days' 
        then overall_punch_status end) * 100 / COUNT(case when date(class_date_time) >= current_date - interval '60 days' 
        then Class_id end )  as Attendance_60D,
           sum(case when date(class_date_time) >= current_date - interval '90 days' 
        then overall_punch_status end) * 100 / COUNT(case when date(class_date_time) >= current_date - interval '90 days' 
        then Class_id end )  as Attendance_90D,
        COUNT(DISTINCT class_id) AS class_count,
        COUNT(DISTINCT faculty_id) AS faculty_count,
        AVG(online_class_actual_duration_seconds/60) AS avg_actual_class_duration,
        AVG(student_attendance_duration_online/60) AS avg_student_duration,
        AVG(duration) AS avg_class_duration,
        SUM(overall_punch_status) * 100 / COUNT(class_id) AS Attendance_per
    FROM truth.raw_student_attendance_master rsam
    WHERE student_id IN (1342774, 1342799, 1342635, 1342611,1342774, 1290116, 1252987)
    GROUP BY 1,2,3  
),
student as 
(select * from truth.raw_student_master rsm WHERE student_id IN (1342774, 1342799, 1342635, 1342611,1342774, 1290116, 1252987) )
,
test as 
(    select student_id,
count(distinct qb_id) as questions_90d ,
count(distinct case when 
attempt_date >= date_add('day',-60,current_date) then qb_id else null end 
) as questions_60d ,
count(distinct case when 
attempt_date >= date_add('day',-30,current_date) then qb_id else null end 
) as questions_30d ,
count(distinct case when 
attempt_date >= date_add('day',-10,current_date) then qb_id else null end 
) as questions_10d ,
count(distinct case when 
attempt_date >= date_add('day',-7,current_date) then qb_id else null end 
) as questions_7d 
from truth.raw_test_student_question_detail 
where 
attempt_date >= date_add('day',-90,current_date)
and student_id in (1342774, 1290116, 1252987, 1342611,1342774, 1342799, 1342635) 
group by 1 )
SELECT student_id, 'class_count' AS metric, CAST(class_count AS VARCHAR) AS value FROM Metrics
UNION ALL
SELECT student_id,  'faculty_count' AS metric, CAST(faculty_count AS VARCHAR) AS value FROM Metrics
UNION ALL
-- Add similar blocks for the other metrics (avg_actual_class_duration, avg_student_duration, and Attendance_per)
SELECT student_id, 'Batch_id' AS metric, CAST(Batch_id AS VARCHAR) AS value FROM Metrics
UNION ALL
SELECT student_id, 'Center' AS metric, CAST(Center AS VARCHAR) AS value FROM Metrics
UNION ALL
SELECT student_id, 'avg_actual_class_duration' AS metric, CAST(avg_actual_class_duration AS VARCHAR) AS value FROM Metrics
UNION ALL
SELECT student_id, 'avg_student_duration' AS metric, CAST(avg_student_duration AS VARCHAR) AS value FROM Metrics
UNION ALL
SELECT student_id, 'avg_class_duration' AS metric, CAST(avg_class_duration AS VARCHAR) AS value FROM Metrics
UNION ALL
SELECT student_id, 'Attendance_per' AS metric, CAST(Attendance_per AS VARCHAR) AS value FROM Metrics
UNION ALL
SELECT student_id, 'Attendance_90D' AS metric, CAST(Attendance_90D AS VARCHAR) AS value FROM Metrics
UNION ALL
SELECT student_id, 'Attendance_30D' AS metric, CAST(Attendance_30D AS VARCHAR) AS value FROM Metrics
UNION ALL
SELECT student_id, 'Attendance_10D' AS metric, CAST(Attendance_10D AS VARCHAR) AS value FROM Metrics
UNION ALL
SELECT student_id, 'Attendance_60D' AS metric, CAST(Attendance_60D AS VARCHAR) AS value FROM Metrics
UNION ALL
SELECT student_id, 'Attendance_7D' AS metric, CAST(Attendance_7D AS VARCHAR) AS value FROM Metrics
union all
select student_id, 'student_name' AS metric, CAST(student_name AS VARCHAR) AS value FROM Student
union all
select student_id, 'student_class' AS metric, CAST(student_class AS VARCHAR) AS value FROM Student
union all
select student_id, 'gender' AS metric, CAST(gender AS VARCHAR) AS value FROM Student
union all
select student_id, 'student_stream' AS metric, CAST(student_stream AS VARCHAR) AS value FROM Student
union all
select student_id, 'course_name' AS metric, CAST(course_name AS VARCHAR) AS value FROM Student
union all
select student_id, 'questions_90d' AS metric, CAST(questions_90d AS VARCHAR) AS value FROM test
ORDER BY student_id,  metric
)
;



select * from b 

drop table b

select Student_id, value,metric from  b where value='104907' 



select * from prod.classes limit 10


