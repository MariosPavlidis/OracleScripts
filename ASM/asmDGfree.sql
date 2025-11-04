select name, state, type, total_mb, free_mb, round((free_mb/total_mb)*100,2) pct_free from v$asm_diskgroup;
