-- 1. Create a new database

--- Create Mod08LabD database
CREATE DATABASE Mod08LabD ON PRIMARY
	(NAME = 'Mod08LabDDB',
	--FILENAME = 'F:\Mod08LabD.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod08LabD.mdf',		
	SIZE = 10Mb, MaxSize = 100Mb, FileGrowth = 10Mb)
LOG ON
	(NAME = 'Mod08LabDLog',
	--FILENAME = 'G:\Mod08LabD.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod08LabD.ldf',
	SIZE = 1Mb, MaxSize = 10mb, FileGrowth = 1Mb)
GO

SELECT DB.name, DB.is_encrypted, 
		DEK.encryption_scan_modify_date,
		DEK.encryption_scan_state_desc,
		DEK.encryption_state_desc,
		DEK.encryptor_type
	FROM sys.databases AS DB
		LEFT JOIN sys.dm_database_encryption_keys  AS DEK
			ON DB.database_id = DEK.database_id
	WHERE DB.name = 'Mod08LabD'
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MyStrongPa55w.rd';
GO

BACKUP MASTER KEY TO FILE = 'c:\disks\masterkey.bak'
	ENCRYPTION BY PASSWORD = 'MyStrongPassword';
GO

CREATE CERTIFICATE TDE_Encryptor WITH SUBJECT = 'MyDatabaseKey';
GO

USE Mod08LabD;
GO

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE TDE_Encryptor;
GO

ALTER DATABASE Mod08LabD
SET ENCRYPTION ON;
GO

SELECT DB.name, DB.is_encrypted, 
		DEK.encryption_scan_modify_date,
		DEK.encryption_scan_state_desc,
		DEK.encryption_state_desc,
		DEK.encryptor_type
	FROM sys.databases AS DB
		LEFT JOIN sys.dm_database_encryption_keys  AS DEK
			ON DB.database_id = DEK.database_id
	WHERE DB.name = 'Mod08LabD'

GO
USE MASTER
DROP DATABASE Mod08LabD
DROP CERTIFICATE TDE_Encryptor
DROP MASTER KEY