/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 5 - SQL Server Authentication

Demonstration - Create and use a contained database user
*/

/*
	STEP 1 - Enable containment on the SERVER2019 instance
	******************************************************
*/

--1.	Right-click the SERVER2019 instance in the Object Explorer
--2.	Click Properties
--3.	Click Advanced.
--4.	At the top, change Enable Contained Databases to True.
--5.	Click OK.

/*
	STEP 2 - Create a contained database
	************************************
*/

USE master;
CREATE DATABASE ContainedDB CONTAINMENT = Partial;
GO

--The following creates a table within the database and loads some data into it

USE ContainedDB;
GO

CREATE TABLE TestTable
(ID	INT	IDENTITY(1,1),
Name	VARCHAR(20));
GO
INSERT TestTable VALUES ('Apple'),('Beer'),('Cheese');
GO


/*
	STEP 3 - Create a contained login within the database
	*****************************************************
*/

USE ContainedDB;
CREATE USER Test2 WITH PASSWORD = N'Pa55w.rd';

--Give them access to the table

GRANT SELECT ON TestTable TO Test2;

/*
	STEP 4 - Test
	*************
*/

--1.	Click the New Query button on the toolbar.
--2.	Right-click the query window and click Connection - Change Connection...
--3.	Leave the server name as SERVER2019.	
--4.	Change Authentication to SQL Server Authentication.
--5.	In the User name field, enter Test2.
--6.	In the Password field, type Pa55w.rd
--7.	Click OK.  An error is returned as the Test2 user does not have a login on the instance. Click OK.
--8.	Click the Options button.
--9.	In the Connect To Database field, type ContainedDB, then click OK.  The connection succeeds.
--10.	In the query window, execute the following:
			SELECT * FROM TestTable;
--11.	The query should succeed, returning three rows of data.
--12.	Close the query window.


/*
	Cleanup
	*******
*/

USE master;
DROP DATABASE ContainedDB;
