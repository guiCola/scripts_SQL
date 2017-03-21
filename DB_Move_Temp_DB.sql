ALTER DATABASE tempdb
MODIFY FILE (NAME = tempdev, FILENAME = 'D:\5-MSSQLSERVER\MSSQL\TEMP\tempdb.mdf');
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME = templog, FILENAME = 'D:\5-MSSQLSERVER\MSSQL\TEMP\templog.ldf');
GO

SELECT name, physical_name AS CurrentLocation, state_desc
FROM sys.master_files
WHERE database_id = DB_ID(N'TEMPDB')