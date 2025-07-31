select SESSION_KEY, INPUT_TYPE, STATUS,
to_char(START_TIME,'mm/dd/yy hh24:mi') start_time,
to_char(END_TIME,'mm/dd/yy hh24:mi') end_time,
lpad(floor(elapsed_seconds/3600),2,0)||':'||lpad(floor(mod(elapsed_seconds,3600)/60),2,0) ||':'||lpad(floor(mod(mod(elapsed_seconds,3600),60)),2,0) elapsed 
from gV$RMAN_BACKUP_JOB_DETAILS
order by session_key;

select * from v$rman_output
where  session_recid=:1
order by stamp,recid;