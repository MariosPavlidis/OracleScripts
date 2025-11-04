select group_number, disk_number, name, path, header_status, mode_status, state, total_mb, free_mb 
from v$asm_disk
order by group_number, disk_number;