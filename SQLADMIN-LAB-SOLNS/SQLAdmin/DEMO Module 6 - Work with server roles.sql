/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 6 - Server and database roles

Demonstration - Work with server roles
*/

/*
	STEP 1 - Create a login for the demo
	************************************
*/

USE master;
CREATE LOGIN Test3 WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

/*
	STEP 2 - Attempt to use server permissions while logged in as Test3
	*******************************************************************
*/

USE master;
EXECUTE AS LOGIN = 'Test3';

--Display current context - "Login Name" column displays "Test3", "User Name" displays "guest"

SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to create a database - this will fail as the user has no permission to create databases.

CREATE DATABASE Test3DB;

--Attempt to create a login - this will fail as the user has no permission to create logins.

CREATE LOGIN Test3a WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;

--Switch back to admin user

REVERT;


/*
	STEP 3 - Create a server role for the demo
	******************************************
*/

USE master;
CREATE SERVER ROLE DatabaseAndLoginCreator;

--Grant permissions to the role

GRANT CREATE ANY DATABASE TO DatabaseAndLoginCreator;
GRANT ALTER ANY LOGIN TO DatabaseAndLoginCreator;

--Add Test3 to the role.

ALTER SERVER ROLE DatabaseAndLoginCreator ADD MEMBER Test3;


/*
	STEP 4 - Retest
	***************
*/

USE master;
EXECUTE AS LOGIN = 'Test3';

--Display current context - "Login Name" column displays "Test3", "User Name" displays "guest"

SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to create a database - this will fail as the user has no permission to create databases.

CREATE DATABASE Test3DB;

--Attempt to create a login - this will fail as the user has no permission to create logins.

CREATE LOGIN Test3a WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;

--Switch back to admin user

REVERT;

/*
	Cleanup
	*******
*/

USE master;
DROP DATABASE Test3DB;
DROP LOGIN Test3a;
ALTER SERVER ROLE DatabaseAndLoginCreator DROP MEMBER Test3;
DROP SERVER ROLE DatabaseAndLoginCreator;
DROP LOGIN Test3;

