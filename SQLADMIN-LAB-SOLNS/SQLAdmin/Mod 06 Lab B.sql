-- 1. Create a new database

--- Create Mod06LabB database
CREATE DATABASE Mod06LabB ON PRIMARY
	(NAME = 'Mod06LabBDB',
	--FILENAME = 'F:\Mod06LabB.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod06LabB.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod06LabBLog',
	--FILENAME = 'G:\Mod06LabB.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod06LabB.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

-- 2. Add a new role and assign permissions
USE Mod06LabB
GO

CREATE ROLE DatabaseDeveloper
GO

ALTER ROLE db_ddladmin ADD MEMBER DatabaseDeveloper
ALTER ROLE db_accessadmin ADD MEMBER DatabaseDeveloper
ALTER ROLE db_securityadmin ADD MEMBER DatabaseDeveloper
ALTER ROLE db_datareader ADD MEMBER DatabaseDeveloper
ALTER ROLE db_datawriter ADD MEMBER DatabaseDeveloper
GO

-- 3. Test if Barry Benson can design and control security within the database
CREATE LOGIN NNowall WITH PASSWORD = 'Pa55w.rd'
CREATE USER NNowall
GO

------ follow the instructions to test Nick access

-- 4. Assign Barry to the new developer role
ALTER ROLE DatabaseDeveloper ADD MEMBER NNowall

------ follow the instructions to retest Barry access

-- 5. Clean up // close all other query windows
USE [master]
GO
DROP DATABASE [Mod06LabB]
GO


