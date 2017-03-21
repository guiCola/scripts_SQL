USE [msdb]
GO

SELECT *
FROM RestoreHistory WITH (nolock)
ORDER BY restore_date DESC