USE [AdventureWorks2008R2]
GO

ALTER DATABASE [AdventureWorks2008R2] SET OFFLINE WITH ROLLBACK IMMEDIATE
GO

DECLARE 
	@DestDBName AS VARCHAR(50) 
	,@BackUpPath AS VARCHAR(255)
	,@DST_MDF_PATH AS VARCHAR(1000)
	,@DST_LDF_PATH AS VARCHAR(1000)
	,@SQL AS VARCHAR(1000)
  


 SET @DestDBName = 'AdventureWorks2008R2'
 SET @BackUpPath = 'D:\5-MSSQLSERVER\MSSQL\BACKUPS\AdventureWorks2008R2.bak'
 SET @DST_MDF_PATH = 'D:\5-MSSQLSERVER\MSSQL\DATA\AdventureWorks2008R2.MDF'
 SET @DST_LDF_PATH = 'D:\5-MSSQLSERVER\MSSQL\LOGS\AdventureWorks2008R2.LDF'
 
--Pour avoir les logicalnames
DECLARE @TMP AS TABLE (
	LogicalName  nvarchar(128)
	,PhysicalName nvarchar(260)
	,Type  char(1)
	,FileGroupName  nvarchar(128)
	,Size  numeric(20,0)
	,MaxSize  numeric(20,0)
	,FileID  bigint
	,CreateLSN  numeric(25,0)
	,DropLSN  numeric(25,0) NULL
	,UniqueID  uniqueidentifier
	,ReadOnlyLSN  numeric(25,0) NULL
	,ReadWriteLSN numeric(25,0) NULL
	,BackupSizeInBytes  bigint
	,SourceBlockSize  int
	,FileGroupID  int
	,LogGroupGUID  uniqueidentifier
	,DifferentialBaseLSN  numeric(25,0)
	,DifferentialBaseGUID uniqueidentifier
	,IsReadOnly  bit
	,IsPresent  bit
	,TDEThumbprint  varbinary(32) --SQL 2008R2
) 

INSERT INTO @TMP (LogicalName,PhysicalName,[Type],FileGroupName,Size,MaxSize,FileID,CreateLSN,DropLSN,UniqueID,ReadOnlyLSN,ReadWriteLSN,BackupSizeInBytes,SourceBlockSize
				,FileGroupID,LogGroupGUID,DifferentialBaseLSN,DifferentialBaseGUID,IsReadOnly,IsPresent
				,TDEThumbprint --SQL 2008R2
)
 Exec ('RESTORE FILELISTONLY FROM DISK = '''+ @BackUpPath +'''')

SET @SQL = 
  'RESTORE DATABASE ' + @DestDBName + ' FROM DISK = '''+ @BackUpPath +'''
   WITH 
     MOVE '''+ (SELECT logicalname from @TMP WHERE Type = 'D') +''' TO '''+ @DST_MDF_PATH  + ''' ,
     MOVE '''+ (SELECT logicalname from @TMP WHERE Type = 'L') +''' TO '''+ @DST_LDF_PATH +''',
     REPLACE'

SELECT (@SQL)
--Exec (@SQL)
GO