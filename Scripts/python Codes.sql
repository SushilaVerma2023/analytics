-- dummy student table
 select * from analytics.dummy_attendance_tobedeleted limit 10
 
 drop table analytics.dummy_attendance_tobedeleted
 
 create table analytics.dummy_attendance_tobedeleted2
 as(
 SELECT
        coalesce (b.student_id,rsam.student_id) as student_id,
        rsm.batch_id,
        center,
        rsm.student_name,
        rsm.enrollment_no,
        rsm.gender,
        rsm.student_stream,
        rsm.course_name,
        rsm.student_class,
        b.questions_60d,
        b.questions_30d,
        b.questions_10d,
        b.questions_7d,
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
    left join (select student_id,
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
--and student_id in (1342774, 1342799, 1342635, 1342611,1342774, 1290116, 1252987,1298552,1284442,1210479,1030160)
group by 1 ) b on rsam.student_id=b.student_id
left join (select * from  truth.raw_student_master rsm)rsm on rsm.student_id=rsam.student_id
where rsam.class_date_time>=date_add('day',-30,current_date)
  --  WHERE rsam.student_id IN (1342774, 1342799, 1342635, 1342611,1342774, 1290116, 1252987,1298552,1284442,1210479,1030160)
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
    )
  

