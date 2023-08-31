/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 7 - Database Object Security

Demonstration - Use schemas to control object separation and permissions
*/

/*
	STEP 1 - Create a login for the demo
	************************************
*/

USE master;
CREATE LOGIN Test9 WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

USE AdventureWorks;
CREATE USER Test9 FOR LOGIN Test9;
GO

/*
	STEP 2 - Attempt to use schema permissions while logged in as Test9
	*******************************************************************
*/

USE master;
EXECUTE AS LOGIN = 'Test9';

--Display current context - "Login Name" column displays "Test9", "User Name" displays "Test9"

USE AdventureWorks;
SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to select from a table - this will fail as the user has no permission to select from the table or the schema that contains it.

SELECT * FROM Production.Product;

--Switch back to admin user

use master;
REVERT;


/*
	STEP 3 - Grant the Test9 user permission to select from the Production schema
	*****************************************************************************
*/

USE AdventureWorks;
GRANT SELECT ON SCHEMA::Production TO Test9;


/*
	STEP 4 - Retest
	***************
*/

USE master;
EXECUTE AS LOGIN = 'Test9';

--Display current context - "Login Name" column displays "Test9", "User Name" displays "Test9"

USE AdventureWorks;
SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to select from a table - this will now succeed as the user has no permission to select from the schema that contains it, so the permission cascades down to its contents.

SELECT * FROM Production.Product;

--Try to select from another table in the same schema.  This will also succeed.

SELECT * FROM Production.ProductCategory;

--Try to select from a table in a different schema.  This will fail.

SELECT * FROM Sales.SalesOrderHeader;

--Switch back to admin user

use master;
REVERT;

/*
	STEP 5 - Investigate overriding permissions
	*******************************************
*/

--Previously, the Test9 user was able to access any table in the Production schema.  If there are some objects in a schema that you do not want a user to be able to access you can DENY their access to them. A DENY on an object in a schema will override a GRANT on the schema, meaning that the denied objects are inaccessible to the user whilst the rest remain available.

--Deny Test9 access to the Production.ProductCategory table

USE AdventureWorks;
DENY SELECT ON Production.ProductCategory TO Test9;

--Retest access.

USE master;
EXECUTE AS LOGIN = 'Test9';

--Display current context - "Login Name" column displays "Test9", "User Name" displays "Test9"

USE AdventureWorks;
SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to select from a table - this will now succeed as the user has no permission to select from the schema that contains it, so the permission cascades down to its contents.

SELECT * FROM Production.Product;

--Try to select from another table in the same schema.  This will now fail as the user has been denied select permission on this table.

SELECT * FROM Production.ProductCategory;

--Try to select from a different table in the schema.  This should succeed.

SELECT * FROM Production.Location;

--Switch back to admin user

use master;
REVERT;


/*
	Cleanup
	*******
*/

USE AdventureWorks;
DROP USER Test9;
USE master;
DROP LOGIN Test9;

