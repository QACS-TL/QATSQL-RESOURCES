-- 1. Create a new database

--- Create Mod08LabD database
CREATE DATABASE Mod08LabE ON PRIMARY
	(NAME = 'Mod08LabEDB',
	--FILENAME = 'F:\Mod08LabE.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod08LabE.mdf',		
	SIZE = 10Mb, MaxSize = 100Mb, FileGrowth = 10Mb)
LOG ON
	(NAME = 'Mod08LabELog',
	--FILENAME = 'G:\Mod08LabE.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod08LabE.ldf',
	SIZE = 1Mb, MaxSize = 10mb, FileGrowth = 1Mb)
GO

USE Mod08LabE
GO

CREATE TABLE dbo.Customers(
	CustomerID INT PRIMARY KEY,
	CustomerName VARCHAR(50),
	CompanyName VARCHAR(100),
	AcctPassword VARCHAR(50) COLLATE Latin1_General_BIN2,
	CustomerIncome MONEY,
	EmailAddress VARCHAR(100),
	DOB DATE
)

INSERT INTO dbo.Customers VALUES
	(1,'Ian Brew','Drinks Co','passW0rd',3400000,'ian.brew@drinksco.co.uk','1973-09-07'),
	(2,'Woody Stoke','The Surgery Ltd','iAMATH0me',400000,'wstoke@surgery.com','1962-08-21'),
	(3,'R.A. Thomas','Southern Ventures','Pa55w.rd',30000,'rathomas@sventures.co.uk','1967-11-12'),
	(4,'T. Brewing','Retee','s3cuR3Pa55w00rd',100,'tom_brewing@retee.eu.com','1982-03-25')
GO

-- Without always encrypted columns
SELECT * FROM dbo.Customers
GO

DECLARE @FindCustomerID int = 4
DECLARE @FindPassword varchar(30) = 's3cuR3Pa55w00rd'
SELECT * FROM dbo.Customers
	WHERE CustomerID = @FindCustomerID 
		AND AcctPassword = @FindPassword
GO

DECLARE @FindDOB date = '1962-08-21'
SELECT * FROM dbo.Customers
	WHERE DOB = @FindDOB
GO

DECLARE @EarliestDate date = '1980-01-01'
SELECT * FROM dbo.Customers
	WHERE DOB >= @EarliestDate
GO

DECLARE @Income MONEY = 3400000
SELECT * FROM dbo.Customers
	WHERE CustomerIncome = @Income
GO

------ AE here

-- With always encrypted columns
SELECT name KeyName,
  column_master_key_id KeyID,
  key_store_provider_name KeyStore,
  key_path KeyPath
FROM sys.column_master_keys;

SELECT name KeyName,
  column_encryption_key_id KeyID
FROM sys.column_encryption_keys;

SELECT column_encryption_key_id ColumnKeyID,
  column_master_key_id MasterKeyID,
  encrypted_value EncryptValue,
  encryption_algorithm_name EncryptAlgorithm
FROM sys.column_encryption_key_values;


---- Retest the queries after encryption
USE Mod08LabE
GO

SELECT * FROM dbo.Customers
GO

DECLARE @FindCustomerID int = 4
DECLARE @FindPassword varchar(30) = 's3cuR3Pa55w00rd'
SELECT * FROM dbo.Customers
	WHERE CustomerID = @FindCustomerID 
		AND AcctPassword = @FindPassword
GO

DECLARE @FindDOB date = '1962-08-21'
SELECT * FROM dbo.Customers
	WHERE DOB = @FindDOB
GO

DECLARE @EarliestDate date = '1980-01-01'
SELECT * FROM dbo.Customers
	WHERE DOB >= @EarliestDate
GO

DECLARE @Income MONEY = 3400000
SELECT * FROM dbo.Customers
	WHERE CustomerIncome = @Income
GO

USE MASTER
DROP DATABASE Mod08LabE
