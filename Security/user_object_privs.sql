-- user_object_privs.sql
-- Lists object-level privileges granted directly to users (not via roles)
-- Helps identify who has access to sensitive objects

SELECT
    grantee,
    owner,
    table_name       AS object_name,
    privilege,
    grantable,
    hierarchy,
    common,
    inherited
FROM
    dba_tab_privs
WHERE
    grantee NOT IN (
        SELECT role FROM dba_roles
    )
    AND grantee NOT IN ('SYS', 'SYSTEM', 'PUBLIC', 'OUTLN', 'XDB', 'DBSNMP',
                        'APPQOSSYS', 'ORACLE_OCM', 'DIP', 'WMSYS', 'OJVMSYS',
                        'CTXSYS', 'MDSYS', 'ORDSYS', 'ORDDATA', 'ORDPLUGINS',
                        'SI_INFORMTN_SCHEMA', 'OLAPSYS', 'MDDATA', 'ANONYMOUS',
                        'GSMADMIN_INTERNAL', 'LBACSYS', 'DVSYS', 'DVF', 'AUDSYS')
ORDER BY
    grantee,
    owner,
    table_name,
    privilege;
