/*
	- SRC: @Saber BENABDESSAMAD
	- DROP-CREATE MYSQL LINKEDSERVER 
	- SQL Server linked server name: MYSQL
	- mysql database name: mysql
*/

USE [AdventureWorks2008R2]
GO

IF  EXISTS (SELECT SRV.NAME FROM SYS.SERVERS SRV WHERE SRV.SERVER_ID != 0 AND SRV.NAME = N'MYSQL')
EXEC MASTER.DBO.SP_DROPSERVER
				 @SERVER=N'MYSQL'
				 , @DROPLOGINS='DROPLOGINS'
GO

EXEC master.dbo.sp_addlinkedserver 
			@server = N'MYSQL'
			, @srvproduct=N'MySQL'
			, @provider=N'MSDASQL'
			, @provstr=N'DRIVER={MySQL ODBC 5.1 Driver}; SERVER=localhost;DATABASE=mysql; USER=root; PASSWORD=root; OPTION=3'
     
GO