with curr as (select count(*) n from dba_data_files),
lim as ( select value v from v$parameter where name = 'db_files')
select 'There are '||n||' files out of the '|| v||' set as limit in the database.'
from curr,lim