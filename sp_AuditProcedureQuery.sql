CREATE PROCEDURE [dbo].[sp_AuditProcedureQuery] AS 


/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::

DEVELOPED BY ANDRE SILVEIRA - 2023-08-02 11:34:14.153

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ATUALIZAÇÕES>
				USER:
				DATE:
				DESCRIPTION:

:::::::::::::::::::::::::::::::::::::::::::::::::*/


/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/*::Returns information of requests in execution in sql server(r); also returns too the text of sql batch(sql handle,st) and processes(sp) ::*/
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/


BEGIN
SET NOCOUNT ON; 


IF OBJECT_ID('TEMPDB.DBO.#LOG','U') IS NOT NULL 
DROP TABLE #LOG

SELECT
DISTINCT 

	  ID		= R.SESSION_ID 
	, CMD		= R.COMMAND 
	, [LOGIN]	= SP.LOGINAME
	, [TEXT]	= LEFT(LTRIM(ST.TEXT),75) 

INTO #LOG
FROM	SYS.DM_EXEC_REQUESTS R WITH(NOLOCK)
CROSS APPLY
		SYS.DM_EXEC_SQL_TEXT(R.SQL_HANDLE) ST  
JOIN 
		SYS.SYSPROCESSES SP WITH(NOLOCK)
ON
	  R.SESSION_ID = SP.SPID
WHERE
	  R.STATUS IN ('RUNNING','SUSPENDED')
AND
	  R.TOTAL_ELAPSED_TIME >= 600000
AND
	  LOGINAME <> ''
	  


/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/*::  Case exists data in tempdb #log, will run the sp_send_dbmail containing the description of alert of #log to the destination e-mail  ::*/
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/


IF (SELECT COUNT(1) FROM #LOG) > 0
BEGIN 

	DECLARE @HTML VARCHAR(MAX);  
 

	SET @HTML = '
	<html>
	<head>
		<title>Automatic e-mail, please do not reply.</title>
		<style type="text/css">
			table { padding:0; border-spacing: 0; border-collapse: collapse; }
			thead { background: #565656; border: 1px solid #ddd; }
			th { padding: 10px; font-weight: bold; border: 1px solid #000; color: #d96300; }
			tr { padding: 0; }
			td { padding: 5px; border: 1px solid #cacaca; margin:0; text-align: center; }
		</style>
	</head>
 
	<h2>Queries running for more than 10 minutes.</h2>
	Automatic e-mail, please do not reply.<br/><br/>
 
	<table>
		<thead>
			<tr>
				<th>ID</th>
				<th>CMD</th>
				<th>LOGIN</th>
				<th>TEXT</th>
			</tr>
		</thead>
    
		<tbody>' +  
		CAST ( 
		(
	SELECT
				td = ID, '',
				td = CMD, '',
				td = LOGIN, '', 
				td = text

	FROM #LOG WITH(NOLOCK)

			FOR XML PATH('tr'), TYPE
		) AS NVARCHAR(MAX) ) + '
		</tbody>
	</table>
 
	<br/><br/>
	In case of doubt, please contact ssilveira.andre@outlook.com<br/><br/>
	Best regards,<br/>
	 '
	;

 

	EXEC MSDB.DBO.SP_SEND_DBMAIL
			@PROFILE_NAME = '@your-user-here', 
			@RECIPIENTS = '@your-email-here',
			@SUBJECT = N'Alert - Queries > 10 min!', 
			@BODY = @HTML, 
			@BODY_FORMAT = 'HTML'


END;
END;
