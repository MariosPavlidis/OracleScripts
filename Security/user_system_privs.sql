-- user_system_privs.sql
-- Lists all system privileges granted directly to users (not via roles)
-- Useful for identifying over-privileged accounts

SELECT
    grantee,
    privilege,
    admin_option,
    common,
    inherited
FROM
    dba_sys_privs
WHERE
    grantee NOT IN (
        SELECT role FROM dba_roles
    )
    AND grantee NOT IN ('SYS', 'SYSTEM', 'OUTLN', 'XDB', 'DBSNMP', 'APPQOSSYS',
                        'ORACLE_OCM', 'DIP', 'WMSYS', 'OJVMSYS', 'CTXSYS',
                        'MDSYS', 'ORDSYS', 'ORDDATA', 'ORDPLUGINS', 'SI_INFORMTN_SCHEMA',
                        'OLAPSYS', 'MDDATA', 'ANONYMOUS', 'GSMADMIN_INTERNAL',
                        'GSMCATUSER', 'GSMUSER', 'LBACSYS', 'DVSYS', 'DVF',
                        'AUDSYS', 'APEX_PUBLIC_USER', 'FLOWS_FILES')
ORDER BY
    grantee,
    privilege;
