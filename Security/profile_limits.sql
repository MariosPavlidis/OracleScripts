-- profile_limits.sql
-- Shows password and resource limits for all profiles
-- Key for validating CIS/STIG compliance on password policies

SELECT
    profile,
    resource_name,
    resource_type,
    limit
FROM
    dba_profiles
WHERE
    resource_name IN (
        'PASSWORD_LIFE_TIME',
        'PASSWORD_REUSE_TIME',
        'PASSWORD_REUSE_MAX',
        'PASSWORD_VERIFY_FUNCTION',
        'PASSWORD_LOCK_TIME',
        'PASSWORD_GRACE_TIME',
        'FAILED_LOGIN_ATTEMPTS',
        'SESSIONS_PER_USER',
        'IDLE_TIME',
        'CONNECT_TIME',
        'PASSWORD_ROLLOVER_TIME'
    )
ORDER BY
    profile,
    resource_type,
    resource_name;
