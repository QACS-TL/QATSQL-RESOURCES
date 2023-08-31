/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 3 - Working with Databases

Demonstration - Show how the log grows dependent upon the
recovery model specified
*/

/*
		STEP 1 - Create three databases
		*******************************
*/


--This database will be set to use the FULL recovery model

CREATE DATABASE RM_Full ON PRIMARY
(
       NAME = 'RM_Full',
       FILENAME = 'F:\rmfulldb.mdf',
       SIZE = 80MB,
       MAXSIZE = 800Mb,
	   FILEGROWTH = 80mb
)
LOG ON
(     
       NAME = 'RM_Full_Log',
       FILENAME = 'G:\rmfulldb.ldf',
       SIZE = 40MB,
       MAXSIZE = 40Mb
)
GO

--Set the recovery model and perform full and log backups

ALTER DATABASE RM_Full SET RECOVERY FULL
BACKUP DATABASE RM_Full TO DISK ='H:\rmfull.bak'
BACKUP LOG RM_Full TO DISK ='H:\rmfull.bak'
GO
 
--This database will be set to use the BULK_LOGGED recovery model

CREATE DATABASE RM_Bulk ON PRIMARY
(
       NAME = 'RM_Bulk',
	   FILENAME = 'F:\rmbulkdb.mdf',
	   SIZE = 80MB,
       MAXSIZE = 800Mb,
       FILEGROWTH = 80mb
)
LOG ON
(     
       NAME = 'RM_Bulk_Log',
       FILENAME = 'G:\rmbulkdb.ldf',
       SIZE = 40MB,
       MAXSIZE = 40Mb
)
GO

--Set the recovery model and perform full and log backups

ALTER DATABASE RM_Bulk SET RECOVERY BULK_LOGGED
BACKUP DATABASE RM_Bulk TO DISK = 'H:\rmbulk.bak'
BACKUP LOG RM_Bulk TO DISK = 'H:\rmbulk.bak'
go
 
--Finally, this database will be set to use the SIMPLE recovery model

CREATE DATABASE RM_Simple ON PRIMARY
(
       NAME = 'RM_Simple',
       FILENAME = 'F:\rmsimpledb.mdf',
       SIZE = 80MB,
       MAXSIZE = 800Mb,
       FILEGROWTH = 80mb
)
LOG ON
(     
       NAME = 'RM_Simple_Log',
       FILENAME = 'G:\rmsimpledb.ldf',
       SIZE = 40MB,
       MAXSIZE = 40Mb
)
GO

--Set the recovery model, and perform a full backup

alter database RM_Simple set recovery simple
backup database RM_Simple to disk='h:\rmsimple.bak'
go

/*
		STEP 2 - Open and configure Performance Monitor
		***********************************************
*/

--Open the Windows Performance Monitor
--(Start / Windows Administrative Tools / Performance Monitor)
--Click the red "X" button to remove any counters which are present
--Click the green "+" button and add the counter SQLServer.Databases\Percent Log Used for each of the following instances: RM_Full, RM_Bulk, RM_Simple
--Click OK to start the monitor running.

/*
		STEP 3 - Insert some data into the databases
		********************************************
*/ 

--Each of the following uses SELECT * ...INTO as this is classed as a bulk operation.

SELECT *
       INTO RM_FULL.dbo.Sales
       FROM Adventureworks2019.sales.SalesOrderDetail;
SELECT *
       INTO RM_BULK.dbo.Sales
       FROM Adventureworks2019.sales.SalesOrderDetail;
SELECT *
       INTO RM_SIMPLE.dbo.Sales
       FROM Adventureworks2019.sales.SalesOrderDetail;
GO

/*
		STEP 4 - Examine the log growth
		*******************************
*/  

--Return to the Performance Monitor window
--Notice that the line representing the percent log used for the RM_Full database has climbed significantly as this database is set to use the FULL recovery model.
--Notice that the line representing the percent log used for the RM_BULK database has climbed a little and stabilised as this database is set to use the BULK_LOGGED recovery model.
--Notice that the line representing the percent log used for the RM_SIMPLE database climbed steeply, then dropped steeply, and is now at the same level as the RM_BULK database.  The log usage increased, but then was truncated.

/*
		STEP 5 - Cleanup
		****************
*/  
USE master;
DROP DATABASE RM_FULL;
DROP DATABASE RM_Bulk;
DROP DATABASE RM_Simple;