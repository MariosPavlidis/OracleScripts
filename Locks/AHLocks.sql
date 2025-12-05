-- Find blockers and waiters from ASH history for a specific time window
-- Replace the time window with your period of interest
WITH ash_waiters AS (
    SELECT
        sample_time,
        session_id,
        session_serial#,
        sql_id,
        event,
        blocking_session,
        blocking_session_serial#
    FROM
        dba_hist_active_sess_history
    WHERE
        event LIKE 'enq: TX - %' -- Focus on transaction locks
        AND sample_time BETWEEN systimestamp-1
                            AND systimestamp
),
ash_blockers AS (
    SELECT
        sample_time,
        session_id,
        session_serial#,
        sql_id,
        program
    FROM
        dba_hist_active_sess_history
    WHERE
        -- The blocker might be on CPU or doing other work
        sample_time BETWEEN systimestamp-1
                            AND systimestamp
)
SELECT
    w.sample_time,
    w.session_id AS waiter_sid,
    w.sql_id AS waiter_sql,
    w.event AS wait_event,
    w.blocking_session AS blocker_sid,
    b.sql_id AS blocker_sql,
    b.program AS blocker_program
FROM
    ash_waiters w
LEFT JOIN
    ash_blockers b ON w.blocking_session = b.session_id
                  AND w.blocking_session_serial# = b.session_serial#
                  -- Match the blocker's activity at roughly the same time the waiter was sampled
                  AND b.sample_time BETWEEN w.sample_time - INTERVAL '2' SECOND AND w.sample_time + INTERVAL '2' SECOND
WHERE
    w.blocking_session IS NOT NULL
ORDER BY
    w.sample_time;