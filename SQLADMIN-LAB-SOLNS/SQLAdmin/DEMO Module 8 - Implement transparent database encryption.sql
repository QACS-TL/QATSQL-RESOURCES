/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 8 - Data Security and Auditing

Demonstration - Implement transparent database encryption
*/

/*
	STEP 1 - Create a database for the demo
	***************************************
*/

USE master;
CREATE DATABASE EncryptedDatabase;
GO

/*
	STEP 2 - Query sys.databases
	****************************
*/

--The following query will return the name of each database and its encryption state.
--A value of 0 means that the database is not encrypted, whereas 1 means that it is encrypted using transparent database encryption.
--Note that EncryptedDB has a value of 0, showing that it is currently not encrypted.

USE master;
SELECT 
	Name,
	is_encrypted
FROM sys.databases
ORDER BY name;
GO



/*
	STEP 3 - Create encryption keys and certificates
	************************************************
*/

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPa55w.rd';
GO

--Bakup the master key

BACKUP MASTER KEY TO FILE = 'H:\MasterKey.bak'
	ENCRYPTION BY PASSWORD = 'MyStrongPa55w.rd';
GO

--Create a certificate

CREATE CERTIFICATE EncryptionCertificate
	WITH SUBJECT = 'My Encryption Certificate';
GO


/*
	STEP 4 - Enable transparent database encryption
	***********************************************
*/

USE EncryptedDatabase;
GO

--Create a database encryption key in the database to encrypt.

CREATE DATABASE ENCRYPTION KEY 
	WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE EncryptionCertificate;

--Enable TDE

USE master;
ALTER DATABASE EncryptedDatabase
SET ENCRYPTION ON;
GO



/*
	STEP 4 - Retest
	***************
*/

--Run the following query again.
--You should now see that EncryptedDatabase has a value of 1 in the Is_encrypted column,
--indicating that it is now protected with transparent database encryption.

USE master;
SELECT 
	Name,
	is_encrypted
FROM sys.databases
ORDER BY name;
GO



/*
	Cleanup
	*******
*/

USE master;
DROP DATABASE EncryptedDatabase;
