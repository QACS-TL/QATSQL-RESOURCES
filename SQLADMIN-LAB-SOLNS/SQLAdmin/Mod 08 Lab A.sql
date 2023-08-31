-- 1. Create a new database

--- Create Mod08LabA database and create some salespeople (logins and users)
CREATE DATABASE Mod08LabA ON PRIMARY
	(NAME = 'Mod08LabADB',
	--FILENAME = 'F:\Mod08LabA.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod08LabA.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod08LabALog',
	--FILENAME = 'G:\Mod08LabA.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod08LabA.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

CREATE LOGIN Sales1 WITH PASSWORD = 'Pa55w.rd'
CREATE LOGIN Sales2 WITH PASSWORD = 'Pa55w.rd'
CREATE LOGIN SalesManager WITH PASSWORD = 'Pa55w.rd'
GO

USE Mod08LabA
GO

CREATE USER Sales1
CREATE USER Sales2
CREATE USER SalesManager

CREATE ROLE SalesTeam
ALTER ROLE SalesTeam ADD MEMBER Sales1
ALTER ROLE SalesTeam ADD MEMBER Sales2
ALTER ROLE SalesTeam ADD MEMBER SalesManager

GO

-- 2. Add a table and some data that needs protection
CREATE SCHEMA Sales AUTHORIZATION dbo
GO

CREATE TABLE Sales.Customers(
	CustomerID INT PRIMARY KEY,
	CustomerName VARCHAR(50),
	CompanyName VARCHAR(100),
	CustomerLevel VARCHAR(20),
	SalesPerson VARCHAR(50),
	CustomerIncome MONEY,
	EmailAddress VARCHAR(100),
	Phone VARCHAR(20)
)
GO

INSERT INTO Sales.Customers VALUES
	(1,'Ian Brew','Drinks Co','4-High','Sales1',3400000,'ian.brew@drinksco.co.uk','01801 463543'),
	(2,'Woody Stoke','The Surgery Ltd','3-Medium','Sales2',400000,'wstoke@surgery.com','01802 123245'),
	(3,'R.A. Thomas','Southern Ventures','2-Low','Sales1',30000,'rathomas@sventures.co.uk','01589 892114'),
	(4,'T. Brewing','Retee','1-Very Low','Sales2',500,'tom_brewing@retee.eu.com','01589 123123')
SELECT * FROM Sales.Customers
GO

GRANT SELECT ON SCHEMA::Sales TO SalesTeam
GO

------------------------- Test 1 - Unprotected
EXECUTE AS User = 'Sales1'
SELECT * FROM Sales.Customers
REVERT

EXECUTE AS User = 'Sales2'
SELECT * FROM Sales.Customers
REVERT
GO

EXECUTE AS User = 'SalesManager'
SELECT * FROM Sales.Customers
REVERT
GO
-------------------------  Add row-level security
CREATE FUNCTION dbo.SecureRLSCustomers(@AssignedTo VARCHAR(50))
	RETURNS TABLE
	WITH SCHEMABINDING
AS
	RETURN (
		SELECT 1 AS SecurityResult
			WHERE 
			(@AssignedTo = USER_NAME()) 
			OR (USER_NAME() = 'dbo')
			OR (USER_NAME() = 'SalesManager')
	)
GO

CREATE SECURITY POLICY SalesFilter
	ADD FILTER PREDICATE dbo.SecureRLSCustomers(SalesPerson)
	ON Sales.Customers
	WITH (STATE = ON);
GO

------------------------- Test 1 - rows protected
-- as Sales Manager
EXECUTE AS User = 'SalesManager'
SELECT * FROM Sales.Customers
REVERT

EXECUTE AS User = 'Sales1'
SELECT * FROM Sales.Customers
REVERT

EXECUTE AS User = 'Sales2'
SELECT * FROM Sales.Customers
REVERT
GO

-------------------------  Add column-level security
ALTER TABLE Sales.Customers
	ALTER COLUMN CustomerIncome ADD MASKED WITH (FUNCTION = 'default()')
ALTER TABLE Sales.Customers
	ALTER COLUMN EmailAddress ADD MASKED WITH (FUNCTION = 'email()')
ALTER TABLE Sales.Customers
	ALTER COLUMN Phone ADD MASKED WITH (FUNCTION = 'partial(0,"XXXXX XX",4)');
GO

------------------------- Test 2 - columns protected
-- as db_owner
EXECUTE AS User = 'SalesManager'
SELECT * FROM Sales.Customers
REVERT

EXECUTE AS User = 'Sales1'
SELECT * FROM Sales.Customers
REVERT

EXECUTE AS User = 'Sales2'
SELECT * FROM Sales.Customers
REVERT
GO

-------------------------
GRANT UNMASK TO SalesManager
GO

------------------------- Test 2 - columns protected
-- as db_owner
EXECUTE AS User = 'SalesManager'
SELECT * FROM Sales.Customers
REVERT

EXECUTE AS User = 'Sales1'
SELECT * FROM Sales.Customers
REVERT

EXECUTE AS User = 'Sales2'
SELECT * FROM Sales.Customers
REVERT
GO

-------------------------- Clean Up
USE MASTER
DROP DATABASE Mod08LabA
DROP LOGIN Sales1
DROP LOGIN Sales2





