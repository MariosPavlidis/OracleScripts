SELECT u.inst_id, s.sid, s.serial#, s.username, s.machine, s.module, s.s.osuser,
       u.sql_id, u.segtype,
       ROUND(u.blocks * ts.block_size/1024/1024, 1) AS mb
FROM   gv$tempseg_usage u
JOIN   gv$session s
       ON s.saddr = u.session_addr AND s.inst_id = u.inst_id
JOIN   dba_tablespaces ts ON ts.tablespace_name = u.tablespace
ORDER  BY mb DESC
FETCH FIRST 20 ROWS ONLY;