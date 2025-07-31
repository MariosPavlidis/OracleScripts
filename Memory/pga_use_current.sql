SELECT
    s.sid,
    s.serial#,
    p.spid,
    ROUND(p.pga_used_mem / 1024 / 1024, 2) AS used_mb,
    ROUND(p.pga_alloc_mem / 1024 / 1024, 2) AS alloc_mb,
    ROUND(p.pga_max_mem / 1024 / 1024, 2) AS max_mb,
    s.program,
    s.module
FROM
    v$process p
JOIN
    v$session s ON p.addr = s.paddr
WHERE
    s.type = 'USER'
ORDER BY
    alloc_mb DESC;
	