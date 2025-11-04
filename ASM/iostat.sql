select name, value from v$asm_attribute where name like '%IOSTAT%';

select  * from v$asm_disk_iostat;
