/*
Mod 03 Lab A Ex 2
Create a database
*/
------------------- Run the following query if Ex 1 skipped : START
CREATE DATABASE Mod03LabA ON PRIMARY
	(NAME = 'Mod03LabDB',
	--FILENAME = 'F:\Mod03Lab.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod03Lab.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod03LabLog',
	--FILENAME = 'G:\Mod03Lab.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod03Lab.ldf',
	SIZE = 10Mb, MaxSize = 100Mb, FileGrowth = 10Mb)
GO
------------------- Run the following query if Ex 1 skipped : END

------------------- Add an addition data file
ALTER DATABASE Mod03LabA
	ADD FILE
	(NAME = 'Mod03LabExtra',
	--FILENAME = 'H:\Mod03LabExtra.ndf',	-- change to drive letter on real
	FILENAME = 'c:\disks\h\Mod03LabExtra.ndf',
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
GO

------------------- Check database files using TSQL
SELECT * FROM Mod03LabA.sys.sysfiles
SELECT * FROM Mod03LabA.sys.database_files
GO

