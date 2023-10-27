

select student_id ,
sum(overall_punch_status)*100/count( student_id) as atten_Per,
case when sum(overall_punch_status)*100/count( student_id)<=30 then 'less 30 Attendance'
when sum(overall_punch_status)*100/count( student_id)>30 and   sum(overall_punch_status)*100/count( student_id)<=99 then ' more 30 Attendance' 
when sum(overall_punch_status)*100/count( student_id)=100 then ' 100 Attendance'
else 'Others' end as attendance
,avg(a.video_input_avg_frame_rate) as video_input_avg_frame_rate,
avg(a.audio_input_avg_latency) as audio_input_avg_latency,
count(distinct rsam.student_id) as st_count,
count(distinct rsam.class_id) as class_count
from 
analytics.Quality_metric_part2 a
inner join truth.raw_student_attendance_master rsam 
on 
a.max=rsam.student_id and rsam.zoom_info_id=a.zoom_info_id
group by 1 order by student_id desc

group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,
34,35,36,37,38,39,40,41,42

select count(*) from 
analytics.Quality_metric_part2 where zoom_info_id is null limit 10

select * from truth.raw_student_attendance_master rsam where student_id  =1319985 and date(class_date_time)='2023-08-08'

select date_trunc('month',date) as date, count(distinct student_id)
--count(*) 
from 
analytics.Quality_metric_part2 a
left join truth.raw_student_attendance_master rsam 
on 
a.max=rsam.student_id and rsam.zoom_info_id=a.zoom_info_id group by 1 
where a.max=1319985

-- Final Query 

select *
from 
analytics.Quality_metric_part2 a
inner join truth.raw_student_attendance_master rsam 
on 
a.max=rsam.student_id and rsam.zoom_info_id=a.zoom_info_id and date=date(class_date_time )
where a.max=1319985
limit 1000

--rsam.zoom_info_id=a.zoom_info_id

select count(distinct zoom_info_id ) from analytics.Quality_metric_part2 where max=1319985


select *,current_date as last_updated_as
from(
select st.*,at1.*
from (Select *,zm.id as zoom_info_id
from (select *, REPLACE(participant_id, '"', '') as pid,REPLACE(class_id, '"', '') as cid   from truth.raw_qos_summary_detail 
--where date(date)>='2022-08-01' and date(date)<='2022-08-31'
)  st
  left join prod.zoom_meet_info zm
on zm.meet_id=st.cid 
)st 
left  join 
(select distinct participant_id1,max(student_id) from analytics.quality_part1 
where student_id is not null group by 1 
)  at1 on at1.participant_id1  = st.pid 
)

select * from truth.raw_qos_summary_detail  limit 10


-- part 2 query


select *,current_date as last_updated_as
from(
select st.*,at1.*
from (Select *,zm.id as zoom_info_id
from (select *, REPLACE(participant_id, '"', '') as pid,REPLACE(class_id, '"', '') as cid  
from truth.raw_qos_summary_detail 
--where date(date)>='2022-08-01' and date(date)<='2022-08-31'
)  st
  left join prod.zoom_meet_info zm
on zm.meet_id=st.cid 
)st 
left  join 
(select distinct participant_id1,max(student_id)as student_id from analytics.quality_part1 
where student_id is not null group by 1 
)  at1 on at1.participant_id1  = st.pid 
)

select audio_input_avg_loss*100 as per ,audio_input_avg_loss from analytics.Quality_metric_part2 where class_id='"98002634736"'  and participant_id='"33655808"'


select audi from truth.raw_student_attendance_master rsam where student_id=1319985
