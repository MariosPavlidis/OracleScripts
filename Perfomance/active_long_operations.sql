select sid, opname, target, sofar/totalwork*100 perc,totalwork,sofar, 
floor(TIME_REMAINING/60)||':'||lpad(round(60*(TIME_REMAINING/60-floor(TIME_REMAINING/60)),2),2,0) remain 
from v$session_longops 
where sofar<totalwork
order by 1;