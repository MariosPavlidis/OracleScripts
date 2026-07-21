-- Requires AWR / Diagnostics Pack
-- Shows SQL executed today where today's plan is worse than plans seen on previous days

set lines 220 pages 200 trimspool on verify off
col sql_id format a13
col sql_text format a80 word_wrapped
col today_plan format 9999999999
col prev_best_plan format 9999999999
col today_execs format 999,999,999
col today_avg_ms format 999,999,990.99
col prev_best_avg_ms format 999,999,990.99
col slowdown_x format 999,990.99

with hist as (
    select
        s.begin_interval_time,
        trunc(s.begin_interval_time) as snap_day,
        st.dbid,
        st.instance_number,
        st.sql_id,
        st.plan_hash_value,
        sum(st.executions_delta)                      as execs,
        sum(st.elapsed_time_delta) / 1000            as elapsed_ms,   -- microseconds -> ms
        sum(st.cpu_time_delta) / 1000                as cpu_ms,
        sum(st.buffer_gets_delta)                    as buffer_gets,
        sum(st.disk_reads_delta)                     as disk_reads,
        sum(st.rows_processed_delta)                 as rows_processed
    from dba_hist_sqlstat st
    join dba_hist_snapshot s
      on s.snap_id          = st.snap_id
     and s.dbid             = st.dbid
     and s.instance_number  = st.instance_number
    where st.executions_delta > 0
      and s.begin_interval_time >= trunc(sysdate) - 14
    group by
        s.begin_interval_time,
        trunc(s.begin_interval_time),
        st.dbid,
        st.instance_number,
        st.sql_id,
        st.plan_hash_value
),
per_day as (
    select
        snap_day,
        sql_id,
        plan_hash_value,
        sum(execs) as execs,
        sum(elapsed_ms) as elapsed_ms,
        case
            when sum(execs) > 0 then sum(elapsed_ms) / sum(execs)
        end as avg_ms_per_exec
    from hist
    group by
        snap_day,
        sql_id,
        plan_hash_value
),
today_plans as (
    select
        sql_id,
        plan_hash_value,
        sum(execs) as today_execs,
        sum(elapsed_ms) as today_elapsed_ms,
        case
            when sum(execs) > 0 then sum(elapsed_ms) / sum(execs)
        end as today_avg_ms
    from per_day
    where snap_day = trunc(sysdate)
    group by
        sql_id,
        plan_hash_value
),
prev_plans as (
    select
        sql_id,
        plan_hash_value,
        sum(execs) as prev_execs,
        sum(elapsed_ms) as prev_elapsed_ms,
        case
            when sum(execs) > 0 then sum(elapsed_ms) / sum(execs)
        end as prev_avg_ms
    from per_day
    where snap_day < trunc(sysdate)
    group by
        sql_id,
        plan_hash_value
),
prev_best as (
    select *
    from (
        select
            p.*,
            row_number() over (
                partition by p.sql_id
                order by p.prev_avg_ms nulls last, p.prev_execs desc
            ) as rn
        from prev_plans p
        where p.prev_execs > 0
    )
    where rn = 1
)
select
    t.sql_id,
    t.plan_hash_value as today_plan,
    b.plan_hash_value as prev_best_plan,
    t.today_execs,
    round(t.today_avg_ms, 2) as today_avg_ms,
    round(b.prev_avg_ms, 2) as prev_best_avg_ms,
    round(t.today_avg_ms / nullif(b.prev_avg_ms, 0), 2) as slowdown_x,
    substr(x.sql_text, 1, 80) as sql_text
from today_plans t
join prev_best b
  on b.sql_id = t.sql_id
left join dba_hist_sqltext x
  on x.sql_id = t.sql_id
where t.plan_hash_value <> b.plan_hash_value
  and t.today_execs >= 3
  and b.prev_execs >= 3
  and t.today_avg_ms > b.prev_avg_ms * 1.5
order by slowdown_x desc nulls last, t.today_elapsed_ms desc;