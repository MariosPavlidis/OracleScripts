SELECT owner, object_type, COUNT(*) invalid_count
FROM dba_objects
WHERE status = 'INVALID'
GROUP BY owner, object_type
ORDER BY invalid_count DESC;