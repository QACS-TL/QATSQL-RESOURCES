/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 6 - Temporal tables
***********************
*/

-------- Exercise 1 - Create a new database for temporal tables

-- Step 3 - Create the TemporalDB database

SET NOCOUNT ON
IF DB_ID(N'TemporalDB') IS NULL
	CREATE DATABASE TemporalDB
GO

USE TemporalDB;
GO

-------- Exercise 2 - Create a Stock table with history

-- Step 1 - Create a history enabled table

CREATE TABLE dbo.Stock(
	ProductID nvarchar(20) PRIMARY KEY,
	QuantityInStock INT NOT NULL,
	QuantityLimit INT NOT NULL,
	SysStartTime DATETIME2(0) GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndTime DATETIME2(0) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(SysStartTime,SysEndTime)
)
WITH (
	SYSTEM_VERSIONING=ON
	(HISTORY_TABLE = dbo.StockHistory,
	HISTORY_RETENTION_PERIOD = 2 YEARS)
);
GO

-- Step 3 - Query the "live" and history tables

SELECT * FROM dbo.Stock;
SELECT * FROM dbo.StockHistory;
GO

-------- Exercise 3 - Load test data

-- Step 1 - Execute ALL of the code up to Step 2 below in one block to populate the dbo.Stock table with sample data.

INSERT INTO dbo.Stock(ProductID,QuantityInStock,QuantityLimit)
	VALUES
	('Widget1',59,5),('Widget2',23,2),('Gizmo1',120,0),
	('Gizmo2',35,5),('Gizmo3',10,10);

WAITFOR DELAY '00:00:02';

UPDATE dbo.Stock
	SET QuantityInStock=54, QuantityLimit=0
	WHERE ProductID='Widget1';

UPDATE dbo.Stock
	SET QuantityInStock=21, QuantityLimit=0
	WHERE ProductID='Widget2';

WAITFOR DELAY '00:00:02';

UPDATE dbo.Stock
	SET QuantityInStock=40, QuantityLimit=0
	WHERE ProductID='Widget1';

WAITFOR DELAY '00:00:02';

DELETE FROM dbo.Stock WHERE ProductID LIKE 'Gizmo%';
GO

-- Step 2 - Review the dbo.Stock table (2 records) and dbo.StockHistory table (5 records).

SELECT * FROM dbo.Stock;
SELECT * FROM dbo.StockHistory;
GO

-------- Exercise 4 - Temporal queries

-- Step 1 - View the full history of the dbo.Stock table (8 records).

SELECT *
	FROM dbo.Stock
	FOR SYSTEM_TIME ALL
	ORDER BY ProductID, SysStartTime;
GO

-- Step 2 - View the contents of the Stock table at the time of the last operation performed against it (2 records).

DECLARE @LatestEnd DATETIME2(0)
SELECT	@LatestEnd = MAX(SysEndTime) 
	FROM dbo.StockHistory;
SELECT *
	FROM dbo.Stock
	FOR SYSTEM_TIME AS OF @LatestEnd;
GO

-- Step 3 - View the contents of the Stock table one second before the last operation was performed against it (5 records).

DECLARE @BeforeLatestEnd DATETIME2(0)
SELECT	@BeforeLatestEnd = DATEADD(second,-1,MAX(SysEndTime))
	FROM dbo.StockHistory;
SELECT *
	FROM dbo.Stock
	FOR SYSTEM_TIME AS OF @BeforeLatestEnd;
GO

-- Step 4 - View the contents of the Stock table that were valid at any point between two specific points in time (8 records).

DECLARE @AfterEarliestStart DATETIME2(0)
DECLARE @BeforeLatestEnd DATETIME2(0)
SELECT	@AfterEarliestStart = DATEADD(second,1,MIN(SysStartTime)),
		@BeforeLatestEnd = DATEADD(second,-1,MAX(SysEndTime))
	FROM dbo.StockHistory;
SELECT *
	FROM dbo.Stock
	FOR SYSTEM_TIME BETWEEN @AfterEarliestStart AND @BeforeLatestEnd
	ORDER BY ProductID, SysStartTime;
GO

-- Step 5 - View the contents of the Stock table for rows that were wholly contained between two points in time (1 record).

DECLARE @EarliestStart DATETIME2(0)
DECLARE @BeforeLatestEnd DATETIME2(0)
SELECT	@EarliestStart = DATEADD(second,1,MIN(SysStartTime)),
		@BeforeLatestEnd = DATEADD(second,-1,MAX(SysEndTime))
	FROM dbo.StockHistory;
SELECT *
	FROM dbo.Stock
	FOR SYSTEM_TIME CONTAINED IN (@EarliestStart,@BeforeLatestEnd)
	ORDER BY ProductID, SysStartTime;
GO