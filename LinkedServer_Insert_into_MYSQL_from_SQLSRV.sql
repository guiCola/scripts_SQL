/* 
	- SRC: @Saber BENABDESSAMAD
	- linked server name: MYSQL
*/
USE [AdventureWorks2008R2]
GO

DECLARE @DATABASE_NAME AS VARCHAR(255) = DB_NAME()
DECLARE @TABLE_NAME    AS VARCHAR(255) = 'person'
DECLARE @TABLE_SCHEMA  AS VARCHAR(255) = 'person'
DECLARE @COLUMN_CLAUSE AS VARCHAR(MAX) = ''
DECLARE @INSERT_CLAUSE_PART1 as varchar(MAX) = ''
DECLARE @INSERT_CLAUSE_PART2 as varchar(MAX) = ''

SELECT @COLUMN_CLAUSE = 
       STUFF ((SELECT ', ' 
						+ COLUMN_NAME 
						+ ''
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_NAME = @TABLE_NAME 
				AND TABLE_SCHEMA = @TABLE_SCHEMA
				ORDER BY ORDINAL_POSITION DESC
				FOR XML PATH(''))
				, 1, 1, '') 

SELECT @INSERT_CLAUSE_PART1  = ' INSERT OPENQUERY(MYSQL,''SELECT ' + @COLUMN_CLAUSE + ' FROM ' + @DATABASE_NAME + '.' + @TABLE_NAME + ''')'
SELECT @INSERT_CLAUSE_PART2  = ' SELECT ' + @COLUMN_CLAUSE + ' FROM ' + @DATABASE_NAME + '.' + @TABLE_SCHEMA + '.' + @TABLE_NAME + ''
SELECT @INSERT_CLAUSE_PART1 =  @INSERT_CLAUSE_PART1 + CHAR(10) + @INSERT_CLAUSE_PART2


select (@INSERT_CLAUSE_PART1)
--exec (@INSERT_CLAUSE_PART1)