USE [AdventureWorks2008R2]
GO

SET NOCOUNT ON
DECLARE @START  INT, @STOP INT
DECLARE @@TMP AS TABLE(
		[SalesOrderID] [int] ,
	[SalesOrderDetailID] [int],
	[CarrierTrackingNumber] [nvarchar](25) ,
	[OrderQty] [smallint] ,
	[ProductID] [int] ,
	[SpecialOfferID] [int] ,
	[LineTotal]  NUMERIC(38,6),
	[rowguid] [uniqueidentifier] ROWGUIDCOL  ,
	[ModifiedDate] [datetime] 
)
SET  @START=0 ;  SET @STOP = 10 -- Nb transaction
WHILE (@START < @STOP) 
BEGIN
BEGIN TRAN


;WITH cte ([SalesOrderID]
	,[SalesOrderDetailID]
	,[CarrierTrackingNumber]
	,[OrderQty]
	,[ProductID]
	,[SpecialOfferID]
	,[LineTotal]
	,[rowguid]
	,[ModifiedDate]
)AS (
SELECT top 10000000 
		p1.[SalesOrderID]
	,p1.[SalesOrderDetailID]
	,p1.[CarrierTrackingNumber]
	,p1.[OrderQty]
	,p1.[ProductID]
	,p1.[SpecialOfferID]
	,p1.[LineTotal]
	,p1.[rowguid]
	,p1.[ModifiedDate]
FROM         [Sales].[SalesOrderDetail] p1 
	CROSS APPLY [Sales].[SalesOrderDetail] p2

)
INSERT INTO @@TMP SELECT * FROM cte


SET @START = @START + 1
COMMIT TRAN
END