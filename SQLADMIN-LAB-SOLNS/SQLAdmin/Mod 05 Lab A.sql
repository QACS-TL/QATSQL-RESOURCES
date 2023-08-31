

------ Review the security login options
SELECT 
	CASE SERVERPROPERTY('IsIntegratedSecurityOnly')   
		WHEN 1 THEN 'Windows Authentication'   
		WHEN 0 THEN 'Windows and SQL Server Authentication'   
		END as [Authentication Mode] 
	
USE [master]
GO

SELECT Name, LoginName, 
		iif(isntname=1,'Windows Login','SQL Login') as LoginType,
		isntuser, isntgroup, denylogin, *
	FROM sys.syslogins

SELECT *, name, principal_id, type_desc, is_disabled, is_fixed_role 
	FROM sys.server_principals
SELECT * FROM sys.sql_logins
GO

SELECT pr.name, pr.principal_id, pr.type_desc, 
		iif(pr.is_disabled=1,'Yes','No') as is_disabled, 
		iif(pe.state='G','No','Yes') as is_denied_access
FROM sys.server_principals AS pr   
JOIN sys.server_permissions AS pe   
    ON pe.grantee_principal_id = pr.principal_id
		AND pe.permission_name = 'CONNECT SQL'

------ Review the security login options
CREATE LOGIN [SQL\BBenson] FROM WINDOWS;
CREATE LOGIN [SQL\CCarlson] FROM WINDOWS;
CREATE LOGIN [SQL\DDonaldson] FROM WINDOWS;
CREATE LOGIN [SQL\EErikson] FROM WINDOWS;
CREATE LOGIN [SQL\Xavier] FROM WINDOWS;
GO

DENY CONNECT SQL TO [SQL\Xavier]
ALTER LOGIN [SQL\Xavier] DISABLE
GO

CREATE LOGIN [GGalway] WITH PASSWORD = 'Pa55w.rd'
CREATE LOGIN [HHolmes] WITH PASSWORD = 'Pa55w.rd'

SELECT pr.name, pr.principal_id, pr.type_desc, 
		iif(pr.is_disabled=1,'Yes','No') as is_disabled, 
		iif(pe.state='G','No','Yes') as is_denied_access
FROM sys.server_principals AS pr   
JOIN sys.server_permissions AS pe   
    ON pe.grantee_principal_id = pr.principal_id
		AND pe.permission_name = 'CONNECT SQL'

