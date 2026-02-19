-- default_passwords.sql
-- Identifies accounts that still use Oracle default/known passwords
-- Based on DBA_USERS_WITH_DEFPWD view (available from 11g+)
-- Critical security risk — these accounts must be remediated immediately

-- Method 1: Using built-in Oracle view (11g+)
SELECT
    u.username,
    u.account_status,
    u.profile,
    u.created,
    u.last_login,
    u.authentication_type
FROM
    dba_users_with_defpwd d
    JOIN dba_users u ON u.username = d.username
ORDER BY
    u.account_status,
    u.username;

-- Method 2: Cross-check against known Oracle default password hashes
-- (fallback for older databases or custom checks)
-- Uncomment if DBA_USERS_WITH_DEFPWD is not available
/*
SELECT
    u.username,
    u.account_status,
    u.profile,
    u.created,
    u.password      AS password_hash
FROM
    dba_users u
WHERE
    u.password IN (
        -- Common default Oracle password hashes (DES-based, pre-11g)
        'E066D214D5421CCC', -- 'oracle'
        '72979A94BAD2AF80', -- 'change_on_install'
        'D4C5016086B2DC6A', -- 'manager'
        '4A3BA55E08595C81', -- 'welcome1'
        '7A0F2B316C212D32'  -- 'password'
    )
ORDER BY
    u.username;
*/
