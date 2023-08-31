/*
Mod 05 Lab A
Create logins for a SQL instance
*/

---------- Module 5 Lab A Execise 1 Step 5
SELECT 
	CASE SERVERPROPERTY('IsIntegratedSecurityOnly')   
		WHEN 1 THEN 'Windows Authentication'   
		WHEN 0 THEN 'Windows and SQL Server Authentication'   
		END as [Authentication Mode] 

---------- Module 5 Lab A Execise 2 Step 3
USE [Master]
GO

SELECT pr.name, pr.principal_id, pr.type_desc, 
		iif(pr.is_disabled=1,'Yes','No') as is_disabled, 
		iif(pe.state='G','No','Yes') as is_denied_access
FROM sys.server_principals AS pr   
JOIN sys.server_permissions AS pe   
    ON pe.grantee_principal_id = pr.principal_id
		AND pe.permission_name = 'CONNECT SQL'

---------- Module 5 Lab A Execise 2 Step 4
CREATE LOGIN [SQL\BBenson] FROM WINDOWS;
CREATE LOGIN [SQL\CCarlson] FROM WINDOWS;
CREATE LOGIN [SQL\DDonaldson] FROM WINDOWS;
CREATE LOGIN [SQL\EErikson] FROM WINDOWS;
CREATE LOGIN [SQL\XXavier] FROM WINDOWS;
GO

---------- Module 5 Lab A Execise 2 Step 6
DENY CONNECT SQL TO [SQL\XXavier]
ALTER LOGIN [SQL\XXavier] DISABLE
GO

---------- Module 5 Lab A Execise 3 Step 3
CREATE LOGIN [GGalway] WITH PASSWORD = 'Pa55w.rd'
CREATE LOGIN [HHolmes] WITH PASSWORD = 'Pa55w.rd'

---------- Module 5 Lab A Execise 3 Step 4
SELECT pr.name, pr.principal_id, pr.type_desc, 
		iif(pr.is_disabled=1,'Yes','No') as is_disabled, 
		iif(pe.state='G','No','Yes') as is_denied_access
FROM sys.server_principals AS pr   
JOIN sys.server_permissions AS pe   
    ON pe.grantee_principal_id = pr.principal_id
		AND pe.permission_name = 'CONNECT SQL'

