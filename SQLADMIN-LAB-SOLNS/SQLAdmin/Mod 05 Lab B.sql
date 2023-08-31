
-- 1. Create a new database, table and insert data

--- Create Mod05LabB database
CREATE DATABASE Mod05LabB ON PRIMARY
	(NAME = 'Mod05LabBDB',
	--FILENAME = 'F:\Mod05LabB.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod05LabB.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod05LabCLog',
	--FILENAME = 'G:\Mod05LabB.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod05LabB.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

USE Mod05LabB
GO

SELECT name, isntname, isntuser, issqluser
	FROM sys.sysusers
	WHERE hasdbaccess = 1
GO

CREATE USER [MFLAPTOP\AAdamson];
CREATE USER Barry FOR LOGIN [SQL\BBenson];
CREATE USER Carl FOR LOGIN [SQL\CCarlson];
CREATE USER [FFoster] ;
GO

SELECT name, isntname, isntuser, issqluser
	FROM sys.sysusers
	WHERE hasdbaccess = 1
GO

GRANT CONNECT TO GUEST
GO

REVOKE CONNECT TO GUEST
GO

----
USE master
DROP DATABASE Mod05LabB


