
select q1.student_id,q1.zoom_info_id , count(*) as c
from analytics.Quality_metrics q1
left join truth.raw_student_attendance_master rsam 
on q1.zoom_info_id=rsam.zoom_info_id and q1.student_id=rsam.student_id 
where rsam.student_id is not null and rsam.student_center in ('ALLEN DIGITAL') 
group by 1,2 having c>1 limit  10

select  * from truth.raw_class_master rcm 

-- Merging quality metric with 
select q1.student_id,
sum(overall_punch_status) as pucnh,
count(rsam.class_id) as class_ount,
sum(overall_punch_status)*100/count(rsam.class_id) as ratio_att,
avg(video_input_avg_frame_rate) as frame_rate, 
avg(video_input_avg_jitter) as jitter ,
avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 end ) as resolution  , 
-- avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 *  video_input_avg_frame_rate end ) * 1.0/ (720* 30)  as quality_score, 
avg(video_input_avg_latency) as latency  ,
avg(video_input_avg_frame_rate) * avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 end ) *1.0/(720*30) as quality_score
from analytics.Quality_metrics q1
left join truth.raw_student_attendance_master rsam 
on q1.zoom_info_id=rsam.zoom_info_id and q1.student_id=rsam.student_id 
where rsam.student_id is not null and rsam.student_center in ('ALLEN DIGITAL')
--and q1.student_id=983297 
group by 1

select * from analytics.Quality_metrics limit 10


select sum(overall_punch_status),
count(q1.class_id) as ratio_att,
sum(overall_punch_status)*100/count(class_id) as ratio_att
from truth.raw_student_attendance_master q1 where q1.student_id=983297 

select *
from analytics.Quality_metrics q1
left join (select * from  truth.raw_student_attendance_master where student_center in ('ALLEN DIGITAL')) rsam 
on q1.zoom_info_id=rsam.zoom_info_id and q1.student_id=rsam.student_id
where rsam.student_id is null  limit 100


select * from truth.raw_student_attendance_master rsam where student_id=1028085 

select * from analytics.Quality_metrics where student_id=1028085







