select sql.sql_text sql_text, t.USED_UREC Records,
     t.USED_UBLK Blocks,
     (t.USED_UBLK*8192/1024) KBytes from v$transaction t,
     v$session s,
     v$sql sql
     where t.addr = s.taddr
     and s.sql_id = sql.sql_id;