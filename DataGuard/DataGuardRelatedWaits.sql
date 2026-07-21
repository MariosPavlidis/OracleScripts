SELECT event,
       total_waits,
       ROUND(time_waited_micro / 1000000, 2) AS waited_seconds,
       ROUND(
           time_waited_micro /
           NULLIF(total_waits, 0) / 1000,
           2
       ) AS avg_wait_ms
FROM v$system_event
WHERE event LIKE 'LGWR%'
   OR event LIKE 'LNS%'
   OR event LIKE 'SYNC%'
   OR event LIKE 'ASYNC%'
   OR event LIKE 'redo%'
ORDER BY time_waited_micro DESC;