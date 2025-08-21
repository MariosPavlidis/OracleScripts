SELECT ash.inst_id,
       TO_CHAR(TRUNC(ash.sample_time,'mi'),'YYYY-MM-DD HH24:MI') AS minute,
       ash.sql_id,
       ash.session_id AS sid,
       ash.session_serial# AS serial#,
       ROUND(SUM(ash.temp_space_allocated)/1024/1024,1)         AS mb_temp_alloc
FROM   gv$active_session_history ash
WHERE  ash.sample_time >= SYSTIMESTAMP - INTERVAL '60' MINUTE
GROUP  BY ash.inst_id, TRUNC(ash.sample_time,'mi'),
          ash.sql_id, ash.session_id, ash.session_serial#
ORDER  BY mb_temp_alloc DESC nulls last
FETCH FIRST 50 ROWS ONLY;