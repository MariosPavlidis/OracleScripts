SELECT   ''''||s.sid||','||s.serial#||',@'||s.inst_id||'''' sid,
    s.status,
    s.sql_id,
    s.event AS current_wait,
    s.wait_time,
    s.seconds_in_wait,
    s.sql_child_number,
    s.sql_exec_start,
    ROUND((SYSDATE - s.sql_exec_start) * 86400) AS elapsed_seconds,
    s.username,
    s.osuser,
    s.machine,
    s.program,    
    q.plan_hash_value,
    COALESCE(q.sql_patch, q.sql_profile, q.sql_plan_baseline, 'NONE') AS patch_profile_baseline,
    q.sql_fulltext
FROM
    gv$session s
JOIN
    gv$sql q ON s.sql_id = q.sql_id AND s.sql_child_number = q.child_number
WHERE
    s.status = 'ACTIVE'
    AND s.username IS NOT NULL
    AND s.sql_id IS NOT NULL
ORDER BY
    elapsed_seconds DESC;