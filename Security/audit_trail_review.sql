-- audit_trail_review.sql
-- Reviews recent audit trail entries for suspicious or notable activity
-- Covers both Unified Audit Trail (12c+) and Traditional Audit Trail

-- Unified Audit Trail: recent activity (12c+)
SELECT
    event_timestamp,
    dbusername,
    os_username,
    userhost,
    client_program_name,
    action_name,
    object_schema,
    object_name,
    sql_text,
    return_code,
    unified_audit_policies
FROM
    unified_audit_trail
WHERE
    event_timestamp >= SYSDATE - 1   -- last 24 hours, adjust as needed
ORDER BY
    event_timestamp DESC
FETCH FIRST 200 ROWS ONLY;

-- Failed logins in Unified Audit Trail
SELECT
    event_timestamp,
    dbusername,
    os_username,
    userhost,
    action_name,
    return_code
FROM
    unified_audit_trail
WHERE
    action_name   = 'LOGON'
    AND return_code != 0
    AND event_timestamp >= SYSDATE - 7
ORDER BY
    event_timestamp DESC;

-- Traditional Audit Trail (fallback for non-unified)
-- Uncomment if using traditional auditing
/*
SELECT
    timestamp#        AS event_time,
    db_user,
    os_user,
    userhost,
    terminal,
    action_name,
    obj_name,
    new_name,
    returncode,
    comment$text
FROM
    sys.aud$
WHERE
    timestamp# >= SYSDATE - 1
ORDER BY
    timestamp# DESC
FETCH FIRST 200 ROWS ONLY;
*/
