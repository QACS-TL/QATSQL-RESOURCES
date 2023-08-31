/*
Mod 03 Lab C Ex 1
Create a database with limited size
*/

CREATE DATABASE Mod03LabC ON PRIMARY
	(NAME = 'Mod03LabCDB',
	--FILENAME = 'F:\Mod03LabC.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod03LabC.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod03LabCLog',
	--FILENAME = 'G:\Mod03LabC.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod03LabC.ldf',
	SIZE = 1Mb, MaxSize = 1mb, FileGrowth = 0)
GO

SELECT * FROM Mod03LabC.sys.sysfiles
GO

BACKUP DATABASE Mod03LabC to disk='c:\disks\j\Mod03LabC.bak'
BACKUP LOG Mod03LabC to disk='c:\disks\j\Mod03LabC.trn'
GO

USE Mod03LabC
GO

CREATE TABLE dbo.BigRowTable(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	BIGCOLUMN CHAR(2000)
)
GO

INSERT INTO dbo.BigRowTable VALUES ('Takes 2000 characters per row')
GO 50

BACKUP LOG Mod03LabC to disk='c:\disks\j\Mod03LabCFullLog.trn'

ALTER DATABASE Mod03LabC
	MODIFY FILE	
	(NAME = 'Mod03LabCLog',
	SIZE = 10Mb)
GO
SELECT * FROM Mod03LabC.sys.sysfiles
GO

ALTER DATABASE Mod03LabC
	MODIFY FILE	
	(NAME = 'Mod03LabCLog',
	MAXSIZE = 100Mb, FILEGROWTH = 10Mb)
GO
SELECT * FROM Mod03LabC.sys.sysfiles
GO