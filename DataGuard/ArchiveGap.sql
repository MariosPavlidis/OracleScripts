--ON STANDBY
SELECT thread#,
       low_sequence#,
       high_sequence#
FROM v$archive_gap;