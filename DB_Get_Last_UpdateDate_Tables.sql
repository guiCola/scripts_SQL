USE [AdventureWorks2008R2]
GO

SELECT 
		OBJECT_SCHEMA_NAME(OBJECT_ID) AS SchemaName
		,OBJECT_NAME(OBJECT_ID) AS DatabaseName
		,last_user_update
		, *
FROM sys.dm_db_index_usage_stats
WHERE database_id = DB_ID()
and OBJECT_SCHEMA_NAME(OBJECT_ID) = 'HumanResources'
and OBJECT_NAME(OBJECT_ID) = 'Department'
GO