# SQL Server Query Execution Alert Script 

## This is a stored procedure that monitore and send alerts using sp_send_dbmail for queries that been runing for more than 10 minutes.

## Use 
* Open SSMS and connect to your SQL Server instance 
* Run the script in the provide [sp_AuditProcedureQuery.sql](sp_AuditProcedureQuery.sql) file in your database. The script will create a stored procedure with sp_AuditProcedureQuery object name;
* Settings for send email:
   - At the end of the script, will be necessary update the name of sysmail user according to your user configurate;
   - Update the @recipients variable with your recipients;
* After procedure is created, in another file run [script-create-job.sql](script-create-job.sql) to create your SQL Server Agent Job to program your routine; 

## Notes 
* The script uses temp tables to process and store data;
* Run the script in a controlled environment before execute in your database production;
* Remember to customize the information in body content according to your preference and in case that you include more columns in tempdb #LOG;
* If necessary, alter the column TEXT from #LOG, adjusting according from your needs, using replace, ltrim...;
* Change the schedule of the job you create according to your routine; 

## License 
This script is provided under the [MIT LICENSE](LICENSE).


