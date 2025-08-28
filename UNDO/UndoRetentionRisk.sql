SELECT TO_CHAR(begin_time,'YYYY-MM-DD HH24:MI') as_begin,
       tuned_undoretention, nospaceerrcnt, unxpstealcnt
FROM v$undostat
ORDER BY begin_time DESC FETCH FIRST 24 ROWS ONLY;