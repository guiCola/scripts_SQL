DECLARE @@sp_helpuser AS TABLE
(
SPID INTEGER
,[Status] VARCHAR(255)
,[Login] VARCHAR(255)
,HostName VARCHAR(255)
,BlkBy VARCHAR(255)
,DBName VARCHAR(255)
,Command VARCHAR(255)
,CPUtime INTEGER
,diskIO INTEGER
,LastBatch VARCHAR(255)
,ProgramName  VARCHAR(255)
,SPID2 VARCHAR(255)
,REQUESTID INTEGER
)
INSERT INTO @@sp_helpuser EXEC sys.sp_who2


SELECT * 
FROM @@sp_helpuser
ORDER BY 10 DESC