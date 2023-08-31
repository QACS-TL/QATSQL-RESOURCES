/*
Mod 04 Lab C
Restore a corrupt database
*/

---------- Module 4 Lab C Execise 1 Step 3
CREATE DATABASE Mod04LabC ON PRIMARY
	(NAME = 'Mod04LabCDB',
	FILENAME = 'F:\Mod04LabC.mdf',
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod04LabCLog',
	FILENAME = 'G:\Mod04LabC.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

---------- Module 4 Lab C Execise 1 Step 4
BACKUP DATABASE Mod04LabC
	TO DISK = 'H:\Mod04LabC_Initial.bak'
	WITH
	NAME = 'Mod04LabC_DB_Initial',
	DESCRIPTION = 'Mod04LabC database initial backup'
GO

BACKUP LOG Mod04LabC
	TO DISK = 'H:\Mod04LabC_Log1.bak'
	WITH
	NAME = 'Mod04LabC_DB_Initial_Log',
	DESCRIPTION = 'Mod04LabC database initial log backup'
GO

---------- Module 4 Lab C Execise 2 Step 2
USE Mod04LabC
GO

CREATE TABLE dbo.Products(
	ProductID INT PRIMARY KEY,
	ProductName VARCHAR(50) NOT NULL,
	ListPrice MONEY NOT NULL
)
GO

INSERT INTO dbo.Products VALUES
	(1,'Apple',0.50),
	(2,'Orange',0.70),
	(3,'Lemon',0.35),
	(4,'Strawberries',2.00),
	(5,'Raspberries',1.75)
GO

---------- Module 4 Lab C Execise 2 Step 3
SELECT * FROM dbo.Products
GO

---------- Module 4 Lab C Execise 3 Step 1
BACKUP LOG Mod04LabC
	TO DISK = 'H:\Mod04LabC_Log2.bak'
	WITH
	NAME = 'Mod04LabC_Changes_2'
GO

---------- Module 4 Lab C Execise 4 Step 2
INSERT INTO dbo.Products VALUES
	(6,'Pineapple',1.25)
UPDATE dbo.Products	
	SET ListPrice = 0.65
	WHERE ProductID = 1
GO

SELECT * FROM dbo.Products
GO

---------- Module 4 Lab C Execise 4 Step 3
BACKUP LOG Mod04LabC
	TO DISK = 'H:\Mod04LabC_Log3.bak'
	WITH
	NAME = 'Mod04LabC_Changes_3'
GO

BACKUP DATABASE Mod04LabC 
	TO DISK = 'H:\Mod04LabC_Diff.bak'
	WITH DIFFERENTIAL,
	NAME = 'Mod04LabC_Differential'
GO

---------- Module 4 Lab C Execise 5 Step 2
INSERT INTO dbo.Products VALUES
	(7,'Kiwi Fruit',0.25)
UPDATE dbo.Products	
	SET ListPrice = 1.00
	WHERE ProductID = 2
GO

SELECT * FROM dbo.Products
GO

---------- Module 4 Lab C Execise 5 Step 3
SELECT GETDATE()

---------- Module 4 Lab C Execise 5 Step 5
DELETE FROM dbo.Products
SELECT * FROM dbo.Products

---------- Module 4 Lab C Execise 6 Step 1
USE MASTER
ALTER DATABASE Mod04LabC SET SINGLE_USER WITH ROLLBACK IMMEDIATE


BACKUP LOG Mod04LabC 
	TO DISK = 'H:\Mod04LabC_Tail.bak'
	WITH INIT, NORECOVERY,
	NAME = 'Mod04LabC_TailLog'
GO

---------- Module 4 Lab C Execise 6 Step 2
RESTORE DATABASE Mod04LabC
	FROM DISK = 'H:\Mod04LabC_Initial.bak'
	WITH REPLACE, NORECOVERY
GO

---------- Module 4 Lab C Execise 6 Step 5
RESTORE DATABASE Mod04LabC
	FROM DISK = 'H:\Mod04LabC_Diff.bak'
	WITH NORECOVERY
GO

---------- Module 4 Lab C Execise 6 Step 6
RESTORE LOG Mod04LabC 
	FROM DISK = 'H:\Mod04LabC_Tail.bak'
	WITH RECOVERY,STOPAT = '<<enter datatime here>>'
GO

---------- Module 4 Lab C Execise 6 Step 7
SELECT * FROM Mod04LabC.dbo.Products
GO

---------- Module 4 Lab C Execise 6 Step 8
ALTER DATABASE Mod04LabC SET MULTI_USER
GO

