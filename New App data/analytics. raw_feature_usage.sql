with main as (select app_open.*, 



case when sch.user_id is not null then 1 else 0 end as scheduled, 
case when pre_class.user_id is not null then 1 else 0 end as pre_class, 
case when attendance.user_id is not null then 1 else 0 end as live_class,
COALESCE(sch.classes,0) as classes_scheduled,
COALESCE(attendance.classes,0) as classes_viewed,
case when vod.user_id is not null then 1 else 0 end as vod,
case when doubt.user_id is not null then 1 else 0 end as doubt_asked,
0 as qreel,
              ---case when qreel.studentid is not null then 1 else 0 end as qreel,
case when concept.user_id is not null then 1 else 0 end as concept_card,

coalesce(concept_cards_seen,0) as concept_cards, 
coalesce(videos_viewed,0) as vod_viewed, 
0 as qreel_questions, 
              ---  coalesce(qreel_questions,0) as qreel_questions ,
 coalesce(doubts,0) as number_of_doubts ,
 case when app_open_next_week.user_id is not null then 1 else null end as retained 
 
from (select distinct user_id,date from (select _user_id as user_id,date(timestamp 'epoch' + (time+1980) * interval '1 second') as date  from mixpanel_data._ae_session 
union 
select _user_id as user_id,date(timestamp 'epoch' + (time+1980) * interval '1 second') as date  from mixpanel_data.page_loaded ) )app_open 
left join (select distinct user_id,date(date_trunc('week',date)) as week  from (select _user_id as user_id,date(timestamp 'epoch' + (time+1980) * interval '1 second') as date  from mixpanel_data._ae_session 
union 
select _user_id as user_id,date(timestamp 'epoch' + (time+1980) * interval '1 second') as date  from mixpanel_data.page_loaded ) )app_open_next_week 
on app_open_next_week.user_id = app_open.user_id and app_open_next_week.week = date(date_add('week',1,date_trunc('week',app_open.date)))





left join (select studentid as user_id,class_date as date ,count(distinct class_id) as classes  from analytics.raw_class_schedule
 group by 1,2 )sch  on sch.date = app_open.date 
 and sch.user_id = app_open.user_id 


left join (select user_id,date,count(distinct class_id) as classes  from analytics.raw_liveclass_viewed
 group by 1,2 )pre_class  on pre_class.date = app_open.date 
 and pre_class.user_id = app_open.user_id 


left join (select user_id,date,count(distinct class_id) as classes  from analytics.raw_liveclass_viewed
where attendance = 1  group by 1,2 )attendance 
 on attendance.date = app_open.date and attendance.user_id = app_open.user_id 
 
left join  (select _user_id as user_id,date(timestamp 'epoch' + (time+1980) * interval '1 second') as date,
count(distinct query_search) as videos_viewed
   from mixpanel_data.page_loaded where current_screen in (

'VideoPlayerScreen','VOD') group by 1,2 )vod on vod.date = app_open.date and vod.user_id = app_open.user_id 


left join  (

select _user_id as user_id,date(timestamp 'epoch' + (time+1980) * interval '1 second') as date,
count(distinct concept_card_id )as concept_cards_seen

   from mixpanel_data.page_loaded where lower(current_screen) in (

'concept card') group by 1,2 limit 100  

)concept on concept.date = app_open.date and concept.user_id = app_open.user_id 



-- left join (select distinct studentid,date(createdat) as date ,count(distinct questionid) as qreel_questions   from "improvement-book".improvementbook 
-- where sourcetype = 'LEARNING_JOURNEY'
-- group by 1,2 )qreel on qreel.date = app_open.date and qreel.studentid = app_open.user_id 

left join  (select  seeker_id as user_id,date(doubt_raised) as date,count(distinct doubt_id) as doubts   from analytics.raw_doubt_detail  group by 1,2 )doubt on doubt.date = app_open.date and doubt.user_id = app_open.user_id 

where app_open.user_id is not null and app_open.date is not null)



select ss.uuid, coalesce(aa.date,ss.date) as "date" , 
main.first_name, main.middle_name, main.last_name, main.order_status, main.order_id, main.purchase_date, main.offer_code, main.tallentex_flag, main.renew_flag, main.batch_start_date, main.batch_type, main.batchid, main.old_enrollment_no,  parent_name,batch_name,  batch_code,  batch_description,  batch_gender,  batch_capacity,  phase_name, course_name,  course_language, mastercourse_name,  assigned_course_id,  assigned_course_name, 
 
assigned_stream, assigned_class,  course_id, class, 
         main.stream, phaseid,course_title,case when purchase_date <= ss.date then 'enrolled' else 'freemium' end as student_type,current_class,current_stream,student_board,




aa.user_id,
aa.scheduled,
aa.pre_class,
aa.live_class,
aa.classes_scheduled,
aa.classes_viewed,
aa.vod,
aa.doubt_asked,
aa.qreel,
aa.concept_card,
aa.concept_cards,
aa.vod_viewed,
aa.qreel_questions,
aa.number_of_doubts,
aa.retained


from (select a.date,user_id as uuid 
from 

(select date from main group by 1 ) a 
      join (select main.user_id as user_id,main.sign_up_time as created_at from analytics.nm_user_master_v2   main 
join analytics.raw_student_profile a on a.user_id = main.user_id
)s on date(s.created_at) <= a.date 
      group by 1,2 )ss 
      join analytics.raw_student_profile  main on main.user_id = ss.uuid 

      
      
      left join main  as aa on aa.user_id = ss.uuid
      and ss.date = aa.date
