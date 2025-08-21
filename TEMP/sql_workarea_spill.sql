-- Active operators spilling to TEMP right now
SELECT s.inst_id, s.sid, s.serial#, s.username,
       w.operation_type,
       ROUND(w.actual_mem_used/1024/1024,1) AS mb_mem,
       ROUND(w.tempseg_size/1024/1024,1)    AS mb_temp,
       w.number_passes,
       s.sql_id,
       SUBSTR(q.sql_text,1,120)             AS sql_text
FROM   gv$sql_workarea_active w
JOIN   gv$session s ON s.sid=w.sid AND s.inst_id=w.inst_id
LEFT   JOIN gv$sql q ON q.sql_id=s.sql_id AND q.inst_id=s.inst_id
ORDER  BY mb_temp DESC