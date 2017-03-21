/*	- short demo tu activate Change Data Capture
	- SQL SERVER 2008 R2
	- enable SQL AGENT
	- SRC: http://www.softfluent.fr/blog/expertise/2015/05/05/SQL-Server-Change-Data-Capture-(CDC)
*/


RAISERROR ('Did you mean to run the whole thing?', 20, 1) WITH LOG;
GO

USE [AdventureWorks2008R2]
GO

/*Enable CDC on database*/
EXEC sys.sp_cdc_enable_db
GO 

/*Check database with CDC activated*/
SELECT [name], database_id, is_cdc_enabled  FROM sys.databases WHERE is_cdc_enabled = 1

/*Disable CDC on database*/
EXEC sys.sp_cdc_disable_db


/*Enable CDC on table*/
EXEC sys.sp_cdc_enable_table     
@source_schema = N'HumanResources',     
@source_name   = N'Department',     
@role_name     = NULL,
@index_name    = N'PK_Department_DepartmentID',
@captured_column_list = N'DepartmentID,Name'


/*Check table with CDC activated*/
SELECT * FROM sys.tables WHERE is_tracked_by_cdc = 1
SELECT * FROM cdc.captured_columns


/*Disable CDC on table*/
DECLARE @capture_instance VARCHAR(50)

SELECT @capture_instance = [capture_instance]  FROM [cdc].[change_tables]
EXEC sys.sp_cdc_disable_table     
@source_schema = N'HumanResources',     
@source_name   = N'Department',     
@capture_instance = @capture_instance


/*USING CDC*/
SELECT * FROM HumanResources.Department WHERE DepartmentID = 1
GO
UPDATE HumanResources.Department SET [Name] = 'Engineering_test_CDC' WHERE DepartmentID = 1
GO
SELECT * FROM HumanResources.Department WHERE DepartmentID = 1
GO

/*[__$operation]
1 = Delete
2 = Insert
3 = Value before Update
4 = Value after Update
*/

SELECT *  FROM cdc.HumanResources_Department_CT