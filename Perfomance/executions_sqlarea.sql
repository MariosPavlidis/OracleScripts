SELECT
    inst_id,
    sql_id,
    plan_hash_value,
    executions,
    elapsed_time / 1e6 AS elapsed_sec,
    cpu_time / 1e6 AS cpu_sec,
    buffer_gets,
    disk_reads,
    rows_processed,
    parsing_schema_name,
    round(elapsed_time/executions / 1024,3) AS "elapsed_msec/exec",
     COALESCE(sql_patch, sql_profile, sql_plan_baseline, 'NONE') AS patch_profile_baseline,
    module    
FROM
    gv$sqlarea 
    where executions>0
    order by executions desc ;