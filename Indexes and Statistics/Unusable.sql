select owner, index_name, table_owner, table_name, partitioned, status
from dba_indexes
where status = 'UNUSABLE'
  and owner not in ('SYS','SYSTEM')
order by owner, index_name;


select index_owner, index_name, partition_name, subpartition_name, status
from dba_ind_subpartitions
where status = 'UNUSABLE'
  and index_owner not in ('SYS','SYSTEM')
order by index_owner, index_name, partition_name, subpartition_name;
