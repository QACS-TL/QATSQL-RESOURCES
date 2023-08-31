/*
Mod 03 Lab A Ex 2
Alter a database file using TSQL
*/

---------- Module 3 Lab A Execise 2 Step 2

ALTER DATABASE Mod03LabA
	ADD FILE
	(NAME = 'Mod03LabExtra',
	FILENAME = 'H:\Mod03LabExtra.ndf',	
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
GO

---------- Module 3 Lab A Execise 2 Step 5

SELECT * FROM Mod03LabA.sys.sysfiles
SELECT * FROM Mod03LabA.sys.database_files
GO

