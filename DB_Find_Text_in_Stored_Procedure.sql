USE [AdventureWorks2008R2]
GO

SELECT DISTINCT 
		o.[name] AS [SP_Name]
       ,o.[type_desc]
       ,m.[definition]
       ,o.*
FROM sys.sql_modules m 
	INNER JOIN sys.objects o ON m.object_id = o.object_id
WHERE o.[type] IN ('V','P','R')
AND m.[definition] like '%mytext%'
GO