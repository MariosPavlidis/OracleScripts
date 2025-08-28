SELECT file_type, percent_space_used, percent_space_reclaimable
FROM v$recovery_area_usage ORDER BY percent_space_used DESC;