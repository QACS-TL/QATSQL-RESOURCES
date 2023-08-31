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
CREATE LOGIN Test8 WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

USE AdventureWorks;
CREATE USER Test8 FOR LOGIN Test8;
GO

/*
	STEP 2 - Create and test a stored procedure for the demonstration
	*****************************************************************
*/

USE AdventureWorks;
GO
CREATE PROCEDURE Production.ColourTotals AS
SELECT Color, SUM(ListPrice) AS TotalPrice
FROM Production.Product
GROUP BY Color
ORDER BY Color;
GO

/*
	STEP 3 - Attempt to use stored procedure permissions while logged in as Test7
	*****************************************************************************
*/

USE master;
EXECUTE AS LOGIN = 'Test8';

--Display current context - "Login Name" column displays "Test8", "User Name" displays "Test8"

USE AdventureWorks;
SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to execute the procedure - this will fail as the user has no permission to execute the procedure.

EXECUTE production.ColourTotals;

--Switch back to admin user

use master;
REVERT;


/*
	STEP 4 - Grant the Test8 user permission to execute the procedure
	*****************************************************************
*/

USE AdventureWorks;
GRANT EXECUTE ON Production.ColourTotals TO Test8;


/*
	STEP 5 - Retest
	***************
*/

USE master;
EXECUTE AS LOGIN = 'Test8';

--Display current context - "Login Name" column displays "Test8", "User Name" displays "Test8"

USE AdventureWorks;
SELECT SUSER_SNAME() AS 'Login Name', USER_NAME() AS 'User Name';

--Attempt to execute the procedure - this will now succeed as the user has permission to execute the procedure.

EXECUTE production.ColourTotals;

--Switch back to admin user

use master;
REVERT;

/*
	Cleanup
	*******
*/

USE AdventureWorks;
DROP USER Test8;
DROP PROCEDURE Production.ColourTotals;
USE master;
DROP LOGIN Test8;

