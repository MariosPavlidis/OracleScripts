SELECT group#, thread#, bytes/1024/1024 mb, archived, status, sequence#
FROM v$log ORDER BY thread#, group#;

select event, total_waits, time_waited/100 time_s from v$system_event where event in ('log file sync','log file switch completion');

select value from v$sysstat where name='redo size';