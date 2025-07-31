SELECT 
  sga_size,
  sga_size_factor,
  ROUND(estd_db_time / 1000000, 2) AS db_time_sec,
  estd_physical_reads
FROM 
  v$sga_target_advice
WHERE 
  ROUND(estd_db_time / 1000000, 2) = (
    SELECT MIN(ROUND(estd_db_time / 1000000, 2))
    FROM v$sga_target_advice
  )
  order by sga_size fetch first row only;