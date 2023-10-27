
select  class_type_id,count(distinct  class_id) from prod.classes group by 1 limit 10


select webinar,count(distinct meet_id) from prod.zoom_meet_info group by 1 limit 10



select * from prod.zoom_meet_info where meet_id =98636288483  limit 10


select * from analytics.student_online_roster sor where zoom_info_id =1095894


select * from analytics.student_online_roster sor where class_name ='Principles of inheritance and Variation-Doubt Class'

date(sor.class_date_time) >='2023-08-05'

select * from prod.zoom_meet_info where id= 98636288483 limit 10

-- Check if the zoomid is available 
select count(distinct b.meet_id) from
(
(
     select distinct id as zoom_info_id, meet_id
     from prod.zoom_meet_info
    /* where meet_id in (98636288483,
97736397744,
95027477037,
92217796644,
98832683758,
98795258697,
95693029880,
91987917321,
99019482799,
91757674436,
92636756027,
996238985,
999775367,
96249489463,
91050223593,
92769009837,
95248567233)*/
     ) b 
  left join (select meet_id,min(join_time) as class_start_time, max(leave_time) as class_end_time 
    from prod.zoom_participants group by 1 
  ) eee on eee.meet_id = b.meet_id ) where eee.meet_id is null
  
  
  select * from prod.zoom_participants  where  meet_id =92217796644
  
  (select a.class_id
  ,class_type_id,class_name,mentor_id,a.subject_id,a.topic_id
  ,class_date_time,duration, zoom_info_id,m_course,center,
  batch_id,case when batch_id is null then group_id  else null end as group_id ,
  f.subject,f.designation,f.stream as faculty_stream,f.emp_id as faculty_id 
from prod.classes a 
join prod.faculty f on  f.emp_id = a.mentor_id
left join prod.class_batches b  on b.class_id= a.class_id 
where 
--where a.center = 'ALLEN DIGITAL'
)main left join
(
     select distinct id as zoom_info_id, meet_id
     from prod.allen_prod_zoom_meet_info
     union
     select distinct id as zoom_info_id, meet_id
     from prod.zoom_meet_info
     ) b on b.zoom_info_id=main.zoom_info_id
      
  
  select * from prod.classes where class_name='Principles of inheritance and Variation-Doubt Class'
  
  select * from prod.zoom_participants where meet_id=92217796644
  
  
  
  