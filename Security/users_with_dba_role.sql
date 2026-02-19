-- users_with_dba_role.sql
-- Identifies users with DBA or other highly privileged roles
-- Critical for security reviews and compliance audits

SELECT
    u.username,
    u.account_status,
    u.profile,
    u.created,
    u.last_login,
    rp.granted_role,
    rp.admin_option,
    rp.default_role
FROM
    dba_users       u
    JOIN dba_role_privs rp ON rp.grantee = u.username
WHERE
    rp.granted_role IN (
        'DBA', 'SYSDBA', 'SYSOPER', 'SYSBACKUP', 'SYSDG', 'SYSKM',
        'SYSRAC', 'IMP_FULL_DATABASE', 'EXP_FULL_DATABASE',
        'DATAPUMP_IMP_FULL_DATABASE', 'DATAPUMP_EXP_FULL_DATABASE',
        'SELECT_CATALOG_ROLE', 'EXECUTE_CATALOG_ROLE', 'DELETE_CATALOG_ROLE',
        'AQ_ADMINISTRATOR_ROLE', 'SCHEDULER_ADMIN', 'JAVA_ADMIN',
        'HS_ADMIN_ROLE', 'AUDIT_ADMIN', 'AUDIT_VIEWER'
    )
ORDER BY
    rp.granted_role,
    u.username;
