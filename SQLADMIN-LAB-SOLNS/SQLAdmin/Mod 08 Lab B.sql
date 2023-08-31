-- 1. Create a new database

--- Create Mod08LabA database and create some salespeople (logins and users)
CREATE DATABASE Mod08LabB ON PRIMARY
	(NAME = 'Mod08LabBDA',
	--FILENAME = 'F:\Mod08LabB.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod08LabB.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod08LabBLog',
	--FILENAME = 'G:\Mod08LabB.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod08LabB.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

--------------- Create a sample table with data
USE Mod08LabB

CREATE TABLE dbo.Customers(
	CustomerID INT PRIMARY KEY,
	CustomerName VARCHAR(50),
	CompanyName VARCHAR(100),
	CustomerLevel VARCHAR(20),
	SalesPerson VARCHAR(50),
	CustomerIncome MONEY,
	EmailAddress VARCHAR(100),
	Phone VARCHAR(20),
	LastEditedBy VARCHAR(30) DEFAULT suser_sname()
)

ALTER TABLE dbo.Customers
	ADD
		[VALIDFROM] DATETIME2 GENERATED ALWAYS AS ROW START 
		NOT NULL DEFAULT '2022-01-01 00:00:00.0000000',
		[VALIDTO] DATETIME2 GENERATED ALWAYS AS ROW END 
		NOT NULL DEFAULT '9999-12-31 23:59:59.9999999',
		PERIOD FOR SYSTEM_TIME([VALIDFROM],[VALIDTO]);
GO
ALTER TABLE dbo.Customers
SET (SYSTEM_VERSIONING = ON 
(HISTORY_TABLE = dbo.HistoryCustomers))
GO

INSERT INTO dbo.Customers(CustomerID,CustomerName,CompanyName,CustomerLevel,
						SalesPerson, CustomerIncome, EmailAddress, Phone)  VALUES
	(1,'Ian Brew','Drinks Co','4-High','Sales1',3400000,'ian.brew@drinksco.co.uk','01801 463543'),
	(2,'Woody Stoke','The Surgery Ltd','3-Medium','Sales2',400000,'wstoke@surgery.com','01802 123245'),
	(3,'R.A. Thomas','Southern Ventures','2-Low','Sales1',30000,'rathomas@sventures.co.uk','01589 892114'),
	(4,'T. Brewing','Retee','1-Very Low','Sales2',500,'tom_brewing@retee.eu.com','01589 123123')

SELECT * FROM dbo.Customers
SELECT * FROM dbo.HistoryCustomers

------ Add user and grant permissions
CREATE LOGIN Liam_Lovett WITH PASSWORD = 'Pa55w.rd'
CREATE USER Liam_Lovett
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO Liam_Lovett
------ Make changes
EXECUTE AS USER='Liam_Lovett'
	INSERT INTO dbo.Customers(CustomerID,CustomerName,CompanyName,CustomerLevel,
							SalesPerson, CustomerIncome, EmailAddress, Phone)  VALUES
		(5,'Jack Jones','SnackJack','1-Very Low','Sales1',340,'jj@jacksnack.co.uk','02380 998765')
	UPDATE dbo.Customers SET CustomerLevel = '4-High' WHERE CustomerID = 2
	DELETE FROM dbo.Customers WHERE CustomerID = 3
REVERT

SELECT * FROM dbo.Customers
SELECT * FROM dbo.HistoryCustomers

SELECT * FROM dbo.Customers
	FOR SYSTEM_TIME ALL
	ORDER BY CustomerID, ValidTo
GO
-------------------------- Clean Up
USE MASTER
DROP DATABASE Mod08LabB
DROP LOGIN Liam_Lovett


