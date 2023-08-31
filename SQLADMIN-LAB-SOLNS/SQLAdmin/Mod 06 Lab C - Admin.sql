-- 1. Create a new database

--- Create Mod06LabC database
CREATE DATABASE Mod06LabC ON PRIMARY
	(NAME = 'Mod06LabCDB',
	--FILENAME = 'F:\Mod06LabC.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod06LabC.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod06LabCLog',
	--FILENAME = 'G:\Mod06LabC.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod06LabC.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

-- 2. Create the table, application role and assign permissions
USE Mod06LabC
GO
-- truncate table dbo.TillRoll
CREATE LOGIN StandardUser WITH PASSWORD = 'Pa55w.rd'
CREATE USER StandardUser
GO

CREATE TABLE dbo.TillRoll(
	ItemID INT IDENTITY(1,1) PRIMARY KEY,
	ItemDTAdded DATETIME NOT NULL DEFAULT getdate(),
	ReceiptID INT NOT NULL,
	ProductID INT NOT NULL,
	Quantity INT NOT NULL
)
GO

GRANT SELECT, INSERT ON dbo.TillRoll TO StandardUser
DENY DELETE, UPDATE ON dbo.TillRoll TO StandardUser
GO

---- Add an application role and assign permissions
CREATE APPLICATION ROLE Supervisor WITH PASSWORD = 'Pa55w.rd1234'
GO

GRANT SELECT, INSERT, UPDATE, DELETE 
	ON dbo.TillRoll TO Supervisor
GO

SELECT * FROM dbo.TillRoll
