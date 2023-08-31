CREATE DATABASE Mod07LabA ON PRIMARY
	(NAME = 'Mod07LabADB',
	--FILENAME = 'F:\Mod07LabA.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod07LabA.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod07LabALog',
	--FILENAME = 'G:\Mod07LabA.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod07LabA.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

CREATE LOGIN LimitedWebViewer WITH PASSWORD ='Pa55w.rd'
CREATE LOGIN LimitedUpdater WITH PASSWORD ='Pa55w.rd'

USE Mod07LabA
GO
CREATE USER LimitedWebViewer
CREATE USER LimitedUpdater
GO

-- 2. Add a table and some data that needs protection
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


--- default permissions = None
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

--- assign DENY permissions
DENY SELECT,INSERT,DELETE,UPDATE ON dbo.Customers TO LimitedWebViewer
DENY SELECT,INSERT,DELETE,UPDATE ON dbo.Customers TO LimitedUpdater

EXECUTE AS USER = 'LimitedWebViewer'
	SELECT * FROM dbo.Customers
REVERT
GO

EXECUTE AS USER = 'LimitedUpdater'
	SELECT * FROM dbo.Customers
REVERT
GO

--- create view for limited data access
CREATE VIEW dbo.LimitedData AS
	SELECT CustomerName,CompanyName,Phone
	FROM dbo.Customers
GO

GRANT SELECT ON dbo.LimitedData TO LimitedWebViewer
GRANT SELECT ON dbo.LimitedData TO LimitedUpdater
GO

EXECUTE AS USER = 'LimitedWebViewer'
	SELECT * FROM dbo.LimitedData 
REVERT
GO

EXECUTE AS USER = 'LimitedUpdater'
	SELECT * FROM dbo.LimitedData 
REVERT
GO

--- create view for limited data access
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

GRANT EXECUTE ON dbo.UpdateCustomerName TO LimitedUpdater
GO

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

SELECT * FROM dbo.Customers
GO

-- 
USE MASTER
DROP DATABASE Mod07LabA
DROP LOGIN LimitedWebViewer
DROP LOGIN LimitedUpdater