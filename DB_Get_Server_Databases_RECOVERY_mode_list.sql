USE [master]

SELECT [name]
		, DATABASEPROPERTYEX([name],'recovery') AS recoveryMode
FROM sysdatabases
WHERE [name] not in ('master','model','tempdb','msdb')
 --and DATABASEPROPERTYEX([name],'recovery') = 'FULL'