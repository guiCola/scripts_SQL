/*Create a calendar in SQL Server*/
--set language 'english';
set language 'french'
set datefirst 1;

WITH	cte_calendar as
	(
		SELECT Cast ('2000-01-01' as DateTime) [Date] 
		UNION  ALL
		SELECT [Date] + 1 
		FROM cte_calendar 
		WHERE [Date] + 1 < = Cast ('2030-12-12' as DateTime) 
	)

	SELECT 
	CAST(convert(Varchar(10),[Date],112) as integer) AS CAL_CalendarId
	,[Date] AS CAL_ValueDate
	,CONVERT(VarChar(12),[Date],113) AS CAL_DateName

	/*Year informations*/
	,CAST(cast(YEAR ([Date]) AS varchar(4))+'0101' as datetime) AS CAL_Year_Datetime
	,YEAR ([Date]) AS CAL_Year_Name
	
	/*Semester informations*/
	,cast(cast(YEAR ([Date]) AS varchar(4)) + '0' + cast(Ceiling(Month([Date])/6.0)as varchar(1)) +'01' as datetime) AS CAL_Semester_Datetime
	,Ceiling(Month([Date])/6.0) AS CAL_SemesterName
	
	/*Trimester informations*/
	,CAST(cast(YEAR ([Date]) AS varchar(4))+right('0'+cast(((DatePart ( qq, [Date])-1)*3)+1 AS varchar(2)),2)+'01' as datetime) AS CAL_Trimester_Datetime
	,DatePart (qq, [Date])  AS CAL_Trimester_Name
	
	/*Month informations*/
	,CAST(cast(YEAR ([Date]) AS varchar(4))+right('0'+cast(MONTH ([Date]) AS varchar(2)),2)+'01' as datetime) AS CAL_Month_Datetime
	,MONTH ([Date]) AS CAL_Month_Number_Year
	,DateDiff(mm,DateAdd(qq,DateDiff(qq,0,date),0),[Date])+1  AS CAL_Month_Number_Of_Trimester
	,DateName (mm, [Date]) AS CAL_Month_Name_FR
	,LEFT( DateName (mm, [Date]), 3) AS CAL_Month_Name_Abbreviation_FR
	
	/*Week informations*/
	,DATEADD(DD, 1 - DATEPART(DW, [Date]), [Date]) AS CAL_Week_Datetime
	,DatePart (wk, Date) AS CAL_Week_Number_Of_Year
	,datediff(wk,dateadd(qq,datediff(qq,0,[Date]),0),[Date])+1 AS CAL_Week_Number_Of_Trimester
	,datediff(wk,dateadd(mm,datediff(mm,0,[Date]),0),[Date])+1 AS CAL_Week_Number_Of_Month
	
	/*Day informations*/
	,DatePart (dy, date) AS CAL_Day_Number_Of_Year 
	,datediff(dd,dateadd(qq,datediff(qq,0,[Date]),0),[Date])+1 AS CAL_Day_Number_Of_Trimester
	,DAY ([Date])  AS CAL_Day_Number_Of_Month
	,DatePart (dw, [Date]) AS CAL_Day_Number_Of_Week
	,DateName (dw, [Date]) AS CAL_Day_Name_FR
	,LEFT(DateName (dw, [Date]), 3) AS CAL_Day_Name_Abbreviation_FR

	FROM cte_calendar
	OPTION	(MAXRECURSION 0)

