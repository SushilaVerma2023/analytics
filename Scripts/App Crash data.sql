
--Crash Data

select date_trunc('month',cast(npcrcbd.date as datetime)) monthlysplit 
,count(distinct device) as distinct_devicecrashed
,count(device) as overall_crasheddevice
from next_play_console.next_play_console_ratings_crashes_by_device npcrcbd 
where daily_crashes <>0 group by 1 order by 1 desc limit 10

select date_trunc('month',cast(npcrcbd.date as datetime)) monthlysplit ,
count(distinct device) as distinct_devicecrashed
,count(device) as overall_crasheddevice
from next_play_console.next_play_console_ratings_crashes_by_device npcrcbd 
where daily_anrs  <>0 group by 1 order by 1 desc limit 10


select *
from next_play_console.next_play_console_ratings_crashes_by_app_version_code   limit 10

