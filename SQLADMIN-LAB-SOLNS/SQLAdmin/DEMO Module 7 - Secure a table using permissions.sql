/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 7 - Database Object Security

Demonstration - Secure a table using permissions
*/

/*
	STEP 1 - Create a login for the demo
	************************************
*/

USE master;
CREATE LOGIN Test7 WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

USE AdventureWorks;
CREATE USER Test7 FOR LOGIN Test7;
GO

/*
	STEP 2 - Attempt to use table permissions while logged in as Test7
	******************************************************************
*/

USE master;
EXECUTE AS LOGIN = 'Test7';

--Display current context - "Login Name" column displays "Test7", "User Name" displays "Test7"

USE AdventureWorks;
SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to select from a table - this will fail as the user has no permission to select from the table.

SELECT * FROM Production.Product;

--Switch back to admin user

use master;
REVERT;


/*
	STEP 3 - Grant the Test7 user permission to select from the Production.Product table
	************************************************************************************
*/

USE AdventureWorks;
GRANT SELECT ON Production.Product TO Test7;


/*
	STEP 4 - Retest
	***************
*/

USE master;
EXECUTE AS LOGIN = 'Test7';

--Display current context - "Login Name" column displays "Test7", "User Name" displays "Test7"

USE AdventureWorks;
SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to select from a table - this will now succeed as the user has permission to select from the table.

SELECT * FROM Production.Product;

--Try to select from a different table.  This will fail as the user has not been given permission to select from the table.

SELECT * FROM Sales.SalesOrderHeader;

--Switch back to admin user

use master;
REVERT;

/*
	Cleanup
	*******
*/

USE AdventureWorks;
DROP USER Test7;
USE master;
DROP LOGIN Test7;

