
select dq_id,dq_ans_id, count(*) as a from analytics.tbl_doubts group by 1,2 having a>1 limit 10

drop table analytics.tbl_doubts

-- Doubts Table 
create table analytics.tbl_doubts
as (
select
dq.dq_id||'_'||da.dq_ans_id as key
,current_date as last_updated_at
,dq.dq_id
 ,dq.student_id
 ,dq.topic_id
 ,dq.doubt_text
 ,dq.image_path as dq_image_path
 ,dq.audio_path as dq_audio_path
 ,case when dq."type"=1 then 'Text'
 when dq."type"=2 then 'Image'
 when dq."type"=3 then 'Camera Image'
 when dq."type"=4 then 'Audio'
 when dq."type"=4 then 'Image and Audio'
else 'others' end as Type_name
 ,dq.add_date  as dq_add_Date
 ,case when dq.satisfy =1 then 'Yes'
 else 'No' end as Satisfy
 ,dq.faculty_id
 ,dq.deleted as dq_deleted
 ,dq.deleted_datetime
 ,dq.deleted_user_id
 ,case when dq.shared_doubt=0 then 'No' else 'Yes'
 end as Shared_doubt
 --answer data
 ,da.dq_ans_id
 ,case when da.user_type=2 then 'faculty'
 when da.user_type=3 then 'Student'
 when da.user_type=0 then '0-Not defined'
 else 'Others' end as dq_User_type
 ,da.answer_text
 ,da.image_path as da_image_path
 ,da.audio_path as da_audio_path
 ,da.reply_id as reply_user_id
 ,case when da."type"=1 then 'Text'
 when da."type"=2 then 'Image'
 when da."type"=3 then 'Camera Image'
 when da."type"=4 then 'Audio'
 when da."type"=4 then 'Image and Audio'
else 'others' end as da_Type_name
,da.add_date as da_add_Date
, da.deleted_datetime as da_deleted_date_time
 ,da.deleted_user_id as da_deleted_user_id
 from prod.doubt_question dq
 left join prod.doubt_answer da
 on dq.dq_id=da.dq_id
 )
