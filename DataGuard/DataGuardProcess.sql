SELECT process,
       status,
       thread#,
       sequence#,
       block#,
       blocks
FROM v$managed_standby
ORDER BY process, thread#;

/*
SELECT process,
       status,
       thread#,
       sequence#,
       block#,
       blocks
FROM v$managed_standby
ORDER BY process, thread#;
*/