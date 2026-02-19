-- public_synonyms_risk.sql
-- Identifies public synonyms pointing to sensitive or privileged objects
-- Attackers can exploit public synonyms for privilege escalation

SELECT
    s.synonym_name,
    s.table_owner       AS points_to_owner,
    s.table_name        AS points_to_object,
    s.db_link,
    o.object_type,
    o.status
FROM
    dba_synonyms   s
    LEFT JOIN dba_objects o ON o.owner = s.table_owner AND o.object_name = s.table_name
WHERE
    s.owner = 'PUBLIC'
    AND s.table_owner NOT IN ('SYS', 'SYSTEM', 'PUBLIC', 'OUTLN', 'XDB',
                               'DBSNMP', 'APPQOSSYS', 'ORACLE_OCM', 'DIP',
                               'WMSYS', 'OJVMSYS', 'CTXSYS', 'MDSYS', 'ORDSYS',
                               'ORDDATA', 'ORDPLUGINS', 'SI_INFORMTN_SCHEMA',
                               'OLAPSYS', 'MDDATA', 'ANONYMOUS', 'LBACSYS',
                               'DVSYS', 'DVF', 'AUDSYS', 'GSMADMIN_INTERNAL',
                               'APEX_040200', 'APEX_050000', 'APEX_180200',
                               'FLOWS_FILES')
ORDER BY
    s.table_owner,
    s.table_name;

-- Count of all public synonyms by target owner (for overview)
SELECT
    table_owner,
    COUNT(*) AS synonym_count
FROM
    dba_synonyms
WHERE
    owner = 'PUBLIC'
GROUP BY
    table_owner
ORDER BY
    synonym_count DESC;
