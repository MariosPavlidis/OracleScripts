SELECT group#, thread#, bytes/1024/1024 mb, archived, status, sequence#
FROM v$log ORDER BY thread#, group#;