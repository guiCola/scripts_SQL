/*Exclude object from sp_msforeachtable*/

USE [AdventureWorks2008R2]
GO

EXEC sp_msforeachtable
 @command1 ='SELECT top 1 * FROM ?'
,@whereand = ' And Object_id In (Select Object_id From sys.objects
			Where name not in (''AWBuildVersion'',''EmailAddress''))'
GO