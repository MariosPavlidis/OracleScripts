-- public_grants.sql
-- Lists all object privileges granted to PUBLIC
-- PUBLIC grants are accessible by every database user — a significant security risk

-- Object privileges granted to PUBLIC
SELECT
    owner,
    table_name      AS object_name,
    grantor,
    privilege,
    grantable,
    hierarchy
FROM
    dba_tab_privs
WHERE
    grantee = 'PUBLIC'
    AND owner NOT IN ('SYS', 'SYSTEM', 'PUBLIC', 'XDB', 'DBSNMP', 'APPQOSSYS',
                      'ORACLE_OCM', 'DIP', 'WMSYS', 'OJVMSYS', 'CTXSYS',
                      'MDSYS', 'ORDSYS', 'ORDDATA', 'ORDPLUGINS',
                      'SI_INFORMTN_SCHEMA', 'OLAPSYS', 'MDDATA', 'ANONYMOUS',
                      'LBACSYS', 'DVSYS', 'DVF', 'AUDSYS', 'GSMADMIN_INTERNAL',
                      'FLOWS_FILES', 'OUTLN')
ORDER BY
    owner,
    table_name,
    privilege;

-- Column-level privileges granted to PUBLIC
SELECT
    owner,
    table_name      AS object_name,
    column_name,
    grantor,
    privilege,
    grantable
FROM
    dba_col_privs
WHERE
    grantee = 'PUBLIC'
ORDER BY
    owner,
    table_name,
    column_name,
    privilege;

-- Summary of PUBLIC grants by owner
SELECT
    owner,
    COUNT(*) AS grant_count
FROM
    dba_tab_privs
WHERE
    grantee = 'PUBLIC'
GROUP BY
    owner
ORDER BY
    grant_count DESC;
