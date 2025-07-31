SELECT local_tran_id, global_tran_id, state, mixed, host, commit#
FROM dba_2pc_pending;


/*
select 'ROLLBACK FORCE '''||local_tran_id||''';'  from dba_2pc_pending;
select 'COMMIT   FORCE '''||local_tran_id||''';'  from dba_2pc_pending;
select 
'execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('''||local_tran_id||''');'
from dba_2pc_pending;
*/