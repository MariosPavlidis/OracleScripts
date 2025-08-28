SELECT name FROM v$datafile
   UNION
SELECT name FROM v$controlfile
   UNION
SELECT name FROM v$tempfile
   UNION
SELECT member FROM v$logfile;