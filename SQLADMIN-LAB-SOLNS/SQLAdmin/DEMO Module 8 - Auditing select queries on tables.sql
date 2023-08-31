/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 8 - Data security and Auditing

Demonstration - Auditing select queries on tables

*/

/*
	STEP 1 - Create a login for the demo
	************************************
*/

USE master;
CREATE LOGIN Test11 WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

--Grant access to the AdventureWorks database

USE AdventureWorks;
CREATE USER Test11 FOR LOGIN Test11;
GO

--Add Test11 user to the db_datareader role

ALTER ROLE db_datareader ADD MEMBER Test11;
GO

select * from HumanResources.Employee

/*
	STEP 2 - Create a server audit
	******************************
*/

USE master;
GO

CREATE SERVER AUDIT AuditDemo
TO FILE
(	
	FILEPATH = 'E:\Audits\',
	MAXSIZE = 100MB,
	MAX_FILES = 5,
	RESERVE_DISK_SPACE = OFF
)
WITH 
(	
	QUEUE_DELAY = 1000,
	ON_FAILURE = CONTINUE
)
;

ALTER SERVER AUDIT AuditDemo
WITH (STATE = ON);
GO



/*
	STEP 3 - Create a database audit specification
	**********************************************
*/

USE AdventureWorks;
CREATE DATABASE AUDIT SPECIFICATION HRAudit
FOR SERVER AUDIT AuditDemo
ADD (SELECT ON SCHEMA::HumanResources BY Public)
WITH (STATE = ON);
GO


/*
	STEP 4 - Test
	*************
*/

--Running as the Test11 user, perform two select queries against objects in different schemas.

USE AdventureWorks;
EXECUTE AS USER = 'Test11';
SELECT * FROM HumanResources.Employee;
SELECT * FROM Production.Product;
REVERT;


/*
	STEP 5 - Examine the audit history
	**********************************
*/

--Execute the following to view the audit log.
--Note that there are two entries:
--	An AUSC entry which was created when the audit was enabled.
--	An SL entry, which is the select statement performed against the HumanResources.Employee table.
--The select against the Production.Product table was not audited as the database audit specification was set to only monitor selects against objects in the HumanResources schema.

SELECT * FROM sys.fn_get_audit_file('E:\Audits\*.sqlaudit',NULL,NULL);
GO


/*
	Cleanup
	*******
*/

USE master;
ALTER SERVER AUDIT AuditDemo WITH (STATE = OFF);
DROP SERVER AUDIT AuditDemo;
USE adventureworks;
ALTER DATABASE AUDIT SPECIFICATION HRAudit WITH (STATE = OFF);
DROP DATABASE AUDIT SPECIFICATION HRAudit;
DROP USER Test11;
USE master;
DROP LOGIN Test11;
