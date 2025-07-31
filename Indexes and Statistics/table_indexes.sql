with IDX as (
Select b.table_owner,a.table_name, a.index_name, a.column_name||' '||decode(a.descend,'DESC','DESC') column_name,column_position,
b.uniqueness,distinct_keys,blevel,leaf_blocks,num_rows,status,degree,global_stats,partitioned
FROM dba_ind_columns a,dba_indexes b where b.index_name = a.index_name
and a.table_name=:1
order by 1,2,3,5
)
SELECT
table_owner,table_name,index_name,uniqueness,distinct_keys,blevel,leaf_blocks,num_rows,status,degree,partitioned,global_stats,
LISTAGG(column_name, ', ')
WITHIN GROUP (ORDER BY column_position) "COLUMNS"
FROM IDX
GROUP BY table_owner,table_name,index_name,uniqueness,distinct_keys,blevel,leaf_blocks,num_rows,status,degree,partitioned,global_stats
order by columns;