/* Formatted on 28/8/2025 12:30:47 μμ (QP5 v5.404) */
SELECT    a.sid
       || DECODE (request,
                  0, '(holder)',
                  '(waiter)' || ':blocked by:' || blocking_session)
           sess_id,
       lmode,
       request,
       a.TYPE,
       c.object_name,
       DECODE (row_wait_obj#,
               -1, 'Holder of Lock !!!',
               DBMS_ROWID.rowid_create (1,
                                        row_wait_obj#,
                                        row_wait_file#,
                                        row_wait_block#,
                                        row_wait_row#))
           row_id,
       NVL (SQL_FULLTEXT, 'Holder of Lock !!!')
  FROM V$LOCK           A,
       V$LOCKED_OBJECT  B,
       ALL_OBJECTS      C,
       V$SESSION        D,
       V$SQL            E
 WHERE     (id1, id2, a.TYPE) IN (SELECT id1, id2, TYPE
                                    FROM v$lock
                                   WHERE request > 0)
       AND a.sid = b.session_id
       AND b.object_id = c.object_id
       AND d.sid = a.sid
       AND d.sql_hash_value = e.hash_value(+);