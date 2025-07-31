
--ACTIVE: Status show us the active transaction going in database, utilizing the undo tablespace and cannot be truncated.
--EXPIRED: Status show us the transaction which is completed and complete the undo_retention time and now first candidate for trucated from undo tablespace.
--UNEXPIRED: Status show us the transaction which is completed but not completed the undo retention time. It can be trucated if required.
select tablespace_name tablespace, status, sum(bytes)/1024/1024 sum_in_mb, count(*) counts
from dba_undo_extents
group by tablespace_name, status order by 1,2;

