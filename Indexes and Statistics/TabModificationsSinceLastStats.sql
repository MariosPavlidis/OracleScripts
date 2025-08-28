-- Uses dba_tab_modifications to quantify churn after last stats
WITH m AS (
  SELECT table_owner owner, table_name,
         NVL(inserts,0)+NVL(updates,0)+NVL(deletes,0) AS dml_since_analyze,
         timestamp AS last_mod_ts
  FROM   dba_tab_modifications
)
SELECT t.owner, t.table_name, t.num_rows,
       t.last_analyzed, m.dml_since_analyze, m.last_mod_ts
FROM   dba_tab_statistics t
LEFT JOIN m
  ON m.owner = t.owner AND m.table_name = t.table_name
WHERE  t.owner = UPPER('&OWNER')
AND    NVL(m.dml_since_analyze,0) > NVL(t.num_rows,0) * NVL(&DML_RATIO,0.10)  -- e.g. 0.10
ORDER  BY m.dml_since_analyze DESC NULLS LAST;