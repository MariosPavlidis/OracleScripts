-- dba_roles_granted.sql
-- Shows all roles granted to users and to other roles (role hierarchy)
-- Helps map the full privilege chain

-- Roles granted to users
SELECT
    'USER'          AS grantee_type,
    granted_role,
    grantee,
    admin_option,
    default_role,
    common,
    inherited
FROM
    dba_role_privs
WHERE
    grantee NOT IN (SELECT role FROM dba_roles)
UNION ALL
-- Roles granted to other roles
SELECT
    'ROLE'          AS grantee_type,
    granted_role,
    grantee,
    admin_option,
    default_role,
    common,
    inherited
FROM
    dba_role_privs
WHERE
    grantee IN (SELECT role FROM dba_roles)
ORDER BY
    grantee_type,
    grantee,
    granted_role;
