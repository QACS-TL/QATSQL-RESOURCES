
-- 1. Create a new database, table and insert data

--- Create Mod04LabA database
CREATE DATABASE Mod04LabA ON PRIMARY
	(NAME = 'Mod04LabADB',
	--FILENAME = 'F:\Mod04LabA.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod04LabA.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod04LabALog',
	--FILENAME = 'G:\Mod04LabA.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod04LabA.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

-- 2. Perform initial database backup
BACKUP DATABASE Mod04LabA
	--TO DISK = 'c:\disks\g\Mod04LabA_Initial.bak'
	TO DISK = 'H:\Mod04LabA_Initial.bak'
	WITH
	NAME = 'Mod04LabA_DB_Initial',
	DESCRIPTION = 'Mod04LabA database initial backup'
GO

-- 3. Perform initial log backup
BACKUP LOG Mod04LabA
	TO DISK = 'c:\disks\g\Mod04LabA_Log.bak'
	--TO DISK = 'H:\Mod04LabA_Log.bak'
	WITH
	NAME = 'Mod04LabA_DB_Initial_Log',
	DESCRIPTION = 'Mod04LabA database initial log backup'
GO

-- 3. Perform stripe backup
BACKUP DATABASE Mod04LabA
	TO DISK = 'c:\disks\g\Mod04LabA_Split1.bak',
		DISK = 'c:\disks\g\Mod04LabA_Split2.bak'
	--TO DISK = 'H:\Mod04LabA_Split1.bak',
	--TO DISK = 'H:\Mod04LabA_Split2.bak'
	WITH
	NAME = 'Mod04LabA_DB_Split',
	DESCRIPTION = 'Mod04LabA database split backup'
GO

-- 4. Perform mirror backup
BACKUP DATABASE Mod04LabA
	TO DISK = 'c:\disks\g\Mod04LabA_Mirror1.bak'
		MIRROR TO DISK = 'c:\disks\g\Mod04LabA_Mirror2.bak'
	--TO DISK = 'H:\Mod04LabA_Mirror1.bak',
	--TO DISK = 'H:\Mod04LabA_Mirror2.bak'
	WITH
	FORMAT,
	NAME = 'Mod04LabA_DB_Mirror',
	DESCRIPTION = 'Mod04LabA database mirror backup'
GO

