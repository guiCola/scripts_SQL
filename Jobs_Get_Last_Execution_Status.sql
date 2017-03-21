/*Return status of last execution for a specific Agent Job
- 0 = Failed
- 1 = Succès
- 2 = Reprise
- 3 = Manualy Stop
- NULL = job is running
*/

USE [msdb]

DECLARE @jobName AS VARCHAR(20)
SET @jobName = 'myJobName'

SELECT top 1 histo.run_status		
FROM dbo.sysjobhistory histo
	INNER JOIN dbo.sysjobs job ON job.job_id = histo.job_id AND job.name = @jobName
WHERE histo.step_id  = 0
AND NOT EXISTS (SELECT 1 
				FROM msdb.dbo.sysjobactivity sja 
				WHERE sja.job_id = job.job_id 
				AND sja.start_execution_date IS NOT NULL
   AND sja.stop_execution_date IS NULL)
ORDER BY msdb.dbo.agent_datetime(run_date, run_time) DESC