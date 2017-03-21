/*
	-SRC: http://www.bidn.com/blogs/kylewalker/ssis/1915/how-to-match-your-subcription-names-with-its-job-id
*/

USE [reportServer]
GO

SELECT Subscriptions.[Description] AS SubscriptionName
	  ,Schedule.ScheduleID AS JobID
	  ,Catalog.[Name] AS ReportName
FROM dbo.Subscriptions
	INNER JOIN dbo.ReportSchedule ON ReportSchedule.SubscriptionID = Subscriptions.SubscriptionID
	INNER JOIN dbo.Schedule ON ReportSchedule.ScheduleID = Schedule.ScheduleID
	INNER JOIN dbo.[Catalog] ON ReportSchedule.ReportID = [Catalog].ItemID
							AND Subscriptions.Report_OID = [Catalog].ItemID
ORDER BY CAST(Schedule.ScheduleID AS VARCHAR(100))
GO