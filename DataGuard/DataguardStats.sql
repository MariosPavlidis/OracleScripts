SELECT name,
       value,
       unit,
       time_computed,
       datum_time
FROM v$dataguard_stats
WHERE name IN (
    'transport lag',
    'apply lag',
    'apply finish time',
    'estimated startup time'
)
--or name like '%lag%'
ORDER BY name;