SELECT memory_size, memory_size_factor, estd_db_time
FROM v$memory_target_advice
ORDER BY memory_size;