/*
Mod 03 Lab B Ex 1
Create a database
*/
------------------- Run the following query if Lab A skipped : START
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

ALTER DATABASE Mod03LabA
	ADD FILE
	(NAME = 'Mod03LabExtra',
	--FILENAME = 'H:\Mod03LabExtra.ndf',	-- change to drive letter on real
	FILENAME = 'c:\disks\h\Mod03LabExtra.ndf',
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
GO
------------------- Run the following query if Lab A skipped : END
USE master
GO

ALTER DATABASE Mod03LabA SET OFFLINE WITH ROLLBACK IMMEDIATE
GO

ALTER DATABASE Mod03LabA
	MODIFY FILE
	(NAME = 'Mod03LabExtra',
	--FILENAME = 'f:\Mod03LabExtra.ndf',	-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod03LabExtra.ndf')
GO

ALTER DATABASE Mod03LabA SET ONLINE
GO

SELECT * FROM Mod03LabA.sys.sysfiles
GO











