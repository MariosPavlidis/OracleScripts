select df.con_id,df.tablespace_name "Tablespace",
nvl(totalusedspace,0) "Used MB",
(df.totalspace - nvl(tu.totalusedspace,0)) "Free MB", 
df.actualspace as "Actual File Space",
df.totalspace "Total MB",
round(100 * ( (nvl(tu.totalusedspace,0))/ df.totalspace),2) "Pct. Used",
round(100 * ( (df.totalspace - nvl(tu.totalusedspace,0))/ df.totalspace),2)
"Pct. Free"
from
(
select con_id,tablespace_name,round(sum(decode(autoextensible,'YES',maxbytes,'NO',bytes)) / 1048576) TotalSpace, round (sum(bytes)/1048576) ActualSpace
from cdb_data_files 
group by tablespace_name,con_id
) df
,
(
select  con_id,round(sum(bytes)/(1024*1024)) totalusedspace, tablespace_name
from cdb_segments 
group by con_id,tablespace_name
) tu
where df.tablespace_name = tu.tablespace_name(+)
and df.con_id=tu.con_id 
order by "Pct. Free"