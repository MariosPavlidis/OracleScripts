SELECT dest_id,
       destination,
       target,
       status,
       error,
       transmit_mode,
       affirm,
       synchronization_status,
       synchronized,
       recovery_mode,
       archived_thread#,
       archived_seq#
FROM v$archive_dest_status
WHERE status <> 'INACTIVE'
ORDER BY dest_id;

SELECT dest_id,
       status,
       destination,
       error
FROM v$archive_dest
WHERE target = 'STANDBY'
ORDER BY dest_id;