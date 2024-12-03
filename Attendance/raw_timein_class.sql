select mp_userId as _userId,meeting_id,sum(lead_time-eventTimestamp) as time_in_class ,min(meet_date_time) as meet_date_time 
from 
(
select mp_userId,
meeting_id,eventTimestamp,lead(eventTimestamp,1) over(partition by mp_userId,meeting_id order by eventTimestamp)  as lead_time 
from 
(
select eventTimestamp , userId as mp_userId,meeting_id   from quantumData.pixelService_appEvents
where event_name = 'agora_remote_audio_stats'

union 
select   eventTimestamp , userId as mp_userId,meeting_id  from quantumData.pixelService_appEvents
where event_name = 'agora_rtc_stats'

union 
select  eventTimestamp , userId as mp_userId,meeting_id  from quantumData.pixelService_appEvents 
where event_name = 'agora_remote_video_stats'

union 
select  eventTimestamp , userId as mp_userId,meeting_id  from quantumData.pixelService_appEvents
where event_name = 'agora_local_video_stats'

union 
select eventTimestamp , userId as mp_userId,meeting_id  from quantumData.pixelService_appEvents 
where event_name = 'agora_local_audio_stats'

union 
 
 select eventTimestamp , userId as mp_userId,room_id as meeting_id    from quantumData.pixelService_appEvents
 where event_name = 'agora_remote_audio_stats'
 
union 
select  eventTimestamp , userId as mp_userId,room_id as meeting_id  from quantumData.pixelService_appEvents
where event_name = 'agora_rtc_stats'

union 
select eventTimestamp , userId as mp_userId,room_id as meeting_id  from quantumData.pixelService_appEvents
where event_name = 'agora_remote_video_stats'

union 
select  eventTimestamp , userId as mp_userId,room_id as meeting_id  from quantumData.pixelService_appEvents
where event_name = 'agora_local_video_stats'

union 
select  eventTimestamp , userId as mp_userId,room_id as meeting_id  from quantumData.pixelService_appEvents
where event_name = 'agora_local_audio_stats'
 
)
)main 
left join (select id as meet_id, date(min(scheduled_start_time)) as meet_date_time  from quantumData.classroom_meetingsNew
 group by 1)a on a.meet_id = main.meeting_id 


where lead_time is not null and lead_time - eventTimestamp < 180  and meeting_id is not null and mp_userId is not null 
group by 1,2
