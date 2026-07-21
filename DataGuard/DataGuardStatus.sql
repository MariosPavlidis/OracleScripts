SELECT timestamp,
       severity,
       facility,
       error_code,
       message
FROM v$dataguard_status
WHERE severity IN ('Error', 'Fatal', 'Warning')
ORDER BY timestamp DESC
FETCH FIRST 50 ROWS ONLY;


--OR ALL
SELECT timestamp,
       facility,
       severity,
       error_code,
       message
FROM v$dataguard_status
ORDER BY timestamp DESC
FETCH FIRST 100 ROWS ONLY;