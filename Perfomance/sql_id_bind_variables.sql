  SELECT sql_id,name,position,datatype_string,value_string,last_captured
FROM v$sql_bind_capture
WHERE sql_id = :1;  