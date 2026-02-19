-- user_profiles.sql
-- Shows which profile each user is assigned to
-- Highlights users on DEFAULT profile (often too permissive)

SELECT
    u.username,
    u.profile,
    u.account_status,
    u.created,
    u.last_login,
    u.authentication_type,
    u.oracle_maintained,
    CASE
        WHEN u.profile = 'DEFAULT' THEN 'WARNING: Using DEFAULT profile'
        ELSE 'OK'
    END AS profile_check
FROM
    dba_users u
ORDER BY
    u.profile,
    u.username;
