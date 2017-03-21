USE [master]
GO

DECLARE @databasename VARCHAR(100)
DECLARE @sess_id INTEGER
DECLARE @kill_session VARCHAR(20)

SET @databasename = ''

DECLARE session_id_cursor CURSOR FOR
	SELECT DISTINCT request_session_id 
	FROM master.sys.dm_tran_locks 
	WHERE resource_type = 'DATABASE' 
	AND resource_database_id = db_id(@databasename) 
	AND request_session_id<>@@spid

OPEN session_id_cursor FETCH NEXT FROM session_id_cursor INTO @sess_id

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @kill_session = 'kill '+ convert(VARCHAR(10),@sess_id) + ';'
	EXEC (@kill_session)
	FETCH NEXT FROM session_id_cursor INTO @sess_id
END

CLOSE session_id_cursor
DEALLOCATE session_id_cursor
GO