# SQL Server Query Execution Alert Script 

## This is a stored procedure that monitore and send alerts using sp_send_dbmail for queries that been runing for more than 10 minutes.

## Use 
1. Open SSMS and connect to your SQL Server instance 
2. Run the script in the provide @nome file in your database. The script will create a stored procedure with @nome name
3. Settings for send email:
   - At the end of the script, will be necessary update the name of sysmail user according to your user configurate;
   - Update the @recipients variable with your recipients;

## Notes 
1. The script uses temp tables to process and store data;
2. Run the script in a controlled environment before execute in your database production;
3. Remember to customize the information in body content according to your preference and in case that you include more columns in tempdb #LOG;

##License 
This script is provided under the [MIT LICENSE](License).


