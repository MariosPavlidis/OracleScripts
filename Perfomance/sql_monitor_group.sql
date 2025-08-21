   select sql_id,count(*) executions,round(sum(elapsed_time)/1e6,3) total_time_s,round(min(elapsed_time)/1000,3) min_ms,round(max(elapsed_time)/1000,3) max_ms,round(avg(elapsed_time)/1000,3) avg_ms,max(sql_exec_start),sql_text
    from gv$sql_monitor
    where sql_exec_start>sysdate-6/24
    group by sql_id,sql_text
    order by 2 desc;