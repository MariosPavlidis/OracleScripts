-- ols_status.sql
-- Checks Oracle Label Security (OLS) installation and configuration
-- OLS provides row-level security using sensitivity labels (e.g., TOP SECRET, CONFIDENTIAL)

-- Check if OLS option is installed
SELECT
    parameter,
    value AS status
FROM
    v$option
WHERE
    parameter = 'Oracle Label Security';

-- Check if OLS is enabled (requires LBACSYS or SA_SYSDBA role)
SELECT
    policy_name,
    status,
    column_name,
    default_options,
    hidden_column
FROM
    all_sa_policies
ORDER BY
    policy_name;

-- Tables protected by OLS policies
SELECT
    schema_name,
    table_name,
    policy_name,
    predicate,
    label_function,
    check_control
FROM
    all_sa_table_policies
ORDER BY
    policy_name,
    schema_name,
    table_name;

-- OLS labels defined
SELECT
    policy_name,
    label_tag,
    label,
    data_label,
    parent_label
FROM
    all_sa_labels
ORDER BY
    policy_name,
    label_tag;
