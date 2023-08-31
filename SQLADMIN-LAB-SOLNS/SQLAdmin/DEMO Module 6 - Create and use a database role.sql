/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 6 - Server and database roles

Demonstration - Create and use a database role
*/

/*
	STEP 1 - Create a login for the demo
	************************************
*/

USE master;
CREATE LOGIN Test5 WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

--Grant access to the AdventureWorks database

USE AdventureWorks;
CREATE USER Test5 FOR LOGIN Test5;


/*
	STEP 2 - Attempt to use database permissions while logged in as Test3
	*********************************************************************
*/

USE master;
EXECUTE AS LOGIN = 'Test5';

USE AdventureWorks;

--Display current context - "Login Name" column displays "Test5", "User Name" displays "Test5"

SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to create a table - this will fail as the user has no permission to create tables.

CREATE TABLE Test5Table (ID INT, SomeText VARCHAR(20));

--Attempt to backup the database - this will fail as the user has no permission to backup the database.

BACKUP DATABASE AdventureWorks TO DISK = 'H:\AdventureWorksTest5.bak' WITH COPY_ONLY;

--Switch back to admin user

USE master;
REVERT;


/*
	STEP 3 - Create a database role for the demo
	********************************************
*/

USE AdventureWorks;
CREATE ROLE TableCreator;

--Grant permissions to the role

GRANT CREATE TABLE TO TableCreator;
GRANT ALTER ON SCHEMA::dbo TO TableCreator;

--Add Test5 to the role.

ALTER ROLE TableCreator ADD MEMBER Test5;


/*
	STEP 4 - Retest
	***************
*/

USE master;
EXECUTE AS LOGIN = 'Test5';

USE AdventureWorks;

--Display current context - "Login Name" column displays "Test5", "User Name" displays "Test5"

SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to create a table - this will succeed as the user has permission to create tables and alter the DBO schema.

CREATE TABLE Test5Table (ID INT, SomeText VARCHAR(20));

--Attempt to backup the database - this will fail as the user has no permission to backup the database.

BACKUP DATABASE AdventureWorks TO DISK = 'H:\AdventureWorksTest5.bak' WITH COPY_ONLY;

--Switch back to admin user

USE master;
REVERT;

/*
	Cleanup
	*******
*/

USE AdventureWorks;
ALTER ROLE TableCreator DROP MEMBER Test5;
DROP ROLE TableCreator;
DROP TABLE Test5Table;
DROP USER Test5;
USE master;
DROP LOGIN Test5;

