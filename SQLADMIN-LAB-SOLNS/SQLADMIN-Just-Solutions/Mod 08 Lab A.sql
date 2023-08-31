/*
Mod 08 Lab A
Row and column security
*/

---------- Module 8 Lab A Exercise 1 Step 4
CREATE DATABASE Mod08LabA ON PRIMARY
	(NAME = 'Mod08LabADB',
	FILENAME = 'F:\Mod08LabA.mdf',	
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod08LabALog',
	FILENAME = 'G:\Mod08LabA.ldf',	
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

---------- Module 8 Lab A Exercise 1 Step 5
CREATE LOGIN Sales1 WITH PASSWORD = 'Pa55w.rd'
CREATE LOGIN Sales2 WITH PASSWORD = 'Pa55w.rd'
CREATE LOGIN SalesManager WITH PASSWORD = 'Pa55w.rd'
GO

---------- Module 8 Lab A Exercise 1 Step 6
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

---------- Module 8 Lab A Exercise 1 Step 7
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

---------- Module 8 Lab A Exercise 1 Step 8
INSERT INTO Sales.Customers VALUES
	(1,'Ian Brew','Drinks Co','4-High','Sales1',3400000,'ian.brew@drinksco.co.uk','01801 463543'),
	(2,'Woody Stoke','The Surgery Ltd','3-Medium','Sales2',400000,'wstoke@surgery.com','01802 123245'),
	(3,'R.A. Thomas','Southern Ventures','2-Low','Sales1',30000,'rathomas@sventures.co.uk','01589 892114'),
	(4,'T. Brewing','Retee','1-Very Low','Sales2',500,'tom_brewing@retee.eu.com','01589 123123')
SELECT * FROM Sales.Customers
GO

---------- Module 8 Lab A Exercise 1 Step 9
GRANT SELECT ON SCHEMA::Sales TO SalesTeam
GO

---------- Module 8 Lab A Exercise 1 Step 10
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

---------- Module 8 Lab A Exercise 2 Step 2
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

---------- Module 8 Lab A Exercise 2 Step 3
CREATE SECURITY POLICY SalesFilter
	ADD FILTER PREDICATE dbo.SecureRLSCustomers(SalesPerson)
	ON Sales.Customers
	WITH (STATE = ON);
GO

---------- Module 8 Lab A Exercise 2 Step 4
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

---------- Module 8 Lab A Exercise 3 Step 2
ALTER TABLE Sales.Customers
	ALTER COLUMN CustomerIncome ADD MASKED WITH (FUNCTION = 'default()')
ALTER TABLE Sales.Customers
	ALTER COLUMN EmailAddress ADD MASKED WITH (FUNCTION = 'email()')
ALTER TABLE Sales.Customers
	ALTER COLUMN Phone ADD MASKED WITH (FUNCTION = 'partial(0,"XXXXX XX",4)');
GO

---------- Module 8 Lab A Exercise 3 Step 3
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

---------- Module 8 Lab A Exercise 3 Step 5
GRANT UNMASK TO SalesManager
GO

---------- Module 8 Lab A Exercise 3 Step 5
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





