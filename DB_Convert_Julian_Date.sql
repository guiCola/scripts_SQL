/* @saber BENABDESSAMAD*/

USE [AdventureWorks2008R2]
GO

DECLARE @dtDate DATETIME
SET @dtDate = GETDATE()
 
DECLARE @a INT
DECLARE @y INT
DECLARE @m INT
DECLARE @JDN INT --Julian Day Number
DECLARE @JD DECIMAL(18,5) --Full Julian Date
DECLARE @dayOfWeek INT
DECLARE @date DATETIME

SET @date = @dtDate
SET @dayOfWeek = DATEPART(dd,@date)
SET @a = FLOOR((14 - DATEPART(mm, @date)) / 12)
SET @y = DATEPART(yy, @date) + 4800 - @a
SET @m = DATEPART(mm, @date) + (12 * @a) - 3
SET @JDN = FLOOR(@dayOfWeek + ((153 * @m + 2) / 5) + (365 * @y) + (@y / 4) - (@y / 100) + (@y / 400) - 32045)
SET @JD = @JDN + ((DATEPART(hh, @date) - 12.00) / 24.00) + (DATEPART(mi,@date) / 1440.00) + (DATEPART(ss, @date) / 86400.00)


SELECT @JD AS todayJulianDate
GO