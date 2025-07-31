---Undo advisor for undo size with memeory info
set serveroutput on
DECLARE
utbsiz_in_MB NUMBER;
BEGIN
utbsiz_in_MB := DBMS_UNDO_ADV.RBU_MIGRATION;
dbms_output.put_line('=================================================================');
dbms_output.put_line('The Minimum size of the undo tablespace required is : '||utbsiz_in_MB||' MB');
dbms_output.put_line('=================================================================');
end;
/