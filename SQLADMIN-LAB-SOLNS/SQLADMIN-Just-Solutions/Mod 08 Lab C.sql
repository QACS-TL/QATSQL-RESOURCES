/*
Mod 08 Lab C
Auditing table operations
*/

---------- Module 8 Lab C Exercise 1 Step 4
CREATE DATABASE Mod08LabC ON PRIMARY
	(NAME = 'Mod08LabCDB',
	FILENAME = 'F:\Mod08LabC.mdf',
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod08LabCLog',
	FILENAME = 'G:\Mod08LabC.ldf',	
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

---------- Module 8 Lab C Exercise 1 Step 5
CREATE LOGIN TestUserA WITH PASSWORD = 'Pa55w.rd'
CREATE LOGIN TestUserB WITH PASSWORD = 'Pa55w.rd'

USE Mod08LabC
GO

CREATE USER TestUserA
CREATE USER TestUserB
CREATE ROLE TestUsers
ALTER ROLE TestUsers ADD MEMBER TestUserA
ALTER ROLE TestUsers ADD MEMBER TestUserB
GO

GRANT INSERT, UPDATE, DELETE, SELECT ON SCHEMA::dbo TO TestUsers
GO

---------- Module 8 Lab C Exercise 2 Step 1
CREATE TABLE dbo.Customers(
	CustomerID INT PRIMARY KEY,
	CustomerName VARCHAR(50),
	CompanyName VARCHAR(100),
	CustomerLevel VARCHAR(20),
	SalesPerson VARCHAR(50),
	CustomerIncome MONEY,
	EmailAddress VARCHAR(100),
	Ethnicity VARCHAR(30),
	Phone VARCHAR(20)
)
GO

---------- Module 8 Lab C Exercise 3 Step 1
USE [Master]
GO

CREATE SERVER AUDIT [TableProtectionStore]
TO FILE 
(	FILEPATH = 'E:\Audits\'
	,MAXSIZE = 100 MB
	,MAX_FILES = 5
	,RESERVE_DISK_SPACE = OFF
) 
WITH (QUEUE_DELAY = 1000, 
	ON_FAILURE = CONTINUE
)
GO

---------- Module 8 Lab C Exercise 3 Step 2
ALTER SERVER AUDIT [TableProtectionStore] WITH (STATE = ON)
GO

---------- Module 8 Lab C Exercise 3 Step 4
USE Mod08LabC
CREATE DATABASE AUDIT SPECIFICATION [AuditDataChangesAndReading]
FOR SERVER AUDIT [TableProtectionStore]
ADD (DELETE ON OBJECT::[dbo].[Customers] BY [public]),
ADD (INSERT ON OBJECT::[dbo].[Customers] BY [public]),
ADD (SELECT ON OBJECT::[dbo].[Customers] BY [public]),
ADD (UPDATE ON OBJECT::[dbo].[Customers] BY [public])
WITH (STATE = ON)
GO

---------- Module 8 Lab C Exercise 4 Step 1
EXECUTE AS USER = 'TestUserA'
	INSERT INTO dbo.Customers(CustomerID,CustomerName,CompanyName,CustomerLevel,
							SalesPerson, CustomerIncome, EmailAddress, Phone)  VALUES
	(1,'Ian Brew','Drinks Co','4-High','Sales1',3400000,'ian.brew@drinksco.co.uk','01801 463543'),
	(2,'Woody Stoke','The Surgery Ltd','3-Medium','Sales2',400000,'wstoke@surgery.com','01802 123245'),
	(3,'R.A. Thomas','Southern Ventures','2-Low','Sales1',30000,'rathomas@sventures.co.uk','01589 892114'),
	(4,'T. Brewing','Retee','1-Very Low','Sales2',500,'tom_brewing@retee.eu.com','01589 123123')
	SELECT * FROM dbo.Customers
REVERT
GO

---------- Module 8 Lab C Exercise 4 Step 2
EXECUTE AS USER = 'TestUserB'
	INSERT INTO dbo.Customers(CustomerID,CustomerName,CompanyName,CustomerLevel,
							SalesPerson, CustomerIncome, EmailAddress, Phone)  VALUES
		(5,'Jack Jones','SnackJack','1-Very Low','Sales1',340,'jj@jacksnack.co.uk','08380 998765')
	UPDATE dbo.Customers SET CustomerLevel = '4-High' WHERE CustomerID = 2
	DELETE FROM dbo.Customers WHERE CustomerID = 3
	SELECT * FROM dbo.Customers WHERE CustomerLevel='4-High'
REVERT
GO

---------- Module 8 Lab C Exercise 5 Step 1
SELECT * FROM sys.fn_get_audit_file('E:\Audits\*.sqlaudit',NULL,NULL)
GO

---------- Module 8 Lab C Exercise 5 Step 2
SELECT event_time,
		CASE action_id
			WHEN 'IN' THEN 'INSERT'
			WHEN 'SL' THEN 'SELECT'
			WHEN 'DL' THEN 'DELETE'
			WHEN 'UP' THEN 'UPDATE'
			ELSE 'OTHER'
		END AS ACTION,
		IIF(succeeded=1,'Success','Failure') AS Result,
		session_server_principal_name,
		server_principal_name,
		database_principal_name,
		database_name,
		schema_name+'.'+object_name as ObjectName,
		statement,
		transaction_id
	FROM sys.fn_get_audit_file('E:\Audits\*.sqlaudit',NULL,NULL)
	WHERE class_type = 'U'



