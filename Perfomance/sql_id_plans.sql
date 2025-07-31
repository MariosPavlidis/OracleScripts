    SELECT
    inst_id,    sql_id,    child_number,    plan_hash_value,    id,    
LPAD(' ', id * 2) || operation ||         DECODE(options, NULL, '', ' ' || options) ||        DECODE(object_name, NULL, '', ' on ' || object_name) AS plan_step,
    object_type,     object_owner,    object_name,    access_predicates,    filter_predicates,    cardinality,    bytes,    cost
FROM
    gv$sql_plan
WHERE
    sql_id = :1
ORDER BY
    inst_id, child_number, id;
