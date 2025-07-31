select sample_time,session_id,session_serial#,sql_id,temp_space_allocated/1024/1024 temp_mb,
temp_space_allocated/1024/1024-lag(temp_space_allocated/1024/1024,1,0) over (order by sample_time) as temp_diff
--from dba_hist_active_sess_history
from v$active_session_history
WHERE  sample_time > SYSDATE - 5/(24*60) -- 5 mins
order by sample_time asc;