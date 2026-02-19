-- role_privs.sql
-- Lists all privileges (system and object) granted to roles
-- Useful for understanding what each role actually provides

-- System privileges granted to roles
SELECT
    'SYSTEM PRIVILEGE' AS priv_type,
    rp.role,
    rp.privilege       AS privilege_or_object,
    NULL               AS owner,
    rp.admin_option    AS grantable,
    NULL               AS object_type
FROM
    dba_sys_privs rp
WHERE
    rp.grantee IN (SELECT role FROM dba_roles)
UNION ALL
-- Object privileges granted to roles
SELECT
    'OBJECT PRIVILEGE'          AS priv_type,
    tp.grantee                  AS role,
    tp.privilege                AS privilege_or_object,
    tp.owner,
    tp.grantable,
    o.object_type
FROM
    dba_tab_privs  tp
    JOIN dba_objects o ON o.object_name = tp.table_name AND o.owner = tp.owner
WHERE
    tp.grantee IN (SELECT role FROM dba_roles)
ORDER BY
    role,
    priv_type,
    privilege_or_object;
