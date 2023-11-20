select * from analytics.check_db3 

Select * from analytics.dummy_attendance_tobedeleted3 limit 10


select date,a.student_id,count(distinct class_title) as distinct_video,sum(clicks) as clicks
from 
(	
	select date,STUDENT_ID,class_title,
	       case when lower(subject) like '%bio%' or subject in ('Botany','Zoology') then 'Biology'
	            when lower(subject) like '%che%' or subject in ('Inorganic Chemistry','Organic Chemistry','Physical Chemistry') then 'Chemistry'
	            when lower(subject) like '%mat%' then 'Mathematics'
	            when lower(subject) like '%phy%' then 'Physics' end as subject,
		   SUM(CLIcKS) as clicKs 
	fROM
	(
		 select *
         from 
         (
	         select date(timestamp 'epoch' + time * interval '1 second') as date,_user_id as student_id,class_title,
	         case when len(duration) = 8 then (cast(left(duration,2) as integer)*3600 +  cast(substring(duration,4,2) as integer)*60
						+ cast(right(duration,2) as integer))  
			      when len(duration) = 5 then  (cast(substring(duration,4,2) as integer)*60
						+ cast(right(duration,2) as integer))  end as duration_in_sec,subject,count(*) as clicks
			 from mixpanel_allen_digital.revision_video_viewed ----------recorded_content
			 where _user_id is not null and _user_id='1194139'
			 group by 1,2,3,3,4,5
		 )
		 union 
		 (
			 select date(timestamp 'epoch' + time * interval '1 second') as date,_user_id as student_id,class_title,duration as duration_in_sec,subject,count(*) as clicks
			 from mixpanel_allen_digital.class_viewed ----- study_recorded_content
			 where _user_id is not null and _user_id='1194139'
			 group by 1,2,3,3,4,5
		 )
	 )
	 group by 1,2,3,4
) a 
join 
(
	select student_id,student_stream,student_class
	from truth.raw_student_master 
) b 
on a.student_id = b.student_id
group by 1,2



select 
date(timestamp 'epoch' + time * interval '1 second') as date,_user_id as student_id,class_name,
subject,count(*) as clicks
select * 
from 
mixpanel_allen_digital.material_viewed nui 
where _user_id='1204851' group by 1,2,3,4


select * from prod.student where enrollment_no ='1000644023' limit 10

-- checking splitpart and json
select distinct 
_user_id,
date(timestamp 'epoch' + time * interval '1 second') as date,
  SPLIT_PART(SPLIT_PART(_user_id, ':', 2), '}', 2) AS StudentID2,
case when _user_id like '%{%' then json_extract_path_text(_user_id, 'studentId') else _user_id end  AS StudentID
from  
mixpanel_allen_digital.material_viewed 
where "_user_id" like '%911568%' 

select *
/*date_trunc('month', date(class_date_time)) as class_date,
material_type as material_type,
case when student_id is not null and student_id_m is null then 'class-live' else 'Non Live' end as flag,
count(student_id_m) as student_count_m,
count(class_id) as no_of_classes,
count(overall_punch_status) as total_attendance*/
from
truth.raw_student_attendance_master rsam  
 full join 
(
select date(timestamp 'epoch' + time * interval '1 second') as date,
case when _user_id like '%{%' then json_extract_path_text(_user_id, 'studentId') else _user_id end  AS Student_ID_m,
mm.material_type,mm.subject,mm.topic_name,mm.description from
mixpanel_allen_digital.material_viewed mm
) mm  
on mm.Student_ID_m=rsam.student_id and mm.date=date(rsam.class_date_time) 
where rsam.student_id
=1029173  
--group by 1,2,3

split_part() 


--Only Non live view 
select date(timestamp 'epoch' + time * interval '1 second') as date,
case when _user_id like '%{%' then json_extract_path_text(_user_id, 'studentId') else _user_id end  AS Student_ID_m,
mm.material_type,mm.subject,count(*) as Impressions
--,mm.topic_name
--,mm.description 
from
mixpanel_allen_digital.material_viewed mm
where  "_user_id" like '%911568%' 
group by 1,2,3,4 order by date desc

--{"studentId":"911568"}

-- Total Classes Attended

select 
date(class_date_time) as date,
student_id,
subject ,
'Live Class' as Material_type,
sum(overall_punch_status) as Impressions
from 
truth.raw_student_attendance_master
where student_id =911568
group by 1,2,3,4 
--order by date desc
union
select date(timestamp 'epoch' + time * interval '1 second') as date,
(case when _user_id like '%{%' then json_extract_path_text(_user_id, 'studentId') else _user_id end ) :: INT AS Student_id
,mm.subject,
mm.material_type,count(*) as Impressions
--,mm.topic_name
--,mm.description 
from
mixpanel_allen_digital.material_viewed mm
where  "_user_id" like '%911568%' 
group by 1,2,3,4 
union 
-- Total  Classes Scheduled
select 
date(class_date_time) as date,
student_id,
subject ,
'Class Scheduled' as Material_type,
Count(distinct class_id) as Impressions
from 
truth.raw_student_attendance_master
where student_id =911568
group by 1,2,3,4 order by date,subject  desc



select distinct id,notification_type from prod.st_notification_type  order by limit 200






