-- audit_settings.sql
-- Reviews current audit configuration (Unified Auditing and Traditional Auditing)
-- Helps verify compliance with audit requirements

-- Check which audit type is active
SELECT
    value AS audit_trail_type
FROM
    v$parameter
WHERE
    name = 'audit_trail';

-- Check if Unified Auditing is enabled (12c+)
SELECT
    value AS unified_audit_enabled
FROM
    v$option
WHERE
    parameter = 'Unified Auditing';

-- Unified Audit Policies (12c+)
SELECT
    policy_name,
    enabled_option,
    entity_name,
    entity_type,
    success,
    failure
FROM
    audit_unified_enabled_policies
ORDER BY
    policy_name,
    entity_name;

-- Traditional Audit Settings (pre-12c or mixed mode)
-- Uncomment if using traditional auditing
/*
SELECT
    user_name,
    audit_option,
    success,
    failure
FROM
    dba_stmt_audit_opts
ORDER BY
    user_name,
    audit_option;

SELECT
    object_schema,
    object_name,
    object_type,
    alt,
    aud,
    com,
    del,
    gra,
    ind,
    ins,
    loc,
    ren,
    sel,
    upd,
    ref,
    exe,
    fbk,
    rea
FROM
    dba_obj_audit_opts
WHERE
    sel  != 'N/A'
    OR ins != 'N/A'
    OR upd != 'N/A'
    OR del != 'N/A'
    OR exe != 'N/A'
ORDER BY
    object_schema,
    object_name;
*/
