SELECT owner, table_name, num_rows, last_analyzed
FROM   dba_tab_statistics
WHERE  owner = UPPER('&OWNER')
AND    table_name NOT LIKE 'BIN$%'
AND    stale_stats = 'YES'
ORDER  BY last_analyzed NULLS FIRST, owner, table_name;