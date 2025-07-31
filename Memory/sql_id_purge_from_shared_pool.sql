BEGIN
  FOR rec IN (
    SELECT address, hash_value
    FROM v$sqlarea
    WHERE sql_id = 'g0vu28jrzyg8z'
  ) LOOP
    DBMS_SHARED_POOL.PURGE (
      name      => rec.address || ',' || rec.hash_value,
      flag      => 'C',
      heaps     => 1
    );
  END LOOP;
END;
/