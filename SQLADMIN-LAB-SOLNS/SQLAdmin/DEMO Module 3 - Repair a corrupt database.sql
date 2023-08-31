/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 3 - Working with Databases

Demonstration - Repair a corrupt database
*/

/*
	STEP 1 - Restore a damaged database for use in the demo
	*******************************************************
*/


USE master;
RESTORE DATABASE [CorruptDB] FROM  DISK = N'E:\SQLAdmin\CorruptDB.bak' 
	WITH  FILE = 1,  MOVE N'Northwind' TO N'F:\CorruptDB.mdf',  MOVE N'Northwind_log' TO N'G:\CorruptDB.ldf'
GO

/*
	STEP 2 - Run DBCC CHECKDB against a healthy database
	****************************************************
*/

--The following script runs DBCC CHECKDB against the AdventureWorks database using all default options.
--No errors should be returned, but each table returns an information message reporting its size.
--At the bottom of the results a message is returned saying that no errors found.


DBCC CHECKDB('AdventureWorks');
GO


--As above, but using the NO_INFOMSGS switch.  This suppresses the information messages and only returns errors if any are found.  Because the database is healthy the query returns the message "Commands completed successfully".


DBCC CHECKDB('AdventureWorks') WITH NO_INFOMSGS;
GO

/*
	STEP 3 - Run DBCC CHECKDB against a damaged database
	****************************************************
*/


--The following script runs DBCC CHECKDB against the CorruptDB database using all default options.
--Although some tables are healthy, some errors are returned (look for red text in the results).
--Additionally, at the bottom of the results a message is returned saying that CHECKDB found 0 allocation errors and 4 consistency errors.  It advises that "repair_allow_data_loss" is the minimum repair level.


DBCC CHECKDB('CorruptDB');
GO

--As above, but again using WITH_NOINFOMSGS.  Only errors will be returned.
--Note that the messages advise that the errors are in the Orders table.


DBCC CHECKDB('CorruptDB') WITH NO_INFOMSGS;
GO

/*
	STEP 4 - Attempt to query the damaged table
	*******************************************
*/


--The following query attempts to return the entire contents of the Orders table.
--However, as the table is damaged, an error is returned.


SELECT * FROM corruptdb.dbo.Orders;
GO


--Some parts of the table are not damaged though.  The following query successfully returns data.


SELECT * FROM corruptdb.dbo.Orders
WHERE OrderID = 11077;
GO

/*
	STEP 5 - Fix the corruption
	***************************
*/

--In order to fix corruption with DBCC CHECKDB the database needs to be put into SINGLE USER mode.

--The following query puts the CorruptDB into SINGLE USER mode immediately, then performs the  repair using DBCC CHECKDB, then returns it to MULTI USER mode.


ALTER DATABASE CorruptDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DBCC CHECKDB('CorruptDB','repair_allow_data_loss');
GO
ALTER DATABASE CorruptDB SET MULTI_USER WITH ROLLBACK IMMEDIATE;
GO


--Next, run DBCC CHECKDB with the NO_INFOMSGS switch to see if the database is still damaged.
--As no errors are found, "Commands completed successfully" is returned.


DBCC CHECKDB('CorruptDB') WITH NO_INFOMSGS;
GO

/*
	STEP 6 - Have we lost any data?
	*******************************
*/


--Finally, let's requery the Orders table.  This failed previously, but this time no errors are returned as the corruption has been fixed.


SELECT * FROM corruptdb.dbo.orders;
GO

--However, we have actually lost some data.  In this database, the Order Details table has a foreign key relationship with the Orders table based on the OrderID column.  As any corruption in the Orders table has been deleted there will be some orphaned OrderIDs in the Order Details table.

--The following query returns a list of the orphaned Order IDs.


SELECT OrderID FROM CorruptDB.dbo.[Order Details]
EXCEPT
SELECT OrderID FROM CorruptDB.dbo.Orders;
GO


--As you will see, there are 42 orphaned OrderIDs in the Order Details table.


/*
	STEP 7 - Clean up
	*****************
*/

USE MASTER;
GO
DROP DATABASE CorruptDB;
GO
