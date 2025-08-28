-- Works both in Primary and Standby
SELECT name, value, unit FROM v$dataguard_stats
WHERE name IN ('transport lag','apply lag','apply finish time');