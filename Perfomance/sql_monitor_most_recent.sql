     SELECT *
     FROM
       (SELECT inst_id,sid||','||session_serial#,program,
         username,
         sql_id,
         status,
         sql_exec_id,
         TO_CHAR(sql_exec_start,'dd-mon-yyyy hh24:mi:ss') AS sql_exec_start,
         ROUND(elapsed_time/1e6)                      AS "Elapsed (s)",
         ROUND(cpu_time    /1e6)                      AS "CPU (s)",
         buffer_gets,
         ROUND(physical_read_bytes /(1024*1024)) AS "Phys reads (MB)",
         ROUND(physical_write_bytes/(1024*1024)) AS "Phys writes (MB)",
         sql_text,binds_xml         
       FROM gv$sql_monitor
       ORDER BY last_refresh_time DESC
       )
     WHERE rownum<=20;
    