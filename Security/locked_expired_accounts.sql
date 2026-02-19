-- locked_expired_accounts.sql
-- Lists all user accounts by status: locked, expired, or both
-- Helps identify stale accounts that should be removed or reviewed

SELECT
    username,
    account_status,
    profile,
    created,
    lock_date,
    expiry_date,
    last_login,
    authentication_type,
    common,
    oracle_maintained
FROM
    dba_users
WHERE
    account_status != 'OPEN'
ORDER BY
    account_status,
    username;

-- Summary by status
SELECT
    account_status,
    COUNT(*) AS user_count
FROM
    dba_users
GROUP BY
    account_status
ORDER BY
    account_status;
