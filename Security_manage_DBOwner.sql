/*Find the db owner and change it*/

USE [AdventureWorks2008R2]

SELECT name
        ,database_id
        ,USER_NAME(owner_sid) as DBOwner
FROM sys.databases 
WHERE name ='AdventureWorks2008R2'
GO

Exec sp_changedbowner 'sa'
Exec sp_changedbowner 'DOMAIN\user'
GO