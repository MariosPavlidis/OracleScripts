-- sqlnet_encryption_status.sql
-- Checks SQL*Net / Oracle Net encryption and integrity settings
-- Unencrypted connections expose data in transit

-- Network encryption parameters from sqlnet.ora (surfaced via v$parameter where applicable)
SELECT
    name,
    value,
    description
FROM
    v$parameter
WHERE
    name IN (
        'sqlnet.encryption_server',
        'sqlnet.encryption_client',
        'sqlnet.encryption_types_server',
        'sqlnet.encryption_types_client',
        'sqlnet.crypto_checksum_server',
        'sqlnet.crypto_checksum_client',
        'sqlnet.crypto_checksum_types_server',
        'sqlnet.crypto_checksum_types_client'
    )
ORDER BY
    name;

-- Active session encryption info (requires v$session_connect_info)
SELECT
    s.sid,
    s.serial#,
    s.username,
    s.program,
    s.machine,
    sci.network_service_banner
FROM
    v$session              s
    JOIN v$session_connect_info sci ON sci.sid = s.sid AND sci.serial# = s.serial#
WHERE
    s.username IS NOT NULL
    AND sci.network_service_banner LIKE '%encrypt%'
ORDER BY
    s.username,
    s.sid;

-- Check for sessions WITHOUT encryption (potentially unencrypted connections)
SELECT
    s.sid,
    s.serial#,
    s.username,
    s.program,
    s.machine,
    s.logon_time
FROM
    v$session s
WHERE
    s.username IS NOT NULL
    AND s.sid NOT IN (
        SELECT DISTINCT sci.sid
        FROM v$session_connect_info sci
        WHERE sci.network_service_banner LIKE '%encrypt%'
    )
ORDER BY
    s.username;
