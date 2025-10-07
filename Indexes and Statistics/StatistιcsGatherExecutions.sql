SELECT instance_id,JOB_NAME,ACTUAL_START_DATE,RUN_DURATION,STATUS
FROM DBA_SCHEDULER_JOB_RUN_DETAILS
WHERE JOB_NAME like '%OPT%'
order by ACTUAL_START_DATE desc;


select *
from dba_autotask_job_history
where client_name='auto optimizer stats collection'
and (end_time is null or job_status<>'SUCCEEDED')
order by start_time desc;