/*
	-@yoni BENAIM
*/
USE [AdventureWorks2008R2]
GO

/*If recovery level full, do it while database IS NOT USED*/
ALTER DATABASE [AdventureWorks2008R2] SET RECOVERY SIMPLE
GO

DECLARE @DBName varchar(255)
DECLARE @LogName varchar(255)
DECLARE @DATABASES_Fetch int
DECLARE DATABASES_CURSOR CURSOR FOR

    SELECT DISTINCT name, DB_NAME(s_mf.database_id) dbName
    FROM sys.master_files s_mf
    WHERE s_mf.state = 0 
    AND has_dbaccess(db_name(s_mf.database_id)) = 1 --Selection des bases avec acces
    AND db_name(s_mf.database_id) not in ('Master','tempdb','model')
    AND db_name(s_mf.database_id) not like 'MSDB%'
    AND db_name(s_mf.database_id) not like 'Report%'
    --AND db_name(s_mf.database_id) = 'PHENIX'
    AND type=1
    ORDER BY db_name(s_mf.database_id)
    
OPEN DATABASES_CURSOR
FETCH NEXT FROM DATABASES_CURSOR INTO @LogName, @DBName
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @DBName;
 exec ('USE [' + @DBName + '] ; DBCC SHRINKDATABASE (N''' + @DBName + ''')') --Shrink databases
 exec ('USE [' + @DBName + '] ; DBCC SHRINKFILE (N''' + @DBName + ''')') --Shrink databases files
 exec ('USE [' + @DBName + '] ; DBCC SHRINKFILE (N''' + @LogName + ''' ,1/* , TRUNCATEONLY*/)')--Shrink log files
 FETCH NEXT FROM DATABASES_CURSOR INTO @LogName, @DBName
END
CLOSE DATABASES_CURSOR
DEALLOCATE DATABASES_CURSOR

/*If recovery level full, do it while database IS NOT USED*/
ALTER DATABASE [AdventureWorks2008R2] SET RECOVERY FULL
GO

/*shrink tempdb*/
USE tempdb;
CHECKPOINT;
GO
DBCC DROPCLEANBUFFERS; -- purge des index en cache et des dataPages
GO
DBCC FREEPROCCACHE; -- purge de caches des procedures
GO
DBCC FREESYSTEMCACHE ('ALL'); -- purge des caches System pour tous les ojets
GO
DBCC FREESESSIONCACHE; -- purge du cache session des connections
GO
DBCC SHRINKFILE (tempdev,1);   --Shrink des fichiers de bases
DBCC SHRINKFILE (templog,1);   --Shrink des fichiers de log
GO

