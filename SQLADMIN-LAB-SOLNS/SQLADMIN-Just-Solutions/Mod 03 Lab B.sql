/*
Mod 03 Lab B Ex 1
Reconfigure storage fora database
*/

---------- Module 3 Lab B Execise 1 Step 2

USE master
GO

ALTER DATABASE Mod03LabA SET OFFLINE WITH ROLLBACK IMMEDIATE
GO

----------Module 3 Lab B Execise 1 Step 4

ALTER DATABASE Mod03LabA
	MODIFY FILE
	(NAME = 'Mod03LabExtra',
	FILENAME = 'F:\Mod03LabExtra.ndf')
GO

----------Module 3 Lab B Execise 1 Step 6

ALTER DATABASE Mod03LabA SET ONLINE
GO

----------Module 3 Lab B Execise 1 Step 8

SELECT * FROM Mod03LabA.sys.sysfiles
GO











