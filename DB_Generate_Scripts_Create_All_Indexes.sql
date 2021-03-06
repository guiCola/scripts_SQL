/*
	- SRC: http://dba.stackexchange.com/questions/20355/generate-create-script-for-all-indexes
*/

USE [AdventureWorks2008R2]
GO

DECLARE @base_src VARCHAR(50)
SET @base_src = DB_NAME()
DECLARE @sql VARCHAR(MAX)



SET @sql= ('SELECT '' CREATE '' 
				+ CASE WHEN I.is_unique = 1 THEN '' UNIQUE '' ELSE '''' END
				+ I.type_desc COLLATE DATABASE_DEFAULT 
				+ '' INDEX '' 
				+ I.name 
				+ '' ON ''
				+ SCHEMA_NAME(T.schema_id) 
				+ ''.'' 
				+ T.name 
				+ '' ( '' 
				+ KeyColumns 
				+ '' )  '' 
				+ ISNULL('' INCLUDE ('' + IncludedColumns + '' ) '', '''') 
				/*+ ISNULL('' WHERE  '' + I.filter_definition, '''') */
				+ '' WITH ( '' 
				+ CASE WHEN I.is_padded = 1 THEN '' PAD_INDEX = ON '' ELSE '' PAD_INDEX = OFF '' END 
				+ '','' 
				+ ''FILLFACTOR = '' 
				+ CONVERT(CHAR(5),CASE WHEN I.fill_factor = 0 THEN 100 ELSE I.fill_factor END) 
				+ '','' 
				+ ''SORT_IN_TEMPDB = OFF '' 
				+ '','' 
				+ CASE WHEN I.ignore_dup_key = 1 THEN '' IGNORE_DUP_KEY = ON '' ELSE '' IGNORE_DUP_KEY = OFF '' END 
				+ '','' 
				+ CASE WHEN ST.no_recompute = 0 THEN '' STATISTICS_NORECOMPUTE = OFF '' ELSE '' STATISTICS_NORECOMPUTE = ON '' END 
				+ '','' 
				+ '' ONLINE = OFF '' 
				+ '','' 
				+ CASE WHEN I.allow_row_locks = 1 THEN '' ALLOW_ROW_LOCKS = ON '' ELSE '' ALLOW_ROW_LOCKS = OFF '' END 
				+ '','' 
				+ CASE WHEN I.allow_page_locks = 1 THEN '' ALLOW_PAGE_LOCKS = ON '' ELSE '' ALLOW_PAGE_LOCKS = OFF '' END 
				+ '' ) ON ['' 
				+ DS.name 
				+ '' ] '' 
				+  CHAR(13) 
				+ CHAR(10) 
				+ '' GO'' [CreateIndexScript]
		,SCHEMA_NAME(T.schema_id) AS [schemaName]
		,T.name AS tableName
		FROM   ' + @base_src + '.sys.indexes I
				   INNER JOIN ' + @base_src + '.sys.tables T ON  T.object_id = I.object_id
				   INNER JOIN ' + @base_src + '.sys.sysindexes SI ON  I.object_id = SI.id AND I.index_id = SI.indid
				   INNER JOIN (SELECT * FROM   (SELECT IC2.object_id
														,IC2.index_id
														,STUFF(
															(SELECT '' , '' + C.name + CASE WHEN MAX(CONVERT(INT, IC1.is_descending_key)) = 1 THEN '' DESC '' ELSE '' ASC '' END
															FROM   ' + @base_src + '.sys.index_columns IC1
															 INNER JOIN ' + @base_src + '.sys.columns C ON  C.object_id = IC1.object_id
																					  AND C.column_id = IC1.column_id
																					  AND IC1.is_included_column = 0
															WHERE  IC1.object_id = IC2.object_id
															AND IC1.index_id = IC2.index_id
															GROUP BY IC1.object_id,C.name,index_id
															ORDER BY MAX(IC1.key_ordinal) FOR XML PATH('''')
														),1,2,'''') KeyColumns
													FROM   ' + @base_src + '.sys.index_columns IC2 
													/*WHERE IC2.Object_id = object_id(''TheTableName'')*/ /*Comment for all tables*/
													GROUP BY IC2.object_id,IC2.index_id
													) tmp3
								)tmp4
									ON  I.object_id = tmp4.object_id AND I.index_id = tmp4.index_id
				   INNER JOIN ' + @base_src + '.sys.stats ST ON  ST.object_id = I.object_id AND ST.stats_id = I.index_id
				   INNER JOIN ' + @base_src + '.sys.data_spaces DS ON  I.data_space_id = DS.data_space_id
				   INNER JOIN ' + @base_src + '.sys.filegroups FG ON  I.data_space_id = FG.data_space_id
				   LEFT OUTER JOIN (SELECT * FROM   (SELECT IC2.object_id
															,IC2.index_id
															,STUFF(
															(SELECT '' , '' + C.name
															FROM   ' + @base_src + '.sys.index_columns IC1
															INNER JOIN ' + @base_src + '.sys.columns C ON  C.object_id = IC1.object_id
																					  AND C.column_id = IC1.column_id
																					  AND IC1.is_included_column = 1
															WHERE  IC1.object_id = IC2.object_id AND IC1.index_id = IC2.index_id
															GROUP BY IC1.object_id,C.name,index_id FOR XML PATH('''')
															),1,2,'''') IncludedColumns
													FROM   ' + @base_src + '.sys.index_columns IC2 
													/*WHERE IC2.Object_id = object_id(''TheTableName'')*/ /*Comment for all tables*/
													GROUP BY IC2.object_id,IC2.index_id
													) tmp1
													WHERE  IncludedColumns IS NOT NULL
									) tmp2 ON  tmp2.object_id = I.object_id AND tmp2.index_id = I.index_id
	 /* custom to exclude tables
	 INNER JOIN fab.TableBaseArrete perimetre ON perimetre.entite = T.name AND perimetre.[schema] = SCHEMA_NAME(T.schema_id) 
	 */
	 WHERE I.is_primary_key = 0 /*Sans les index de PK*/
	 and I.type in (1, 2) /*clustered & nonclustered only*/
	 and I.is_unique_constraint = 0 /*do not include UQ*/
	/*  AND I.is_unique_constraint = 0
		AND I.Object_id = object_id(''TheTableName'') --Comment for all tables
		AND I.name = ''IX_Address_PostalCode'' --comment for all indexes 
	*/
	ORDER BY SCHEMA_NAME(T.schema_id) ,T.name,I.name
		'
		)
EXEC (@sql)
GO