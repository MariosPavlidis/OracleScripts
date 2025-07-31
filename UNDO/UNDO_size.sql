SELECT 
  a.tablespace_name,
  ROUND(a.bytes/1024/1024, 2) AS total_mb,
  ROUND(b.bytes/1024/1024, 2) AS free_mb,
  ROUND((a.bytes - b.bytes)/a.bytes * 100, 2) AS pct_used
FROM 
  (SELECT tablespace_name, SUM(bytes) bytes FROM dba_data_files GROUP BY tablespace_name) a,
  (SELECT tablespace_name, SUM(bytes) bytes FROM dba_free_space GROUP BY tablespace_name) b
WHERE 
  a.tablespace_name = b.tablespace_name
  AND a.tablespace_name = (SELECT value FROM v$parameter WHERE name = 'undo_tablespace');