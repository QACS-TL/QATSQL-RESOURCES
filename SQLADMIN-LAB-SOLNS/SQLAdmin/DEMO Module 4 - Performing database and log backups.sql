/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 4 - Backup and restore

Demonstration - Performing database and log backups
*/

/*
	STEP 1 - Perform a full backup
	******************************
*/

USE master;
BACKUP DATABASE AdventureWorks
	TO DISK = 'H:\AdventureWorksBackups.bak'
	WITH NAME = 'AdventureWorks - Full',
	DESCRIPTION = 'Full backup of AdventureWorks';
GO

--Check the contents of the backup device.  The device should contain a single backup set.

USE master;
RESTORE HEADERONLY FROM DISK = 'H:\AdventureWorksBackups.bak';
GO

/*
	STEP 2 - Perform a log backup
	*****************************
*/

USE master;
BACKUP LOG AdventureWorks
	TO DISK = 'H:\AdventureWorksBackups.bak'
	WITH NAME = 'AdventureWorks - Log',
	DESCRIPTION = 'Transaction log backup of AdventureWorks';
GO

--The above statement will fail as the database is using the SIMPLE recovery model.

--Change the recovery to FULL

USE master;
ALTER DATABASE AdventureWorks SET RECOVERY FULL;
GO

--Perform the full backup again

USE master;
BACKUP DATABASE AdventureWorks
	TO DISK = 'H:\AdventureWorksBackups.bak'
	WITH NAME = 'AdventureWorks - Full',
	DESCRIPTION = 'Full backup of AdventureWorks';
GO

--Retry the log backup.  This time it should succeed.

USE master;
BACKUP LOG AdventureWorks
	TO DISK = 'H:\AdventureWorksBackups.bak'
	WITH NAME = 'AdventureWorks - Log',
	DESCRIPTION = 'Transaction log backup of AdventureWorks';
GO

--Check the contents of the backup device.  The device should contain two full backups and a single log backup.

USE master;
RESTORE HEADERONLY FROM DISK = 'H:\AdventureWorksBackups.bak';
GO


/*
	STEP 3 - Differential backup
	****************************
*/

--Perform a differential backup

USE master;
BACKUP DATABASE AdventureWorks
	TO DISK = 'H:\AdventureWorksBackups.bak'
	WITH NAME = 'AdventureWorks - Differential',
	DESCRIPTION = 'Differential backup of AdventureWorks',
	DIFFERENTIAL;
GO

--Check the contents of the backup device.  The device should contain two full backups, a single log backup, and a differential backup.

USE master;
RESTORE HEADERONLY FROM DISK = 'H:\AdventureWorksBackups.bak';
GO



/*
	STEP 4 - Filegroup backup
	*************************
*/

--The following query performs a full backup of the WideWorldImporters database.

USE master;
BACKUP DATABASE WideWorldImporters
	TO DISK = 'H:\WideWorldImportersBackups.bak'
	WITH NAME = 'WideWorldImporters - Full',
	DESCRIPTION = 'Full backup of WideWorldImporters';
GO

--Check the contents of the backup device.  The device should contain one full backup.

USE master;
RESTORE HEADERONLY FROM DISK = 'H:\WideWorldImportersBackups.bak';
GO

--The following query performs a backup of the USERDATA filegroup in the WideWorldImporters database.

USE master;
BACKUP DATABASE WideWorldImporters
	FILEGROUP = 'USERDATA'
	TO DISK = 'H:\WideWorldImportersBackups.bak'
	WITH NAME = 'WideWorldImporters - USERDATA',
	DESCRIPTION = 'WideWorldImporters - USERDATA filegroup backup';
GO

--Check the contents of the backup device.  The device should contain a full backup and a backup of the USERDATA filegroup.

USE master;
RESTORE HEADERONLY FROM DISK = 'H:\WideWorldImportersBackups.bak';
GO


/*
	STEP 5 - Partial backup
	***********************
*/

--The following query performs a partial backup of all the read-write filegroups in the WideWorldImporters database.

USE master;
BACKUP DATABASE WideWorldImporters
	READ_WRITE_FILEGROUPS
	TO DISK = 'H:\WideWorldImportersBackups.bak'
	WITH NAME = 'WideWorldImporters - partial',
	DESCRIPTION = 'WideWorldImporters - partial backup';
GO

--Check the contents of the backup device.  The device should contain a full backup, a backup of the USERDATA filegroup, and a partial backup containing all of the read-write filegroups.

USE master;
RESTORE HEADERONLY FROM DISK = 'H:\WideWorldImportersBackups.bak';
GO
