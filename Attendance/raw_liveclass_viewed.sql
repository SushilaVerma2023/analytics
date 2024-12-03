select class_id
  ,_user_id as user_id
  ,date
  ,max(attendance) as attendance
  ,1 as pre_class
from (
  select class_id
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,1 as attendance
  from quantumData.pixelService_appEvents
  where event_name = 'classroom_loaded'
  
  union all
  
  select class_id
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,1 as attendance
  from quantumData.pixelService_appEvents
  where event_name = 'classroom_reaction_used'
  
  union all
  
  select class_id
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,1 as attendance
  from quantumData.pixelService_appEvents
  where event_name = 'classroom_button_clicked'
  
  union all
  
  select class_id
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,1 as attendance
  from quantumData.pixelService_appEvents
   where event_name = 'classroom_chatwindow_opened'
   
  union all
  
  select class_id
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,1 as attendance
  from quantumData.pixelService_appEvents
  where event_name = 'classroom_moved_to_background'
  
  union all
  
  select class_id
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,1 as attendance
  from quantumData.pixelService_appEvents
   where event_name = 'classroom_chatwindow_chat_sent'
  
  union all
  
  select class_id
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,1 as attendance
  from quantumData.pixelService_appEvents
   where event_name = 'classroom_chat_reaction_clicked'
  
  union all
  
  select class_id
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,1 as attendance
  from quantumData.pixelService_appEvents
  
  union all
  
  select class_id
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,1 as attendance
  from quantumData.pixelService_appEvents
   where event_name = 'classroom_chatwindow_button_clicked'
     
  union all
  
  select class_id
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,0 as attendance
  from quantumData.pixelService_appEvents
  where event_name = 'classroom_pre_screen_loaded'
  
  union all
  
  select class_name
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,0 as attendance
  from quantumData.pixelService_appEvents
  where event_name = 'classroom_pre_screen_loaded'
  
  union all
  
  select class_id
    ,userID as _user_id
    ,date (eventTimestamp) as date
    ,0 as attendance
  from quantumData.pixelService_appEvents
  where event_name = 'classroom_enter_class_clicked'
  
  union all
  
  -- backend attendance
  select class_id
    ,studentid as _user_id
    ,date (coalesce(student_join_time, student_left_time)) as date
    ,case 
      when student_join_time is not null or student_left_time is not null
        then 1
      end as attendance
  from (
    select class_id
      ,studentid
      ,max(case 
          when upper(signal) like '%LEFT%'
            then generated_at
          else null
          end) as student_left_time
      ,min(case 
          when upper(signal) like '%JOIN%'
            then generated_at
          else null
          end) as student_join_time
    from (
      select attendee_id as studentid
        ,meeting_id as class_id
        ,signal as signal
        ,generated_at
      from classroomdb.classroom_attendees
      where upper(attendee_type) in ('STUDENT')
      )
    group by 1,2
    )
  group by 1,2,3,4
  )
group by 1,2,3