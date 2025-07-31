SELECT *
FROM (
    SELECT
        ash.session_id,
        ash.session_serial#,
        COUNT(*) AS sample_count,
        ROUND(SUM(ash.pga_allocated) / 1024 / 1024, 2) AS total_pga_mb,
        MIN(ash.program) AS program,
        MIN(ash.module) AS module
    FROM
        dba_hist_active_sess_history ash
    WHERE
        ash.sample_time > SYSDATE - 1
        AND ash.pga_allocated IS NOT NULL
    GROUP BY
        ash.session_id, ash.session_serial#
    ORDER BY
        total_pga_mb DESC
)
WHERE ROWNUM <= 20;