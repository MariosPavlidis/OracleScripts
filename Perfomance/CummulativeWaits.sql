SELECT event, total_waits, time_waited/100 time_waited_sec, average_wait/10 avg_wait_ms
FROM v$system_event
WHERE wait_class <> 'Idle'
ORDER BY time_waited DESC FETCH FIRST 10 ROWS ONLY;