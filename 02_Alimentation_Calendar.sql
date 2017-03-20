USE [InventaireDW]  
print 'Début du script'

--set language 'english';
set language 'french'
set datefirst 1;

WITH
MANGAL as
(
SELECT Cast ('2000-01-01' as DateTime) Date 
UNION  ALL
SELECT Date + 1 FROM MANGAL WHERE Date + 1 < = Cast ('2030-12-12' as DateTime) 
)
INSERT INTO [dwh].[DIM_CALENDAR_CAL] (CAL_CalendarId,
									CAL_ValueDate,
									CAL_DateName,
									CAL_Year_Datetime,
									CAL_Year_Name,
									CAL_Semester_Datetime,
									CAL_SemesterName,
									CAL_Trimester_Datetime,
									CAL_Trimester_Name,
									CAL_Month_Datetime,
									CAL_Month_Number_Year,
									CAL_Month_Number_Of_Trimester,
									CAL_Month_Name_FR,
									CAL_Month_Name_Abbreviation_FR,
									CAL_Week_Datetime,
									CAL_Week_Number_Of_Year,
									CAL_Week_Number_Of_Year_ISO8601,
									CAL_Week_Number_Of_Trimester,
									CAL_Week_Number_Of_Month,
									CAL_Day_Number_Of_Year,
									CAL_Day_Number_Of_Trimester,
									CAL_Day_Number_Of_Month,
									CAL_Day_Number_Of_Week,
									CAL_Day_IsMemberLastWeek,
									CAL_Day_Name_FR,
									CAL_Day_Name_Abbreviation_FR
									)
	SELECT 
	CAST(convert(Varchar(10),date,112) as integer) 
	,Date
	,CONVERT(VarChar(12),date,113)
	,CAST(cast(YEAR (date) AS varchar(4))+'0101' as datetime)
	,YEAR (date)
	,cast(cast(YEAR (date) AS varchar(4)) + '0' + cast(Ceiling(Month(date)/6.0)as varchar(1)) +'01' as datetime)
	,Ceiling(Month(date)/6.0)
	,CAST(cast(YEAR (date) AS varchar(4))+right('0'+cast(((DatePart ( qq, date)-1)*3)+1 AS varchar(2)),2)+'01' as datetime)
	,DatePart (qq, date)
	,CAST(cast(YEAR (date) AS varchar(4))+right('0'+cast(MONTH (date) AS varchar(2)),2)+'01' as datetime)
	,MONTH (date)
	,DateDiff(mm,DateAdd(qq,DateDiff(qq,0,date),0),date)+1 
	,DateName (mm, date)
	,LEFT( DateName (mm, date), 3)
	,DATEADD(DD, 1 - DATEPART(DW, date), date)
	,DatePart (wk, Date)
	,dwh.weekNumber(Date)
	--,datediff(wk,dateadd(qq,datediff(qq,0,date),0),date)+1
	,datediff(wk,dateadd(qq,datediff(qq,0,date),0),date)+1
	,datediff(wk,dateadd(mm,datediff(mm,0,date),0),date)+1
	,DatePart (dy, date)
	,datediff(dd,dateadd(qq,datediff(qq,0,date),0),date)+1
	,DAY (date) 
	,DatePart (dw, date)
	, (select dwh.FNT_Is_Member_Last_Week(date))
	,DateName (dw, date)
	,LEFT(DateName (dw, date), 3)
	FROM
	MANGAL
	OPTION
	(MAXRECURSION 0)
print 'Fin du script'
