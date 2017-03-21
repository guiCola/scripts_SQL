USE [AdventureWorks2008R2]
GO


SELECT
    t.[name] table_name
	,s.[name] schema_name
	,sum(p.[rows]) total_rows
FROM
    sys.tables t
    JOIN sys.schemas s on (t.schema_id = s.schema_id)
    JOIN sys.partitions p on (t.object_id = p.object_id)
WHERE p.index_id in (0,1)
GROUP BY t.[name],s.[name]
HAVING SUM(p.[rows]) <> 0

ORDER BY sum(p.[rows]) DESC