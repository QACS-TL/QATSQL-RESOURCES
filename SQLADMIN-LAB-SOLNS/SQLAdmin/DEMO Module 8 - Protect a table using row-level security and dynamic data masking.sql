/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 8 - Data Security and Auditing

Demonstration - Protect a table using row-level security and dynamic data masking
*/

/*
	STEP 1 - Create logins for the demo
	***********************************
*/

USE master;
CREATE LOGIN TestA WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

CREATE LOGIN TestB WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

CREATE LOGIN TestC WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO


/*
	STEP 2 - Create a database and table for the demo
	*************************************************
*/

CREATE DATABASE RLSDemo;
GO
USE RLSDemo;
CREATE TABLE dbo.Sales
	(UserName	VARCHAR(50),
	Country		VARCHAR(50),
	Sales		INT);

INSERT Sales VALUES 
	('TestA','USA',10000),
	('TestB','USA',9500),
	('TestC','France',9600),
	('TestA','Spain',9200),
	('TestB','Germany',9000);
GO

/*
	STEP 3 - Add users and grant access to the table
	************************************************
*/

USE RLSDemo;
CREATE USER TestA FOR LOGIN TestA;
CREATE USER TestB FOR LOGIN TestB;
CREATE USER TestC FOR LOGIN TestC;

GRANT SELECT ON Sales TO TestA;
GRANT SELECT ON Sales TO TestB;
GRANT SELECT ON Sales TO TestC;



/*
	STEP 4 - Test initial access before row-level security added
	************************************************************
*/

--The three queries below all return all rows from the table as the users have full SELECT permission against the table, and row-level security has yet to be implemented.

USE RLSDemo;
EXECUTE AS USER = 'TestA';
SELECT * FROM Sales;
REVERT

USE RLSDemo;
EXECUTE AS USER = 'Testb';
SELECT * FROM Sales;
REVERT

USE RLSDemo;
EXECUTE AS USER = 'TestC';
SELECT * FROM Sales;
REVERT



/*
	STEP 5 - Create the inline table-valued function and apply to the table
	***********************************************************************
*/

--The function will only show rows for the currently logged on user, apart from if the user is TestC - the sales manager - in which case all rows should be shown.

USE RLSDemo;
GO
CREATE FUNCTION dbo.fn_SalesSecurity (@UserName AS sysname)
	RETURNS TABLE
WITH SCHEMABINDING
AS
	RETURN SELECT 1 AS fn_SalesSecurity_Result
	WHERE @UserName = USER_NAME()
	OR USER_NAME() = 'TestC';
GO

CREATE SECURITY POLICY UserFilter
ADD FILTER PREDICATE dbo.fn_SalesSecurity(UserName) 
ON dbo.Sales
WITH (State = ON);
GO

/*
	STEP 6 - Retest
	***************
*/

--Each of the queries below now returns a different result.
--The first only returns the rows for the user called TestA.
--The second only returns the rows for the user called TestB.
--The third returns all rows as TestC is the sales manager so should see all data.

USE RLSDemo;
EXECUTE AS USER = 'TestA';
SELECT * FROM Sales;
REVERT

USE RLSDemo;
EXECUTE AS USER = 'Testb';
SELECT * FROM Sales;
REVERT

USE RLSDemo;
EXECUTE AS USER = 'TestC';
SELECT * FROM Sales;
REVERT

/*
	STEP 7 - RLS Demo cleanup
	*************************
*/

USE Master;
DROP DATABASE RLSDemo;
DROP LOGIN TestA;
DROP LOGIN TestB;
DROP LOGIN TestC;
GO

/*
	STEP 8 - Setup for masking demo
	*******************************
*/

--Create a database, a login, and a user for the login within the database.

USE Master;
GO
CREATE DATABASE MaskDemo;
GO
CREATE LOGIN MaskedUser WITH PASSWORD = N'Pa55w.rd', CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
USE MaskDemo;
CREATE USER MaskedUser FOR LOGIN MaskedUser;

--Create a table, grant the user access to the table, and populate the table with data.

CREATE TABLE dbo.Customers
	(CustomerID		INT	IDENTITY(1,1)	NOT NULL,
	CustomerName	VARCHAR(100)	NOT NULL,
	CustomerEmail	VARCHAR(200)	NOT NULL,
	CustomerPhone	VARCHAR(20)		NOT NULL,
	CustomerRating	TINYINT			NOT NULL);

GRANT SELECT ON dbo.Customers TO MaskedUser;

INSERT dbo.Customers VALUES
	('Alan Anderson','Alan@Anderson.co.uk','0161 123 4567',9),
	('Beryl Baker','Beryl@Baker.org','01253 987 6543',8),
	('Colin Cauliflower','Colin@Cauliflower.com','01204 654 3210',6),
	('Diane Danger','Diane@Danger.net','0131 678 1234',10);
go


/*
	STEP 9 - Initial test without masking
	*************************************
*/

--First of all, query the table as the admin user. 

USE MaskDemo;
SELECT * FROM dbo.customers;

--Look at the same table using the MaskedUser account and the same data is visible.

USE MaskDemo;
EXECUTE AS USER = 'MaskedUser';
SELECT * FROM dbo.Customers;
REVERT;

/*
	STEP 10 - Add data masks
	************************
*/

ALTER TABLE dbo.Customers
	ALTER COLUMN CustomerEmail ADD MASKED WITH (FUNCTION = 'email()');
ALTER TABLE dbo.Customers
	ALTER COLUMN CustomerPhone ADD MASKED WITH (FUNCTION = 'partial(3,"XXX",4)');
ALTER TABLE dbo.Customers
	ALTER COLUMN CustomerRating ADD MASKED WITH (FUNCTION = 'default()');
GO

/*
	STEP 11 - Retest
	****************
*/

--Run the two queries below in one go.
--The code will return two result sets...
--The first shows the table running as the admin user.  The masked data is visible.
--The second shows the table running as the MaskedUser user.  The final three columns are masked.

USE MaskDemo;
SELECT * FROM dbo.customers;
EXECUTE AS USER = 'MaskedUser';
SELECT * FROM dbo.Customers;
REVERT;

--Grant the MaskedUser account permission to see masked data.

USE MaskDemo;
GRANT UNMASK TO MaskedUser;

--Retest.  The user can now see all of the masked data.

EXECUTE AS USER = 'MaskedUser';
SELECT * FROM dbo.Customers;
REVERT;

/*
	Cleanup
	*******
*/

USE master;
DROP DATABASE MaskDemo;
DROP LOGIN MaskedUser;

