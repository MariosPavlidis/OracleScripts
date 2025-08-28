SELECT s.inst_id, s.sid, s.serial#, s.username, t.used_ublk, t.start_time, s.program, s.sql_id
FROM gv$transaction t
JOIN gv$session s ON s.inst_id=t.inst_id AND s.saddr=t.ses_addr
ORDER BY t.start_time ASC FETCH FIRST 20 ROWS ONLY;