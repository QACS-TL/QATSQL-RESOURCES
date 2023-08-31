/*
Mod 03 Lab C
Create a database with fullrecover and limited disk space
*/

---------- Module 3 Lab C Execise 1 Step 2

CREATE DATABASE Mod03LabC ON PRIMARY
	(NAME = 'Mod03LabCDB',
	FILENAME = 'F:\Mod03LabC.mdf',
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod03LabCLog',
	FILENAME = 'G:\Mod03LabC.ldf',
	SIZE = 1Mb, MaxSize = 1mb, FileGrowth = 0)
GO

---------- Module 3 Lab C Execise 1 Step 3

SELECT * FROM Mod03LabC.sys.sysfiles
GO

---------- Module 3 Lab C Execise 2 Step 1

BACKUP DATABASE Mod03LabC to disk='H:\Mod03LabC.bak'
BACKUP LOG Mod03LabC to disk='H:\Mod03LabC.trn'
GO

---------- Module 3 Lab C Execise 3 Step 1

USE Mod03LabC
GO

CREATE TABLE dbo.BigRowTable(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	BIGCOLUMN CHAR(2000)
)
GO

INSERT INTO dbo.BigRowTable VALUES ('Takes 2000 characters per row')
GO 50

---------- Module 3 Lab C Execise 4 Step 1

BACKUP LOG Mod03LabC to disk='H:\Mod03LabCFullLog.trn'

ALTER DATABASE Mod03LabC
	MODIFY FILE	
	(NAME = 'Mod03LabCLog',
	SIZE = 10Mb)
GO
SELECT * FROM Mod03LabC.sys.sysfiles
GO

---------- Module 3 Lab C Execise 4 Step 2

ALTER DATABASE Mod03LabC
	MODIFY FILE	
	(NAME = 'Mod03LabCLog',
	MAXSIZE = 100Mb, FILEGROWTH = 10Mb)
GO

SELECT * FROM Mod03LabC.sys.sysfiles
GO