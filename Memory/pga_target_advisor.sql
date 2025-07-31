SELECT ceil (pga_target_for_estimate/1024/1024) AS target_mb,
       estd_pga_cache_hit_percentage AS hit_pct,
       estd_overalloc_count AS overallocs
FROM v$pga_target_advice
WHERE estd_overalloc_count = 0
ORDER BY estd_pga_cache_hit_percentage DESC, target_mb fetch first row only;