/*
Mod 05 Lab B
Create users
*/

---------- Module 5 Lab B Execise 1 Step 3
CREATE DATABASE Mod05LabB ON PRIMARY
	(NAME = 'Mod05LabBDB',
	FILENAME = 'F:\Mod05LabB.mdf',	
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod05LabBLog',
	FILENAME = 'G:\Mod05LabB.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

---------- Module 5 Lab B Execise 1 Step 4
USE Mod05LabB
GO

SELECT name, isntname, isntuser, issqluser
	FROM sys.sysusers
	WHERE hasdbaccess = 1
GO

---------- Module 5 Lab B Execise 1 Step 7
CREATE USER [SQL\AAdamson];
CREATE USER Barry FOR LOGIN [SQL\BBenson];
CREATE USER Carl FOR LOGIN [SQL\CCarlson];
CREATE USER [FFoster] ;
GO

---------- Module 5 Lab B Execise 4 Step 3
GRANT CONNECT TO GUEST
GO
