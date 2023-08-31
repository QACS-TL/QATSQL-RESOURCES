/*
Mod 06 Lab C
Use an application role
*/

---------- Module 6 Lab C Execise 1 Step 4
CREATE DATABASE Mod06LabC ON PRIMARY
	(NAME = 'Mod06LabCDB',
	FILENAME = 'F:\Mod06LabC.mdf',
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod06LabCLog',
	FILENAME = 'G:\Mod06LabC.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

---------- Module 6 Lab C Execise 1 Step 5
USE Mod06LabC
GO

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

---------- Module 6 Lab C Execise 1 Step 6
GRANT SELECT, INSERT ON dbo.TillRoll TO StandardUser
DENY DELETE, UPDATE ON dbo.TillRoll TO StandardUser
GO

---------- Module 6 Lab C Execise 2 Step 1
CREATE APPLICATION ROLE Supervisor WITH PASSWORD = 'Pa55w.rd1234'
GO

---------- Module 6 Lab C Execise 2 Step 2
GRANT SELECT, INSERT, UPDATE, DELETE 
	ON dbo.TillRoll TO Supervisor

