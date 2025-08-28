SELECT tablespace_name,
       ROUND(free_space / 1024 / 1024) AS free_mb,
       ROUND(total_space / 1024 / 1024) AS total_mb,
       ROUND((free_space / total_space) * 100, 2) AS pct_free
FROM (
  SELECT tablespace_name,
         SUM(free_space) free_space,
         SUM(tablespace_size) total_space
  FROM (
    SELECT tablespace_name,
           free_space,
           tablespace_size
    FROM   dba_temp_free_space
  )
  GROUP BY tablespace_name
);