USE [ReportServer]
GO
--The first CTE gets the content as a varbinary(max)
--as well as the other important columns for all reports,
--data sources and shared datasets.
WITH ItemContentBinaries AS
(
  SELECT
     ItemID,[path] Name,[Type]
    ,CASE Type
       WHEN 2 THEN 'Report'
       WHEN 5 THEN 'Data Source'
       WHEN 7 THEN 'Report Part'
       WHEN 8 THEN 'Shared Dataset'
       ELSE 'Other'
     END AS TypeDescription
    ,CONVERT(varbinary(max),Content) AS Content
  FROM ReportServer.dbo.Catalog
  WHERE Type = 2 --IN (2,5,7,8)
),
--The second CTE strips off the BOM if it exists...
ItemContentNoBOM AS
(
  SELECT
     ItemID,Name,[Type],TypeDescription
    ,CASE
       WHEN LEFT(Content,3) = 0xEFBBBF
         THEN CONVERT(varbinary(max),SUBSTRING(Content,4,LEN(Content)))
       ELSE
         Content
     END AS Content
  FROM ItemContentBinaries
)
--The old outer query is now a CTE to get the content in its xml form only...
,ItemContentXML AS
(
  SELECT
     ItemID,Name,[Type],TypeDescription
    ,CONVERT(xml,Content) AS ContentXML
 FROM ItemContentNoBOM
 --WHERE Content like '%tfrGroup_id%'
)
--now use the XML data type to extract the queries, and their command types and text....
SELECT
     ItemID,Name,[Type],TypeDescription,ContentXML
    ,ISNULL(Query.value('(./*:CommandType/text())[1]','nvarchar(1024)'),'Query') AS CommandType
    ,Query.value('(./*:CommandText/text())[1]','nvarchar(max)') AS CommandText
FROM ItemContentXML

--Get all the Query elements (The "*:" ignores any xml namespaces)
CROSS APPLY ItemContentXML.ContentXML.nodes('//*:Query') Queries(Query)