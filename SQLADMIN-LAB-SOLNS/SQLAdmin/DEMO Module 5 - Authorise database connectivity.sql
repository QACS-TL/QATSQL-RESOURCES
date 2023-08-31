/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 5 - SQL Server Authentication

Demonstration - Authorise database connectivity
*/

/*
	STEP 1 - Create a login for the demo
	************************************
*/

USE master;
CREATE LOGIN Test1 WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

/*
	STEP 2 - Attempt to connect to the AdventureWorks database as Test1
	*******************************************************************
*/

EXECUTE AS LOGIN = 'Test1';

--Display current context - "Login Name" column displays "Test1", "User Name" displays "guest"

SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to connect to the AdventureWorks database - this will fail as the user has no access to the database

USE AdventureWorks;

--Switch back to admin user

REVERT;




/*
	STEP 3 - Create a user account in AdventureWorks for Test1 login
	****************************************************************
*/

USE AdventureWorks;
CREATE USER Test1 FOR LOGIN Test1;
GO

USE master;
EXECUTE AS LOGIN = 'Test1';

--Display current context - "Login Name" column displays "Test1", "User Name" displays "guest"

SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to connect to the AdventureWorks database - this will now succeed as the user has access to the database

USE AdventureWorks;

--Display current context - "Login Name" column displays "Test1", "User Name" displays "Test1"

SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Switch back to admin user

USE master;
REVERT;

/*
	Cleanup
	*******
*/

USE adventureworks;
DROP USER Test1;
USE master;
DROP LOGIN Test1;
