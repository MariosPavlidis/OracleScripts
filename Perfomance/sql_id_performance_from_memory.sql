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
     COALESCE(sql_patch, sql_profile, sql_plan_baseline, 'NONE') AS patch_profile_baseline,
    module    
FROM
    gv$sqlarea
WHERE
    sql_id =:1;