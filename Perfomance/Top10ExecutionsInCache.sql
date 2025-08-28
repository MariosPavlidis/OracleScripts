SELECT sql_id, plan_hash_value, elapsed_time/1000000 elapsed_sec, executions,
       ROUND(elapsed_time/DECODE(executions,0,1,executions)/1000000,3) avg_sec,
       sql_text
FROM v$sql
WHERE elapsed_time > 0
ORDER BY elapsed_time DESC FETCH FIRST 10 ROWS ONLY;