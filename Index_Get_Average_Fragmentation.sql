/*Return the indexes average fragmentation for a specific database*/

USE [AdventureWorks2008R2]
GO

SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName
	,ind.name AS IndexName
	,indexstats.index_type_desc AS IndexType
	,indexstats.avg_fragmentation_in_percent

FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats
	INNER JOIN sys.indexes ind  ON ind.object_id = indexstats.object_id
AND ind.index_id = indexstats.index_id
WHERE indexstats.avg_fragmentation_in_percent > 30 --You can specify the percent of fragmentation you wish to see
ORDER BY indexstats.avg_fragmentation_in_percent DESC
GO