/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 6 - Server and database roles

Demonstration - Use a fixed database role
*/

/*
	STEP 1 - Create a login for the demo
	************************************
*/

USE master;
CREATE LOGIN Test4 WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

--Grant access to the AdventureWorks database

USE AdventureWorks;
CREATE USER Test4 FOR LOGIN Test4;

/*
	STEP 2 - Attempt to backup the AdventureWorks database while logged in as Test4
	*******************************************************************************
*/

EXECUTE AS LOGIN = 'Test4';

--Display current context - "Login Name" column displays "Test1", "User Name" displays "guest"

SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to backup the AdventureWorks database - this will fail as the user does not have permission to backup the database

BACKUP DATABASE AdventureWorks TO DISK = 'H:\AdventureWorks-Test4 Backup.bak' WITH COPY_ONLY;

--Switch back to admin user

REVERT;




/*
	STEP 3 - Add the Test4 user to the db_backupoperator role
	*********************************************************
*/

USE AdventureWorks;
ALTER ROLE db_backupoperator ADD MEMBER Test4;
GO

/*
	STEP 4 - Retest
	***************
*/

EXECUTE AS LOGIN = 'Test4';

--Display current context - "Login Name" column displays "Test1", "User Name" displays "guest"

SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to backup the AdventureWorks database - this will succeed as the user now has permission to backup the database

BACKUP DATABASE AdventureWorks TO DISK = 'H:\AdventureWorks-Test4 Backup.bak' WITH COPY_ONLY;

--Switch back to admin user

REVERT;


/*
	Cleanup
	*******
*/

USE adventureworks;
ALTER ROLE db_backupoperator DROP MEMBER Test4;
DROP USER Test4;
USE master;
DROP LOGIN Test4;
