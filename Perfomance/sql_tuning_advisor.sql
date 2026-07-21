DECLARE

v_sqlid varchar2(20) :='<SQL ID>';
l_sql_tune_task_id VARCHAR2(100);
BEGIN
l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
sql_id => v_sqlid ,
scope => DBMS_SQLTUNE.scope_comprehensive,
time_limit => 120,
task_name => v_sqlid,
description => 'Tuning task for statement '||v_sqlid);
DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/

EXEC DBMS_SQLTUNE.execute_tuning_task(task_name => '<SQL ID>');

select dbms_sqltune.report_tuning_task(v_sqlid) from dual;

EXEC DBMS_SQLTUNE.DROP_TUNING_TASK(task_name => '<SQL ID>');