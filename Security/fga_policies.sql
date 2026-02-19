-- fga_policies.sql
-- Lists all Fine-Grained Auditing (FGA) policies defined in the database
-- FGA provides row- and column-level audit granularity for sensitive data

SELECT
    owner,
    object_schema,
    object_name,
    policy_name,
    policy_column,
    pf_schema,
    pf_package,
    pf_function,
    enabled,
    sel,
    ins,
    upd,
    del,
    audit_trail,
    policy_column_options
FROM
    dba_audit_policies
ORDER BY
    object_schema,
    object_name,
    policy_name;
