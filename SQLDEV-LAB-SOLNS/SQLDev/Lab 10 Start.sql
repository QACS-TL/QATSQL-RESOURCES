/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 10 - Columnstore Indexes
****************************
*/

--------------------- Exercise 1 - Create a new database

-- Step 3 - Create the ColumnstoreDB database

CREATE DATABASE ColumnstoreDB ON PRIMARY
	(NAME = 'ColumnStoreDBMaster',
	FILENAME = 'F:\Columnstore.mdf')
LOG ON
	(NAME = 'ColumnStoreDBLog',
	FILENAME = 'G:\Columnstore.ldf');
GO

--------------------- Exercise 2 - Create sample and populate tables

-- Step 1 - Create three identical tables in the database

USE ColumnstoreDB;
GO

CREATE TABLE dbo.SalesClustered(
	SalesID INT,
	SalesDT DATETIME NOT NULL,
	SalesAmount MONEY,
	ColX INT,
	ColY INT,
	ColZ INT
) ON [PRIMARY];
GO

CREATE TABLE dbo.SalesClusteredWithNCColumnstore(
	SalesID INT,
	SalesDT DATETIME NOT NULL,
	SalesAmount MONEY,
	ColX INT,
	ColY INT,
	ColZ INT
) ON [PRIMARY];
GO

CREATE TABLE dbo.SalesColumnstoreClustered(
	SalesID INT,
	SalesDT DATETIME NOT NULL,
	SalesAmount MONEY,
	ColX INT,
	ColY INT,
	ColZ INT
) ON [PRIMARY];
GO

-- Step 2 - Insert the same rows into all three tables

SET NOCOUNT ON
CREATE TABLE #TempHoldingTable(
	SalesID INT,
	SalesDT DATETIME NOT NULL,
	SalesAmount MONEY,
	ColX INT,
	ColY INT,
	ColZ INT
) ON [PRIMARY];
GO

DECLARE @DT DATETIME = '20200101';
WHILE @DT < '2023/01/01'
	BEGIN
	INSERT INTO #TempHoldingTable(SalesDT,SalesAmount,ColX,ColY,ColZ)
		SELECT @DT, 100, year(@DT),month(@DT),day(@DT);
	SET @DT = DATEADD(day,1,@DT);
	END;
GO 20

INSERT INTO dbo.SalesClustered SELECT * FROM #TempHoldingTable;
INSERT INTO dbo.SalesClusteredWithNCColumnstore SELECT * FROM #TempHoldingTable;
INSERT INTO dbo.SalesColumnstoreClustered SELECT * FROM #TempHoldingTable;

DROP TABLE #TempHoldingTable;

-- Step 3 - Add indexes to the tables

CREATE CLUSTERED INDEX SalesClustered
	ON dbo.SalesClustered(SalesID);
GO

CREATE CLUSTERED INDEX SalesClusteredWithNCColumnstore1
	ON dbo.SalesClusteredWithNCColumnstore(SalesID);
GO

CREATE NONCLUSTERED COLUMNSTORE INDEX SalesClusteredWithNCColumnstore
	ON dbo.SalesClusteredWithNCColumnstore(SalesID, SalesDT, SalesAmount);
GO

CREATE CLUSTERED COLUMNSTORE INDEX SalesColumnstoreClustered
	ON dbo.SalesColumnstoreClustered;
GO

--Step 4 - Review the space used by the indexes

exec sp_spaceused 'dbo.SalesClustered';
exec sp_spaceused 'dbo.SalesClusteredWithNCColumnstore';
exec sp_spaceused 'dbo.SalesColumnstoreClustered';

--Step 6 - Enable IO statistics

SET STATISTICS IO ON;

-- Test query 1
SELECT COUNT(*) FROM dbo.SalesClustered;
SELECT COUNT(*) FROM dbo.SalesClusteredWithNCColumnstore;
SELECT COUNT(*) FROM dbo.SalesColumnstoreClustered;

-- Test query 2
SELECT SalesID, SalesDT, SalesAmount FROM dbo.SalesClustered WHERE SalesDT = '2022/12/03';
SELECT SalesID, SalesDT, SalesAmount FROM dbo.SalesClusteredWithNCColumnstore WHERE SalesDT = '2022/12/03';
SELECT SalesID, SalesDT, SalesAmount FROM dbo.SalesColumnstoreClustered WHERE SalesDT = '2022/12/03';

-- Test Query 3
SELECT SalesID, SalesDT, SalesAmount FROM dbo.SalesClustered WHERE ColY = 12;
SELECT SalesID, SalesDT, SalesAmount FROM dbo.SalesClusteredWithNCColumnstore WHERE ColY = 12;
SELECT SalesID, SalesDT, SalesAmount FROM dbo.SalesColumnstoreClustered WHERE ColY = 12;

-- Test Query 4
SELECT SalesDT, SUM(SalesAmount) AS ColumnstoreTotal
	FROM dbo.SalesClustered
	GROUP BY SalesDT;

SELECT SalesDT, SUM(SalesAmount) AS ColumnstoreTotal
	FROM dbo.SalesClusteredWithNCColumnstore
	GROUP BY SalesDT;

SELECT SalesDT, SUM(SalesAmount) AS ColumnstoreTotal
	FROM dbo.SalesColumnstoreClustered
	GROUP BY SalesDT;



