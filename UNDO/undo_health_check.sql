--Undo health check
set serveroutput on

DECLARE
 prob VARCHAR2(100);
 reco VARCHAR2(100);
 rtnl VARCHAR2(100);
 retn PLS_INTEGER;
 utbs PLS_INTEGER;
 retv PLS_INTEGER;
BEGIN
retv := dbms_undo_adv.undo_health(prob, reco, rtnl, retn, utbs);
dbms_output.put_line('=====================================================================');
If retv=0 Then dbms_output.put_line('Problem: ' || prob || ' The undo tablespace is OK');
ELSIF retv=2 Then dbms_output.put_line('Long running queries may fail , The recommendation is : ' || reco);
dbms_output.put_line('rationale: ' || rtnl);
dbms_output.put_line('retention: ' || TO_CHAR(retn));

ELSIF retv=3 Then dbms_output.put_line('The Undo tablespace cannot satisfy the longest query , The recommendation is : ' || reco);
dbms_output.put_line('rationale: ' || rtnl);
dbms_output.put_line('undo tablespace size in MB : ' || TO_CHAR(utbs));
dbms_output.put_line('retention: ' || TO_CHAR(retn));

ELSIF retv=4 Then dbms_output.put_line('The System does not have an online undo tablespace , The recommendation is : ' || reco);
dbms_output.put_line('rationale: ' || rtnl);
dbms_output.put_line('undo tablespace size in MB : ' || TO_CHAR(utbs));

ELSIF retv=1 Then dbms_output.put_line('The Undo tablespace cannot satisfy the specified undo_retention or The Undo tablespace cannot satisfy auto tuning undo retention , The recommendation is : ' || reco);
dbms_output.put_line('rationale: ' || rtnl);
dbms_output.put_line('undo tablespace size in MB : ' || TO_CHAR(utbs));
end if;
dbms_output.put_line('=====================================================================');

END;
/