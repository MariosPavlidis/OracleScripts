SELECT ts.tablespace_name,
       ROUND(ts.free_space  / 1024 / 1024)            AS free_mb,
       ROUND(ts.total_space / 1024 / 1024)            AS total_mb,
       ROUND((ts.free_space / ts.total_space) * 100, 2) AS pct_free,
       ROUND(tf.max_space   / 1024 / 1024)            AS max_mb,
       ROUND((tf.max_space - (ts.total_space - ts.free_space)) / 1024 / 1024)
                                                      AS max_free_mb,
       ROUND(((tf.max_space - (ts.total_space - ts.free_space)) / tf.max_space) * 100, 2)
                                                      AS pct_max_free
FROM (
       SELECT tablespace_name,
              SUM(free_space)      AS free_space,
              SUM(tablespace_size) AS total_space
       FROM   dba_temp_free_space
       GROUP  BY tablespace_name
     ) ts
JOIN (
       SELECT tablespace_name,
              SUM(CASE WHEN autoextensible = 'YES'
                       THEN GREATEST(maxbytes, bytes)
                       ELSE bytes
                  END) AS max_space
       FROM   dba_temp_files
       GROUP  BY tablespace_name
     ) tf
  ON tf.tablespace_name = ts.tablespace_name
ORDER  BY ts.tablespace_name;