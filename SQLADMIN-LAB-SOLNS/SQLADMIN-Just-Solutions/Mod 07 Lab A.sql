/*
Mod 07 Lab A
Securing database objects
*/

---------- Module 7 Lab A Execise 1 Step 4
CREATE DATABASE Mod07LabA ON PRIMARY
	(NAME = 'Mod07LabADB',
	FILENAME = 'F:\Mod07LabA.mdf',	
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod07LabALog',
	FILENAME = 'G:\Mod07LabA.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

---------- Module 7 Lab A Execise 1 Step 5
CREATE LOGIN LimitedWebViewer WITH PASSWORD ='Pa55w.rd'
CREATE LOGIN LimitedUpdater WITH PASSWORD ='Pa55w.rd'

---------- Module 7 Lab A Execise 1 Step 6
USE Mod07LabA
GO
CREATE USER LimitedWebViewer
CREATE USER LimitedUpdater
GO

---------- Module 7 Lab A Execise 1 Step 7
CREATE TABLE dbo.Customers(
	CustomerID INT PRIMARY KEY,
	CustomerName VARCHAR(50),
	CompanyName VARCHAR(100),
	CustomerLevel VARCHAR(20),
	SalesPerson VARCHAR(50),
	CustomerIncome MONEY,
	EmailAddress VARCHAR(100),
	Phone VARCHAR(20)
)

INSERT INTO dbo.Customers VALUES
	(1,'Ian Brew','Drinks Co','4-High','Sales1',3400000,'ian.brew@drinksco.co.uk','01801 463543'),
	(2,'Woody Stoke','The Surgery Ltd','3-Medium','Sales2',400000,'wstoke@surgery.com','01802 123245'),
	(3,'R.A. Thomas','Southern Ventures','2-Low','Sales1',30000,'rathomas@sventures.co.uk','01589 892114'),
	(4,'T. Brewing','Retee','1-Very Low','Sales2',500,'tom_brewing@retee.eu.com','01589 123123')


---------- Module 7 Lab A Execise 2 Step 2
SELECT * FROM dbo.Customers
GO

EXECUTE AS USER = 'LimitedWebViewer'
	SELECT * FROM dbo.Customers
REVERT
GO

EXECUTE AS USER = 'LimitedUpdater'
	SELECT * FROM dbo.Customers
REVERT
GO

---------- Module 7 Lab A Execise 2 Step 3
DENY SELECT,INSERT,DELETE,UPDATE ON dbo.Customers TO LimitedWebViewer
DENY SELECT,INSERT,DELETE,UPDATE ON dbo.Customers TO LimitedUpdater

---------- Module 7 Lab A Execise 2 Step 4
EXECUTE AS USER = 'LimitedWebViewer'
	SELECT * FROM dbo.Customers
REVERT
GO

EXECUTE AS USER = 'LimitedUpdater'
	SELECT * FROM dbo.Customers
REVERT
GO

---------- Module 7 Lab A Execise 3 Step 2
CREATE VIEW dbo.LimitedData AS
	SELECT CustomerName,CompanyName,Phone
	FROM dbo.Customers
GO

---------- Module 7 Lab A Execise 3 Step 3
GRANT SELECT ON dbo.LimitedData TO LimitedWebViewer
GRANT SELECT ON dbo.LimitedData TO LimitedUpdater
GO

---------- Module 7 Lab A Execise 3 Step 4
EXECUTE AS USER = 'LimitedWebViewer'
	SELECT * FROM dbo.LimitedData 
REVERT
GO

EXECUTE AS USER = 'LimitedUpdater'
	SELECT * FROM dbo.LimitedData 
REVERT
GO

---------- Module 7 Lab A Execise 4 Step 2
CREATE PROC dbo.UpdateCustomerName 
		@OldCustomerName VARCHAR(50),
		@NewCustomerName VARCHAR(50)
AS
	BEGIN
		IF (@NewCustomerName IS NULL OR @OldCustomerName IS NULL)
			THROW 90000,'Both parameters must be specified and not null',1
		ELSE
			UPDATE dbo.Customers
				SET CustomerName = @NewCustomerName
				WHERE CustomerName = @OldCustomerName
	END
GO

---------- Module 7 Lab A Execise 4 Step 3
GRANT EXECUTE ON dbo.UpdateCustomerName TO LimitedUpdater
GO

---------- Module 7 Lab A Execise 4 Step 4
EXECUTE AS USER = 'LimitedWebViewer'
	EXEC dbo.UpdateCustomerName 
		@OldCustomerName = 'Ian Brew',
		@NewCustomerName = 'Ian James Brew'
REVERT
GO

EXECUTE AS USER = 'LimitedUpdater'
	EXEC dbo.UpdateCustomerName 
		@OldCustomerName = 'T. Brewing',
		@NewCustomerName = 'Trevor Brewing'
REVERT
GO

---------- Module 7 Lab A Execise 4 Step 5
SELECT * FROM dbo.Customers
GO
