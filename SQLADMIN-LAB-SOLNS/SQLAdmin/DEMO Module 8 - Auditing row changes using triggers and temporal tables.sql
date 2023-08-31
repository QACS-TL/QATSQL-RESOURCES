/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 8 - Data Security and Auditing

Demonstration - Auditing row changes using triggers and temporal tables
*/

/*
	STEP 1 - Create a database for the trigger demo
	***********************************************
*/

USE master;
CREATE DATABASE TriggerDemo;
GO

--Add two tables for the demo

USE TriggerDemo;

CREATE TABLE dbo.Products
(
ProductID	INT	IDENTITY(1,1)	NOT NULL,
ProductName	VARCHAR(100)	NOT NULL,
Price	MONEY	NOT NULL
);

CREATE TABLE dbo.ProductHistory
(
ChangeSequence	INT				NOT NULL	IDENTITY(1,1),
Changed			DATETIME		NOT	NULL	DEFAULT GETDATE(),
ChangedBy		SYSNAME			NOT NULL	DEFAULT SUSER_SNAME(),
ProductChanged	INT				NOT NULL,
ChangeType		VARCHAR(10)		NOT NULL,
OldName			VARCHAR(100)	NULL,
NewName			VARCHAR(100)	NULL,
OldPrice		MONEY			NULL,
NewPrice		MONEY			NULL
);

/*
	STEP 2 - Create Triggers to record modifications
	************************************************
*/

USE TriggerDemo;
GO

CREATE TRIGGER I_AddProduct
	ON dbo.Products
	AFTER INSERT AS
	BEGIN
		SET NOCOUNT ON
		INSERT dbo.ProductHistory (ProductChanged, ChangeType, NewName, NewPrice)
		SELECT inserted.ProductID, 'INSERT', inserted.ProductName, inserted.Price
			FROM inserted JOIN Products
			ON inserted.ProductID = products.ProductID
	END;
GO

CREATE TRIGGER D_DeleteProduct
	ON dbo.Products
	AFTER DELETE AS
	BEGIN
		SET NOCOUNT ON
		INSERT dbo.ProductHistory (ProductChanged, ChangeType, OldName, OldPrice)
		SELECT deleted.ProductID, 'DELETE', deleted.ProductName, deleted.Price
			FROM deleted 
	END;
GO

CREATE TRIGGER U_ChangeProduct
	ON dbo.Products
	AFTER UPDATE AS
	BEGIN
		SET NOCOUNT ON
		INSERT dbo.ProductHistory (ProductChanged, ChangeType, OldName, NewName, OldPrice, NewPrice)
		SELECT inserted.ProductID, 'UPDATE', deleted.ProductName, inserted.ProductName, deleted.Price, inserted.Price
			FROM inserted JOIN Products
			ON inserted.ProductID = products.ProductID
			JOIN deleted
			ON deleted.ProductID = Products.ProductID
	END;
GO

/*
	STEP 3 - Testing
	****************
*/

--Take a look at the Products and ProductHistory tables.  Both are initially empty.


SELECT * FROM dbo.Products;
SELECT * FROM dbo.ProductHistory;

--Perform the three commands below.  You can run them one go or separately if preferred.
--Check the two tables above either after each statement or at the end of the batch if you run them together.
--The ProductHistory table should display the change history for the table.

INSERT dbo.Products VALUES ('Apple',5);
UPDATE dbo.Products SET ProductName = 'Red Apple', Price = 6 WHERE ProductName = 'Apple';
DELETE dbo.Products WHERE ProductName = 'Red Apple';
GO

/*
	STEP 4 - Cleanup
	****************
*/

USE master;
DROP DATABASE TriggerDemo;

/*
	STEP 5 - Temporal table setup
	*****************************
*/

--Create a database for the demo

USE master;
CREATE DATABASE TemporalDemo;
GO
USE TemporalDemo;

--Add a table to hold product details.

CREATE TABLE dbo.Products
(
	Productid		INT				NOT NULL	IDENTITY(1,1) PRIMARY KEY,
	ProductName		VARCHAR(100)	NOT NULL,
	Price			MONEY			NOT NULL,
	ValidFrom		DATETIME2 GENERATED ALWAYS AS ROW START,
	ValidTo			DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	LastEditedBy	SYSNAME			NOT NULL	DEFAULT SUSER_SNAME(),
	PERIOD FOR SYSTEM_TIME(ValidFrom, ValidTo)
);
GO

--Enable temporal auditing

ALTER TABLE dbo.Products SET (SYSTEM_VERSIONING = ON
	(HISTORY_TABLE = dbo.ProductHistory));
GO

/*
	STEP 6 - Test
	*****************************
*/

--Examine the live and temporal tables.  Both are currently empty.

SELECT * FROM dbo.Products;
SELECT * FROM dbo.ProductHistory;
GO

--Perform some modifications

INSERT Products (ProductName, Price) VALUES ('Apple',5);
INSERT Products (ProductName, Price) VALUES ('Beer',10);
UPDATE Products SET Price = 3 WHERE ProductName = 'Apple';
DELETE Products WHERE ProductName = 'Apple';

--Re-examine the tables

SELECT * FROM dbo.Products;
SELECT * FROM dbo.ProductHistory;
GO

--Examine the full change history

SELECT * FROM dbo.Products
	FOR SYSTEM_TIME ALL
	ORDER BY ProductID, ValidFrom;



/*
	Cleanup
	*******
*/

USE master;
DROP DATABASE TemporalDemo;

