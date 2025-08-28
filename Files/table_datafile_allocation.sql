SELECT
  e.tablespace_name,
  d.file_id,
  d.file_name,
  SUM(e.blocks)                    AS blocks,
  ROUND(SUM(e.bytes)/1024/1024,2)  AS mb,
  COUNT(*)                         AS extent_cnt,
  ROUND(100 * SUM(e.bytes)
        / SUM(SUM(e.bytes)) OVER (), 2) AS pct_of_table
FROM   dba_extents e
JOIN   dba_data_files d
       ON d.tablespace_name = e.tablespace_name
      AND d.relative_fno   = e.relative_fno
WHERE  e.owner = UPPER(:owner)
AND    e.segment_name = UPPER(:table_name)
AND    e.segment_type IN ('TABLE','TABLE PARTITION','TABLE SUBPARTITION')
GROUP  BY e.tablespace_name, d.file_id, d.file_name
ORDER  BY d.file_id;
