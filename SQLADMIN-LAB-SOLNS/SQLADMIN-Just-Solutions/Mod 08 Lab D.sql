/*
Mod 08 Lab D
Implement transparent database encryption
*/

---------- Module 8 Lab D Exercise 1 Step 4
CREATE DATABASE Mod08LabD ON PRIMARY
	(NAME = 'Mod08LabDDB',
	FILENAME = 'F:\Mod08LabD.mdf',
	SIZE = 10Mb, MaxSize = 100Mb, FileGrowth = 10Mb)
LOG ON
	(NAME = 'Mod08LabDLog',
	FILENAME = 'G:\Mod08LabD.ldf',
	SIZE = 1Mb, MaxSize = 10mb, FileGrowth = 1Mb)
GO

---------- Module 8 Lab D Exercise 2 Step 1
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

---------- Module 8 Lab D Exercise 2 Step 2
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MyStrongPa55w.rd';
GO

---------- Module 8 Lab D Exercise 2 Step 3
BACKUP MASTER KEY TO FILE = 'H:\masterkey.bak'
	ENCRYPTION BY PASSWORD = 'MyStrongPassword';
GO

---------- Module 8 Lab D Exercise 2 Step 4
CREATE CERTIFICATE TDE_Encryptor WITH SUBJECT = 'MyDatabaseKey';
GO

---------- Module 8 Lab D Exercise 3 Step 1
USE Mod08LabD;
GO

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE TDE_Encryptor;
GO

---------- Module 8 Lab D Exercise 3 Step 2
ALTER DATABASE Mod08LabD
SET ENCRYPTION ON;
GO

---------- Module 8 Lab D Exercise 3 Step 3
SELECT DB.name, DB.is_encrypted, 
		DEK.encryption_scan_modify_date,
		DEK.encryption_scan_state_desc,
		DEK.encryption_state_desc,
		DEK.encryptor_type
	FROM sys.databases AS DB
		LEFT JOIN sys.dm_database_encryption_keys  AS DEK
			ON DB.database_id = DEK.database_id
	WHERE DB.name = 'Mod08LabD'

