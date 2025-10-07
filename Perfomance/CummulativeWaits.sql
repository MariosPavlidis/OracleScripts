--shows all wait events since last restart
SELECT event, total_waits, time_waited/100 time_waited_sec, average_wait/10 avg_wait_ms
FROM v$system_event
WHERE wait_class <> 'Idle'
ORDER BY time_waited DESC FETCH FIRST 10 ROWS ONLY;

select wait_class, round(100*sum(time_waited)/sum(sum(time_waited)) over(),1) pct 
from v$system_wait_class where wait_class<>'Idle' 
group by wait_class order by pct desc;