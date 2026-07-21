select
dbms_perf.report_perfhub(is_realtime=>0,
                         type=>'active',
                         selected_start_time=>to_date('16-12-2025 16:00:00','dd-mm-YYYY hh24:mi:ss'),
                        selected_end_time=>to_date('16-12-2025 16:30:00','dd-mm-YYYY hh24:mi:ss')) 
from dual;