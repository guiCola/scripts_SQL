CREATE TABLE #tmp_2000(
serverName VARCHAR(255)
,serverVersion VARCHAr(255)
,userName VARCHAR(255)
,databaseName VARCHAR(255)
,userType VARCHAR(255)
,dbRole VARCHAR(255)
,isBulkadmin VARCHAR(15)
,isdbcreator VARCHAR(15)
,isdiskadmin VARCHAR(15)
,isprocessadmin VARCHAR(15)
,issecurityadmin VARCHAR(15)
,isserveradmin VARCHAR(15)
,issetupadmin VARCHAR(15)
,issysadmin VARCHAR(15)
)

DECLARE @sql VARCHAR(4000)
DECLARE @dbName VARCHAR(50)

DECLARE uss CURSOR FOR
	SELECT top 100 name
	FROM master.dbo.sysdatabases
	--WHERE name NOT IN ('master','model','msdb','tempdb') 

OPEN uss
FETCH NEXT FROM uss INTO @dbName

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @sql = 
		'INSERT INTO #tmp_2000
		 SELECT @@SERVERNAME
				,@@VERSION
				,l.name
				,'''+@dbName+''' AS dbName				
				,CASE
					WHEN u.issqluser = 1 THEN ''Sql''
					WHEN l.isntuser = 1 THEN ''WindowsUser''
					WHEN l.isntgroup = 1 THEN ''WindowsGroup''
					
				END AS userType
				,r.name AS dbRole
				,CASE WHEN l.bulkadmin = 1 THEN ''bulkadmin'' END AS isBulkadmin
				,CASE WHEN l.dbcreator = 1 THEN ''dbcreator'' END AS isdbcreator
				,CASE WHEN l.diskadmin = 1 THEN ''diskadmin'' END AS isdiskadmin
				,CASE WHEN l.processadmin = 1 THEN ''processadmin'' END AS isprocessadmin
				,CASE WHEN l.securityadmin = 1 THEN ''securityadmin'' END AS issecurityadmin
				,CASE WHEN l.serveradmin = 1 THEN ''serveradmin'' END AS isserveradmin
				,CASE WHEN l.setupadmin = 1 THEN ''setupadmin'' END AS issetupadmin
				,CASE WHEN l.sysadmin = 1 THEN ''sysadmin'' END AS issysadmin
				
		 FROM master.dbo.syslogins l
			LEFT JOIN '+@dbName+'.dbo.sysusers u ON u.sid = l.sid
			LEFT JOIN ('+@dbName+'.dbo.sysmembers m 
									   JOIN '+@dbName+'.dbo.sysusers r ON m.groupuid = r.uid
								) ON m.memberuid = u.uid
			--WHERE u.islogin = 1 OR u.isntname = 1 OR u.isntgroup = 1
			 ORDER BY u.name' 
	EXEC(@sql)
	FETCH NEXT FROM uss INTO @dbName
END

CLOSE uss;
DEALLOCATE uss;


select  *
from #tmp_2000
ORDER BY 1,2

DROP TABLE #tmp_2000;