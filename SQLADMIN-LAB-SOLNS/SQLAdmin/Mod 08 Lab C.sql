-- 1. Create a new database

--- Create Mod08LabC database and create testers (logins and users)
CREATE DATABASE Mod08LabC ON PRIMARY
	(NAME = 'Mod08LabCDB',
	--FILENAME = 'F:\Mod08LabC.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod08LabC.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod08LabCLog',
	--FILENAME = 'G:\Mod08LabC.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod08LabC.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

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
CREATE TABLE dbo.AuditRecords(
	EventDT DATETIME2,
	ActionType VARCHAR(20),
	ActionResult VARCHAR(10),
	SessionName SYSNAME,
	ServerPrincipalName SYSNAME,
	DatabasePrincipalName SYSNAME,
	DatabaseName VARCHAR(100),
	ObjectName VARCHAR(100),
	SQLStatement NVARCHAR(4000),
	TransactionID bigint,
	DataSensitivityInfo NVARCHAR(4000)
)

GO

CREATE TABLE dbo.AuditChunks(
	AuditID INT IDENTITY(1,1) PRIMARY KEY,
	AuditDT DATETIME2
)
GO

CREATE PROC dbo.ProcesAudits AS 
BEGIN
	DECLARE @MinAuditDT DATETIME2
	SELECT @MinAuditDT = ISNULL(MAX(AuditDT),'1900-01-01')
		FROM dbo.AuditChunks

	INSERT dbo.AuditRecords
	SELECT 
		event_time,
		CASE action_id
				WHEN 'IN' THEN 'INSERT'
				WHEN 'SL' THEN 'SELECT'
				WHEN 'DL' THEN 'DELETE'
				WHEN 'UP' THEN 'UPDATE'
				ELSE 'OTHER'
			END AS ACTION,
			IIF(succeeded=1,'Success','Failure'),
			session_server_principal_name,
			server_principal_name,
			database_principal_name,
			database_name,
			schema_name + '.' + object_name as ObjectName,
			statement,
			transaction_id,
			data_sensitivity_information
		FROM sys.fn_get_audit_file('C:\disks\D\Audits\*.sqlaudit',NULL,NULL)
		WHERE class_type = 'U' AND event_time>@MinAuditDT

	INSERT INTO dbo.AuditChunks
		SELECT MAX(EventDT) as LastEvent
			FROM dbo.AuditRecords
END

GO

ADD SENSITIVITY CLASSIFICATION TO dbo.Customers.CustomerIncome
WITH (LABEL = 'CustomerIncome : Highly Confidential - GDPR', INFORMATION_TYPE = 'Financial');
ADD SENSITIVITY CLASSIFICATION TO dbo.Customers.Ethnicity
WITH (LABEL = 'Ethnicity : Highly Confidential- GDPR', INFORMATION_TYPE = 'Individual');
GO

USE [master]
GO

CREATE SERVER AUDIT [TableProtectionStore]
TO FILE 
(	FILEPATH = 'c:\disks\d\Audits\'
	,MAXSIZE = 100 MB
	,MAX_FILES = 5
	,RESERVE_DISK_SPACE = OFF
) 
WITH (QUEUE_DELAY = 1000, 
	ON_FAILURE = CONTINUE
)
GO

ALTER SERVER AUDIT [TableProtectionStore] WITH (STATE = ON)
GO

USE Mod08LabC
CREATE DATABASE AUDIT SPECIFICATION [AuditDataChangesAndReading]
FOR SERVER AUDIT [TableProtectionStore]
ADD (DELETE ON OBJECT::[dbo].[Customers] BY [public]),
ADD (INSERT ON OBJECT::[dbo].[Customers] BY [public]),
ADD (SELECT ON OBJECT::[dbo].[Customers] BY [public]),
ADD (UPDATE ON OBJECT::[dbo].[Customers] BY [public])
WITH (STATE = ON)
GO

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

EXECUTE AS USER = 'TestUserB'
	INSERT INTO dbo.Customers(CustomerID,CustomerName,CompanyName,CustomerLevel,
							SalesPerson, CustomerIncome, EmailAddress, Phone)  VALUES
		(5,'Jack Jones','SnackJack','1-Very Low','Sales1',340,'jj@jacksnack.co.uk','08380 998765')
	UPDATE dbo.Customers SET CustomerLevel = '4-High' WHERE CustomerID = 2
	DELETE FROM dbo.Customers WHERE CustomerID = 3
	SELECT * FROM dbo.Customers WHERE CustomerLevel='4-High'
REVERT
GO

TRUNCATE TABLE dbo.Customers
GO

SELECT * FROM sys.fn_get_audit_file('C:\disks\D\Audits\*.sqlaudit',NULL,NULL)
GO

EXEC dbo.ProcesAudits
SELECT * FROM dbo.AuditRecords
GO

EXECUTE AS USER = 'TestUserB'
	INSERT INTO dbo.Customers(CustomerID,CustomerName,CompanyName,CustomerLevel,
							SalesPerson, CustomerIncome, EmailAddress, Phone)  VALUES
		(33,'Jack Jones','SnackJack','1-Very Low','Sales1',340,'jj@jacksnack.co.uk','02380 998765')
	SELECT * FROM dbo.Customers
REVERT
GO

EXEC dbo.ProcesAudits
SELECT * FROM dbo.AuditRecords
SELECT * FROM dbo.AuditChunks
GO

SELECT 1,* FROM dbo.Customers
SELECT 2,CustomerID,CustomerIncome FROM dbo.Customers
SELECT 3,CustomerID,Ethnicity FROM dbo.Customers


select A.transaction_id, A.statement,
		sqlXML.value('@label','varchar(400)') as [Attribute Label],
		sqlXML.value('@information_type','varchar(400)') as [Information Type]
	from (select *, convert(xml,data_sensitivity_information) as DSI
	FROM sys.fn_get_audit_file('C:\disks\D\Audits\*.sqlaudit',NULL,NULL)
	where data_sensitivity_information <> '') as A
	CROSS APPLY DSI.nodes('/sensitivity_attributes/sensitivity_attribute') as AttsData(sqlXML)

-------------------------- Clean Up
USE MOD08LabC
ALTER DATABASE AUDIT SPECIFICATION [AuditDataChangesAndReading] WITH (STATE = OFF)
DROP DATABASE AUDIT SPECIFICATION [AuditDataChangesAndReading]

USE MASTER
DROP DATABASE Mod08LabC
ALTER SERVER AUDIT [TableProtectionStore] WITH (STATE = OFF)
DROP SERVER AUDIT [TableProtectionStore]
DROP LOGIN TestUserA
DROP LOGIN TestUserB

