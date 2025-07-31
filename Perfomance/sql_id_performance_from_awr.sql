SELECT
    s.sql_id,
    s.plan_hash_value,
    t.sql_text,
    TO_CHAR(sn.begin_interval_time, 'YYYY-MM-DD HH24:MI') AS begin_time,
    TO_CHAR(sn.end_interval_time, 'YYYY-MM-DD HH24:MI') AS end_time,
    s.instance_number,
    s.executions_delta,
    ROUND(s.elapsed_time_delta / 1e6, 3) AS elapsed_sec,
    ROUND(s.cpu_time_delta / 1e6, 3) AS cpu_sec,
    s.buffer_gets_delta,
    s.disk_reads_delta,
    s.rows_processed_delta
FROM
    dba_hist_sqlstat s
JOIN
    dba_hist_snapshot sn ON s.snap_id = sn.snap_id AND s.instance_number = sn.instance_number
JOIN
    dba_hist_sqltext t ON s.sql_id = t.sql_id
WHERE
    s.sql_id = :1
ORDER BY
    sn.begin_interval_time, s.instance_number;