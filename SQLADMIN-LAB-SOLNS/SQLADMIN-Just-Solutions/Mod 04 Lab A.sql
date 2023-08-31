/*
Mod 04 Lab A
Backup a database and log
*/

---------- Module 4 Lab A Execise 1 Step 3

CREATE DATABASE Mod04LabA ON PRIMARY
	(NAME = 'Mod04LabADB',
	FILENAME = 'F:\Mod04LabA.mdf',	
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod04LabALog',
	FILENAME = 'G:\Mod04LabA.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

---------- Module 4 Lab A Execise 2 Step 1

BACKUP DATABASE Mod04LabA
	TO DISK = 'H:\Mod04LabA_Initial.bak'
	WITH
	NAME = 'Mod04LabA_DB_Initial',
	DESCRIPTION = 'Mod04LabA database initial backup'
GO

---------- Module 4 Lab A Execise 2 Step 3

BACKUP LOG Mod04LabA
	TO DISK = 'H:\Mod04LabA_Log.bak'
	WITH
	NAME = 'Mod04LabA_DB_Initial_Log',
	DESCRIPTION = 'Mod04LabA database initial log backup'
GO

---------- Module 4 Lab A Execise 3 Step 2

BACKUP DATABASE Mod04LabA
	TO DISK = 'H:\Mod04LabA_Split1.bak',
	DISK = 'H:\Mod04LabA_Split2.bak'
	WITH
	NAME = 'Mod04LabA_DB_Split',
	DESCRIPTION = 'Mod04LabA database split backup'
GO

---------- Module 4 Lab A Execise 4 Step 2

BACKUP DATABASE Mod04LabA
	TO DISK = 'H:\Mod04LabA_Mirror1.bak'
		MIRROR TO DISK = 'H:\Mod04LabA_Mirror2.bak'
	WITH
	FORMAT,
	NAME = 'Mod04LabA_DB_Mirror',
	DESCRIPTION = 'Mod04LabA database mirror backup'
GO

