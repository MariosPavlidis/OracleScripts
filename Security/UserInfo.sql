/*
    Oracle Database 19c user security inventory

    Output:
      - One row per database user
      - Account and authentication status
      - Default-password detection
      - Password versions and password age
      - Direct system privileges
      - Direct roles
      - Direct object privileges
      - Direct column-level privileges
      - Assigned profile

    Notes:
      - Privileges are direct grants only.
      - Privileges inherited through roles are not expanded.
      - PUBLIC privileges are not included.
      - Aggregated privilege columns are CLOBs to avoid LISTAGG limits.
*/


WITH
    default_password_users
    AS
        (SELECT DISTINCT username
           FROM dba_users_with_defpwd),
    system_privileges
    AS
        (  SELECT grantee,
                  RTRIM (
                      XMLAGG (XMLELEMENT (
                                  e,
                                     privilege
                                  || CASE
                                         WHEN admin_option = 'YES'
                                         THEN
                                             ' [ADMIN OPTION]'
                                     END
                                  || ' | ')
                              ORDER BY privilege).EXTRACT ('//text()').GETCLOBVAL (),
                      ' |')    AS system_privileges
             FROM (SELECT DISTINCT grantee, privilege, admin_option
                     FROM dba_sys_privs)
         GROUP BY grantee),
    role_privileges
    AS
        (  SELECT grantee,
                  RTRIM (
                      XMLAGG (XMLELEMENT (
                                  e,
                                     granted_role
                                  || CASE
                                         WHEN admin_option = 'YES'
                                         THEN
                                             ' [ADMIN OPTION]'
                                     END
                                  || CASE
                                         WHEN delegate_option = 'YES'
                                         THEN
                                             ' [DELEGATE OPTION]'
                                     END
                                  || CASE
                                         WHEN default_role = 'NO'
                                         THEN
                                             ' [NOT DEFAULT]'
                                     END
                                  || ' | ')
                              ORDER BY granted_role).EXTRACT ('//text()').GETCLOBVAL (),
                      ' |')    AS granted_roles
             FROM (SELECT DISTINCT grantee,
                                   granted_role,
                                   admin_option,
                                   delegate_option,
                                   default_role
                     FROM dba_role_privs)
         GROUP BY grantee),
    object_privileges
    AS
        (  SELECT grantee,
                  RTRIM (
                      XMLAGG (XMLELEMENT (
                                  e,
                                     owner
                                  || '.'
                                  || table_name
                                  || ' ['
                                  || TYPE
                                  || '] : '
                                  || privilege
                                  || CASE
                                         WHEN grantable = 'YES'
                                         THEN
                                             ' [GRANT OPTION]'
                                     END
                                  || CASE
                                         WHEN hierarchy = 'YES'
                                         THEN
                                             ' [HIERARCHY]'
                                     END
                                  || CASE
                                         WHEN common = 'YES' THEN ' [COMMON]'
                                     END
                                  || CASE
                                         WHEN inherited = 'YES'
                                         THEN
                                             ' [INHERITED]'
                                     END
                                  || ' | ')
                              ORDER BY owner, table_name, privilege).EXTRACT (
                          '//text()').GETCLOBVAL (),
                      ' |')    AS object_privileges
             FROM (SELECT DISTINCT grantee,
                                   owner,
                                   table_name,
                                   TYPE,
                                   privilege,
                                   grantable,
                                   hierarchy,
                                   common,
                                   inherited
                     FROM dba_tab_privs)
         GROUP BY grantee),
    column_privileges
    AS
        (  SELECT grantee,
                  RTRIM (
                      XMLAGG (XMLELEMENT (
                                  e,
                                     owner
                                  || '.'
                                  || table_name
                                  || '.'
                                  || column_name
                                  || ' : '
                                  || privilege
                                  || CASE
                                         WHEN grantable = 'YES'
                                         THEN
                                             ' [GRANT OPTION]'
                                     END
                                  || CASE
                                         WHEN common = 'YES' THEN ' [COMMON]'
                                     END
                                  || CASE
                                         WHEN inherited = 'YES'
                                         THEN
                                             ' [INHERITED]'
                                     END
                                  || ' | ')
                              ORDER BY
                      owner,
                      table_name,
                      column_name,
                      privilege).EXTRACT ('//text()').GETCLOBVAL (),
                      ' |')    AS column_privileges
             FROM (SELECT DISTINCT grantee,
                                   owner,
                                   table_name,
                                   column_name,
                                   privilege,
                                   grantable,
                                   common,
                                   inherited
                     FROM dba_col_privs)
         GROUP BY grantee)
  SELECT u.username,
         u.user_id,
         u.account_status,
         CASE WHEN dp.username IS NOT NULL THEN 'YES' ELSE 'NO' END
             AS uses_default_password,
         u.authentication_type,
         NVL (u.password_versions, 'NONE')
             AS password_versions,
         CASE
             WHEN INSTR (NVL (u.password_versions, ' '), '10G') > 0 THEN 'YES'
             ELSE 'NO'
         END
             AS has_legacy_10g_password,
         CASE
             WHEN     u.authentication_type = 'PASSWORD'
                  AND u.password_versions IS NULL
             THEN
                 'YES'
             ELSE
                 'NO'
         END
             AS missing_password_verifier,
         u.password_change_date,
         CASE
             WHEN u.password_change_date IS NOT NULL
             THEN
                 TRUNC (SYSDATE - u.password_change_date)
         END
             AS password_age_days,
         u.last_login,
         u.profile,
         u.default_tablespace,
         u.temporary_tablespace,
         u.local_temp_tablespace,
         u.created,
         u.lock_date,
         u.expiry_date,
         u.initial_rsrc_consumer_group,
         u.editions_enabled,
         u.proxy_only_connect,
         u.common
             AS common_user,
         u.inherited
             AS inherited_user,
         u.implicit
             AS implicit_user,
         u.oracle_maintained,
         u.default_collation,
         u.external_name,
         sp.system_privileges,
         rp.granted_roles,
         op.object_privileges,
         cp.column_privileges
    FROM dba_users u
         LEFT JOIN default_password_users dp ON dp.username = u.username
         LEFT JOIN system_privileges sp ON sp.grantee = u.username
         LEFT JOIN role_privileges rp ON rp.grantee = u.username
         LEFT JOIN object_privileges op ON op.grantee = u.username
         LEFT JOIN column_privileges cp ON cp.grantee = u.username
ORDER BY CASE WHEN u.oracle_maintained = 'N' THEN 1 ELSE 2 END, u.username;