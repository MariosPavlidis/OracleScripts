SELECT inst_id, instance_name, status, database_status, host_name host, to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') now
FROM gv$instance;