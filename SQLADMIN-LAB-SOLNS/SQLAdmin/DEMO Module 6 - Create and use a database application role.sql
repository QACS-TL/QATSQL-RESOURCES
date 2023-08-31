/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 6 - Server and database roles

Demonstration - Create and use a database application role
*/

/*
	STEP 1 - Create a login for the demo
	************************************
*/

USE master;
CREATE LOGIN Test6 WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

--Grant access to the AdventureWorks database

USE AdventureWorks;
CREATE USER Test6 FOR LOGIN Test6;


/*
	STEP 2 - Attempt to use database permissions while logged in as Test3
	*********************************************************************
*/

USE master;
EXECUTE AS LOGIN = 'Test6';

USE AdventureWorks;

--Display current context - "Login Name" column displays "Test5", "User Name" displays "Test5"

SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to create a table - this will fail as the user has no permission to select from the table.

SELECT * FROM HumanResources.Employee;

--Switch back to admin user

USE master;
REVERT;


/*
	STEP 3 - Create an application role for the demo
	************************************************
*/

USE AdventureWorks;
CREATE APPLICATION ROLE HRAccess WITH PASSWORD = 'Pa55w.rd';

--Grant permissions to the role

GRANT SELECT ON SCHEMA::HumanResources TO HRAccess;



/*
	STEP 4 - Test
	*************
*/

--Run all of the code below in one go!
--The code will impersonate the Test6 user and connect to the AdventureWorks database.
--It will then display the current execution context: "Test6" and "Test6".
--It will then create a variable to hold a cookie and will activate the application role.
--Then, it will the current execution context again, but this time the query returns "Test6" and "HRAccess".
--Next, it will query the HumanResources.Employee table, which will succeed.
--Then it will unset the role and return the execution context: "Test6" and "Test6" again.
--Finally, we switch back to the admin user ID.

USE master;
EXECUTE AS LOGIN = 'Test6';
use AdventureWorks;
SELECT 'BEFORE ROLE ACTIVATED' as 'Context as at:', SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';
DECLARE @Cookie VARBINARY(8000);
EXEC SP_SETAPPROLE 'HRAccess', 'Pa55w.rd', @fCreateCookie = true, @cookie = @cookie OUTPUT;
SELECT 'AFTER ROLE ACTIVATED' as 'Context as at:', SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';
SELECT * FROM HumanResources.Employee;
EXEC sp_unsetapprole @cookie = @cookie;
SELECT 'AFTER ROLE UNSET' as 'Context as at:', SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';
use master;
REVERT;




/*
	Cleanup
	*******
*/

USE AdventureWorks;
DROP APPLICATION ROLE HRAccess;
DROP USER Test6;
USE master;
DROP LOGIN Test6;

