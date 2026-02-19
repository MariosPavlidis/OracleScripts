-- dbvault_status.sql
-- Checks if Oracle Database Vault is installed and enabled
-- DB Vault prevents privileged users (including DBAs) from accessing application data

-- Check if DB Vault option is installed
SELECT
    parameter,
    value AS status
FROM
    v$option
WHERE
    parameter IN ('Oracle Database Vault', 'Oracle Label Security');

-- Check DB Vault enable status (requires DVSYS or DV_MONITOR role)
SELECT
    name,
    status
FROM
    dba_dv_status;

-- DB Vault Realms defined
SELECT
    name,
    description,
    enabled,
    audit_options
FROM
    dvsys.dba_dv_realm
ORDER BY
    name;

-- DB Vault Command Rules
SELECT
    command,
    rule_set_name,
    enabled,
    object_owner,
    object_name
FROM
    dvsys.dba_dv_command_rule
ORDER BY
    command,
    object_owner,
    object_name;
