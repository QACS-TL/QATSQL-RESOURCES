/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 4 - Backup and restore

Demonstration - Performing database and log backups
*/

/*
	STEP 1 - Create and backup a database for this demo
	***************************************************
*/

USE master;
CREATE DATABASE RestoreDemo;
GO

BACKUP DATABASE RestoreDemo 
	TO DISK = 'H:\RestoreDemo.bak'
	WITH NAME = 'RestoreDemo - Full',
	DESCRIPTION = 'Full backup of RestoreDemo database';
GO


/*
	STEP 2 - Create a table in the database
	***************************************
*/

USE RestoreDemo;
GO
CREATE TABLE Products (ID INT, Name VARCHAR(100));

--Take a log backup.  This backup will contain the code to create the table.

BACKUP LOG RestoreDemo 
	TO DISK = 'H:\RestoreDemo.bak'
	WITH NAME = 'RestoreDemo - Log 1',
	DESCRIPTION = 'First log backup of RestoreDemo database';
GO

--Take a look at the backup device and it should contain a full and a log backup.

USE master;
RESTORE HEADERONLY FROM DISK = 'H:\RestoreDemo.bak';
GO

--Insert some data into the table.

USE RestoreDemo;
INSERT Products (ID, Name) VALUES (1,'Apple'),(2,'Beer'),(3,'Cheese');
GO
SELECT * FROM Products;
GO

--Take a second log backup.  This backup will contain the code to insert the three rows of data into the table.

BACKUP LOG RestoreDemo 
	TO DISK = 'H:\RestoreDemo.bak'
	WITH NAME = 'RestoreDemo - Log 2',
	DESCRIPTION = 'Second log backup of RestoreDemo database';
GO

--Take a look at the backup device and it should contain a full and two log backups.

USE master;
RESTORE HEADERONLY FROM DISK = 'H:\RestoreDemo.bak';
GO

--Insert some more data

USE RestoreDemo;
INSERT Products (ID, Name) VALUES (4,'Diamond'),(5,'Egg'),(6,'Fish');
GO
SELECT * FROM Products;
GO

--Perform a differential backup. This will include all changes since the initial FULL backup, namely the creation and population of the table.

BACKUP DATABASE RestoreDemo 
	TO DISK = 'H:\RestoreDemo.bak'
	WITH NAME = 'RestoreDemo - Differential',
	DESCRIPTION = 'Differential backup of RestoreDemo database',
	DIFFERENTIAL;
GO

--Take a look at the backup device and it should contain a full and two log backups.

USE master;
RESTORE HEADERONLY FROM DISK = 'H:\RestoreDemo.bak';
GO


/*
	STEP 3 - Restore the full backup only
	*************************************
*/

--Before we start, look at the contents of the backup device.  Note the POSITION column.  This indicates the order of each backup within the device, essentially a list of the order in which they are found within the file.  1 is the full, 2 and 3 are logs, and 4 is a differential.

USE master;
RESTORE HEADERONLY FROM DISK = 'H:\RestoreDemo.bak';
GO

--Restore the full backup and re-open the database. Note that this statement will return an error.

USE master;
RESTORE DATABASE RestoreDemo 
	FROM DISK = 'H:\RestoreDemo.bak'
	WITH FILE = 1, RECOVERY;
GO

--The statement fails as the tail of the transaction log has not been backed up.

--Take a tail log backup, then restore the full backup only, and reopen the database.

USE master;
BACKUP LOG RestoreDemo
	TO DISK = 'H:\RestoreDemo.bak'
	WITH NAME = 'RestoreDemo - tail log',
	DESCRIPTION = 'RestoreDemo - tail log backup',
	NORECOVERY;
GO

--Refresh the Databases node in the Object Explorer and the RestoreDemo database should have "(Restoring...)" next to it.

--Now attempt the full restore again.  This time it should succeed.

USE master;
RESTORE DATABASE RestoreDemo 
	FROM DISK = 'H:\RestoreDemo.bak'
	WITH FILE = 1, RECOVERY;
GO

--Refresh the Databases node in the Object Explorer again.  The "(Restoring...)" label should no longer appear next to RestoreDemo.

--Attempt to query the Products table.  This should return an error as the full backup was taken before the table was created.

USE RestoreDemo;
SELECT * FROM Products;
GO


