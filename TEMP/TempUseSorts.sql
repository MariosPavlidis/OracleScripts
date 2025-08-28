SELECT s.inst_id, s.sid, s.serial#, s.username, s.program,
       ROUND(SUM(u.blocks)*t.block_size/1024/1024) mb_used
FROM gv$sort_usage u
JOIN dba_tablespaces t ON t.tablespace_name = u.tablespace
JOIN gv$session s ON s.inst_id=u.inst_id AND s.saddr = u.session_addr
GROUP BY s.inst_id, s.sid, s.serial#, s.username, s.program,block_size
ORDER BY mb_used DESC FETCH FIRST 20 ROWS ONLY;