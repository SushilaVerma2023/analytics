select date_trunc('week',date) as flag,
'week' as l1,
avg(video_input_avg_frame_rate) as frame_rate, 
avg(video_input_avg_jitter) as jitter ,
avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 end ) as resolution  , 
-- avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 *  video_input_avg_frame_rate end ) * 1.0/ (720* 30)  as quality_score, 


avg(video_input_avg_latency) as latency  ,
avg(video_input_avg_frame_rate) * avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 end ) *1.0/(720*30) as quality_score 
 from truth.raw_qos_summary_detail group by 1 ,2
 
 union 
 
 select date_trunc('day',date) as flag,
'day' as l1,
avg(video_input_avg_frame_rate) as frame_rate, 
avg(video_input_avg_jitter) as jitter ,
avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 end ) as resolution  , 
-- avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 *  video_input_avg_frame_rate end ) * 1.0/ (720* 30)  as quality_score, 


avg(video_input_avg_latency) as latency  ,
avg(video_input_avg_frame_rate) * avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 end ) *1.0/(720*30) as quality_score 
 from truth.raw_qos_summary_detail group by 1 ,2
  union 
 
 select date_trunc('month',date) as flag,
'month' as l1,
avg(video_input_avg_frame_rate) as frame_rate, 
avg(video_input_avg_jitter) as jitter ,
avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 end ) as resolution  , 
-- avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 *  video_input_avg_frame_rate end ) * 1.0/ (720* 30)  as quality_score, 


avg(video_input_avg_latency) as latency  ,
avg(video_input_avg_frame_rate) * avg(case when video_input_resolution ='' then null else cast(split_part(video_input_resolution,'*',2) as int ) * 1.0 end ) *1.0/(720*30) as quality_score 
 from truth.raw_qos_summary_detail group by 1 ,2
 
 
 -- Changing the class_d columns
 select REPLACE(class_id, '"', '') as new_class_id from truth.raw_qos_summary_detail where class_id= '"98002409854"' limit 10
 
 
 select * from truth.raw_student_attendance_master rsam where student_id =16849920 
 
 
 select * from prod.zoom_meet_info where meet_id =96739753662 limit 10
 
 
 select * from prod.zoom_meet_record where meet_id=98002409854limit 10
 
 select * from prod.zoom_participants where customer_key= limit 10

 select * from truth.raw_qos_summary_detail limit 10
 
 select * from prod.zoom_meeting_register limit 10
 
 
 select * from prod.student where enrollment_no =22303813 limit 10
 
 
 select * from truth.raw_qos_summary_detail st
left  join 
(select participant_id,user_name,student_id,meet_info_id
from(
select REPLACE(participant_id, '"', '') as participant_id ,
REPLACE(user_name, '"', '') as user_name,
rg.*
from analytics.raw_zoom_user_mapping zp 
join prod.zoom_meeting_register rg
on REPLACE(user_name, '"', '')=rg.student_email
) where user_name ='st_0361929909_921424@allen.ac.in') at1 on REPLACE(st.participant_id, '"', '')=at1.participant_id
where at1.student_id=921424

 
 