/*
	STEP 4 - Restore the full backup and the first log only
	*******************************************************
*/

--The following query restores the full backup and the first log backup.
--The REPLACE switch is used to override SQL Server's safety check - we know that we don't want to take a tail log backup here.

USE master;
RESTORE DATABASE RestoreDemo 
	FROM DISK = 'H:\RestoreDemo.bak'
	WITH FILE = 1, NORECOVERY, REPLACE;
GO
RESTORE LOG RestoreDemo
	FROM DISK = 'H:\RestoreDemo.bak'
	WITH FILE=2, RECOVERY;
GO

--Attempt to query the Products table.  This time the query succeeds but the table is empty as the log backup was taken after the table was created, but before any data was inserted.

USE RestoreDemo;
SELECT * FROM Products;
GO


/*
	STEP 5 - Restore the full and differential backups
	**************************************************
*/

--The following query restores the full backup, and then the differential.
--The REPLACE switch is again used to override SQL Server's safety check.

USE master;
RESTORE DATABASE RestoreDemo 
	FROM DISK = 'H:\RestoreDemo.bak'
	WITH FILE = 1, NORECOVERY, REPLACE;
GO
RESTORE DATABASE RestoreDemo
	FROM DISK = 'H:\RestoreDemo.bak'
	WITH FILE=4, RECOVERY;
GO

--Attempt to query the Products table.  This time the query succeeds and the table contains all six rows of data.

USE RestoreDemo;
SELECT * FROM Products;
GO

/*
	STEP 5 - Simulate a data issue
	******************************
*/

--Before we begin, take a full backup of the RestoreDemo database.

USE master;
BACKUP DATABASE RestoreDemo 
	TO DISK = 'H:\RestoreDemo.bak'
	WITH NAME = 'RestoreDemo - Full',
	DESCRIPTION = 'Second full backup of RestoreDemo database';
GO

--Take a look at the Products table. It should contain six rows of data.

USE RestoreDemo;
SELECT * FROM Products;
GO

--Insert some more data. When the SELECT statement is executed it should show that the table now contains 9 rows of data.

INSERT Products (ID, Name) VALUES (7, 'Gnome'),(8, 'Hat'),(9, 'Igloo');
SELECT * FROM Products;

--Take a look at the current time.  IMPORTANT - COPY AND PASTE THE RESULT HERE:>>> 2022-03-03 11:52:13.420

SELECT GETDATE();
GO

--Delete some data from the table

DELETE Products WHERE ID IN (2,4,6,8);
GO

--Take a look at the table.  The products with ID numbers of 2, 4, 6 and 8 have been deleted.

SELECT * FROM Products;
GO

/*
	STEP 6 - Perform a point-in-time restore
	****************************************
*/

--Take a tail-log backup of the database. This includes the insertion of rows 7-9, but also the deletion of rows 2,4,6 and 8.

USE master;
BACKUP LOG RestoreDemo 
	TO DISK = 'H:\RestoreDemo.bak'
	WITH NAME = 'RestoreDemo - Tail Log 2',
	DESCRIPTION = 'Second tail log backup of RestoreDemo',
	NORECOVERY;
GO

--Take a look at the contents of the backup device.

USE master;
RESTORE HEADERONLY FROM DISK = 'H:\RestoreDemo.bak';
GO

--Restore the FULL backup. This should be the backup in position 6 on the backup device.

USE master;
RESTORE DATABASE RestoreDemo 
	FROM DISK = 'H:\RestoreDemo.bak'
	WITH FILE = 6, NORECOVERY;
GO

--Now restore the tail log, which should be in position 7 on the backup device, using the STOPAT option.  Replace the Xs in the statement with the datetime value you noted in the previous step.  This will restore the log up to the time we specified, which was after the insertion of rows 7-9 but before rows 2,4,6 and 8 were deleted.

RESTORE LOG RestoreDemo
	FROM DISK = 'H:\RestoreDemo.bak'
	WITH FILE=7, 
	STOPAT = '2022-03-03 11:52:13.420',
	RECOVERY;
GO

--Check the contents of the table.  All nine rows should be present.

USE RestoreDemo;
SELECT * FROM Products;

--Cleanup

USE master;
DROP DATABASE RestoreDemo;
