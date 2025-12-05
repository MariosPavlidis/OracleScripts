SELECT s.begin_interval_time, s.end_interval_time,
       b.sql_id, b.child_number, b.name, b.position,
       b.datatype_string, b.value_string, b.was_captured
FROM   dba_hist_sqlbind b
JOIN   dba_hist_snapshot s
  ON   s.snap_id = b.snap_id
 AND   s.instance_number = b.instance_number
WHERE  b.sql_id = :sql_id
AND    s.begin_interval_time >= TO_TIMESTAMP(:from_ts,'YYYY-MM-DD HH24:MI:SS')
AND    s.end_interval_time   <= TO_TIMESTAMP(:to_ts,'YYYY-MM-DD HH24:MI:SS')
ORDER  BY s.begin_interval_time, position;