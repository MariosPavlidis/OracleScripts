---ON PRIMARY
SELECT thread#,
       MAX(sequence#) AS last_archived
FROM gv$archived_log
WHERE archived = 'YES'
  AND resetlogs_change# = (
      SELECT resetlogs_change#
      FROM v$database
  )
GROUP BY thread#
ORDER BY thread#;


--ON STANDBY
SELECT thread#,
       MAX(sequence#) AS last_received,
       MAX(
           CASE
               WHEN applied = 'YES' THEN sequence#
           END
       ) AS last_applied
FROM gv$archived_log
WHERE resetlogs_change# = (
    SELECT resetlogs_change#
    FROM v$database
)
GROUP BY thread#
ORDER BY thread#;