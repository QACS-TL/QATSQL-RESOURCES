/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 5 - Partitioning
********************
*/

-------- Exercise 1 - Create a new database for partitioning

-- Step 3 - Create the database

CREATE DATABASE PartitionedtableDW 
ON PRIMARY
	(
	NAME = 'PartDW_DB',
	FILENAME = 'F:\partdw.mdf',
	SIZE = 10mb,
	MAXSIZE = 20mb,
	FILEGROWTH = 5mb
	)
LOG ON
	(
	NAME = 'PartDW_LOG',
	FILENAME = 'G:\partdw.ldf',
	SIZE = 10mb,
	MAXSIZE = 20mb,
	FILEGROWTH = 5mb
	);
GO

USE PartitionedtableDW;
GO

-- Step 4 - Add three additional filegroups to the database

ALTER DATABASE [PartitionedTableDW]
	ADD FILEGROUP Over2Years;
ALTER DATABASE [PartitionedTableDW]
	ADD FILEGROUP OneTo2Years;
ALTER DATABASE [PartitionedTableDW]
	ADD FILEGROUP UnderAYear;
GO

-- Step 5 - Add three additional files to the database

ALTER DATABASE PartitionedtableDW
	ADD FILE
	(
	NAME = 'PartDW_Over2',
	FILENAME = 'J:\partdw2plus.ndf',
	SIZE = 10mb,  MAXSIZE = 20mb,  FILEGROWTH = 5mb
	)  TO FILEGROUP Over2years;
GO
ALTER DATABASE PartitionedtableDW
	ADD FILE 
	(
	NAME = 'PartDW_Over1Under2',
	FILENAME = 'J:\partdw1plus.ndf',
	SIZE = 10mb,  MAXSIZE = 20mb,  FILEGROWTH = 5mb
	) TO FILEGROUP OneTo2years;
GO
ALTER DATABASE PartitionedtableDW
	ADD FILE 
	(
	NAME = 'PartDW_Under1',
	FILENAME = 'K:\partdwminus1.ndf',
	SIZE = 10mb,  MAXSIZE = 20mb,  FILEGROWTH = 5mb
	) TO FILEGROUP UnderAYear;
GO


-------- Exercise 2 - Create a partition function and partition scheme

-- Step 1 - Create a partition function

USE [PartitionedTableDW];
GO

CREATE PARTITION FUNCTION SplitOnDate(DATETIME)
	AS RANGE RIGHT FOR VALUES 
	('2018/01/01','2019/01/01');
GO

-- Step 2 - Test the partitions using example values

SELECT $partition.SplitOnDate('2017/01/17');
SELECT $partition.SplitOnDate('2018/02/18');
SELECT $partition.SplitOnDate('2019/03/19');
SELECT $partition.SplitOnDate('2016/01/17');
SELECT $partition.SplitOnDate('2020/02/18');
SELECT $partition.SplitOnDate(NULL);
GO

-- Step 3 - Create a partition scheme

CREATE PARTITION SCHEME SplitOnDateScheme
	AS PARTITION SplitOnDate
	TO (Over2years,OneTo2Years,UnderAYear);
GO

-- Step 4 - Review filegroups, partition schemes and partitions

SELECT PS.name AS SchemeName, PF.name AS FunctionName, 
		DDS.destination_id, DS2.name AS FilegroupName
	FROM sys.partition_schemes AS PS
		INNER JOIN sys.partition_functions AS PF
			ON PS.function_id = PF.function_id
		INNER JOIN sys.data_spaces AS DS
			ON DS.data_space_id = PS.data_space_id
		INNER JOIN sys.destination_data_spaces AS DDS
			ON DS.data_space_id = DDS.partition_scheme_id
		INNER JOIN sys.data_spaces AS DS2
			ON DDS.data_space_id = DS2.data_space_id;
GO

-------- Exercise 3 - Create a table using the partition scheme

-- Step 1 - Create a FactSales table using the partition scheme

CREATE TABLE dbo.FactSales(
	SalesID INT NOT NULL,
	OrderDate DATETIME NOT NULL,
	CustomerID INT,
	ProductID INT
) ON SplitOnDateScheme(OrderDate);
GO

-- Step 2 - Add constraints to the table to limit allowable data values

ALTER TABLE dbo.FactSales
	ADD CONSTRAINT FS_DateCheck
	CHECK (OrderDate >= '2017/01/01' AND OrderDate <'2020/01/01');
GO

-- Step 3 - Add a primary key to the table

ALTER TABLE dbo.FactSales
	ADD CONSTRAINT PKFactSales
	PRIMARY KEY CLUSTERED (OrderDate, SalesID);
GO

-------- Exercise 4 - Load data to the table across the scheme

-- Step 1 - Insert sample data into the dbo.FactSales table

INSERT INTO dbo.FactSales VALUES (1,'2017/05/05',12,30);
INSERT INTO dbo.FactSales VALUES (2,'2018/03/03',10,3000);
INSERT INTO dbo.FactSales VALUES (3,'2019/01/01',12,3000);
INSERT INTO dbo.FactSales VALUES (4,'2019/04/01',1,3);
INSERT INTO dbo.FactSales VALUES (5,'2019/07/02',2,5);
INSERT INTO dbo.FactSales VALUES (6,'2019/08/08',412,80);
GO

-- Step 2 - Examine the IO data

SET STATISTICS IO ON;
SELECT * FROM dbo.FactSales;
SELECT * FROM dbo.FactSales
	WHERE OrderDate BETWEEN '2019/01/01' AND GETDATE();
GO

-- Step 3 - Review the number of rows in each partition of dbo.FactSales

SELECT O.name, P.partition_number, P.rows AS ApproxRows, 
		AU.total_pages, AU.used_pages, AU.data_pages
	FROM sys.objects AS O
		INNER JOIN sys.partitions AS P
			ON O.object_id = P.object_id
		INNER JOIN sys.allocation_units AS AU
			ON p.partition_id = au.container_id
	WHERE O.type = 'U';
GO

-------- Challenge Exercise (if time permits) - Switching partitions

-- Step 1 - Add an additional filegroup to the database

ALTER DATABASE [PartitionedTableDW]
	ADD FILEGROUP Latest;
GO

ALTER DATABASE [PartitionedTableDW]
	ADD FILE
	(NAME=N'PartDW_Latest',
FILENAME='K:\DW_Latest.ndf',
		SIZE = 8Mb, MAXSIZE=Unlimited, Filegrowth=64Mb)
	TO FILEGROUP Latest;
GO


-- Step 2 - Add the NewFactSales table

CREATE TABLE dbo.NewFactSales(
	SalesID INT NOT NULL,
	OrderDate DATETIME NOT NULL,
	CustomerID INT,
	ProductID INT
) ON Latest;
GO

-- Step 3 - Add constraints to the NewFactSales table

ALTER TABLE dbo.NewFactSales
	ADD CONSTRAINT NFS_DateCheck
	CHECK (OrderDate >= '2020/01/01' AND OrderDate <'2021/01/01');
GO

ALTER TABLE dbo.NewFactSales
	ADD CONSTRAINT PKNewFactSales
	PRIMARY KEY CLUSTERED (OrderDate, SalesID);
GO

-- Step 4 - Attempt to insert data into the NewFactSales table.  The first should succeed, but the second should fail as it violates the constraint.

INSERT INTO dbo.NewFactSales VALUES (2000,'2020/05/05',100,1000);
INSERT INTO dbo.NewFactSales VALUES (2001,'2018/03/03',100,1000);
GO

-- Step 5 - Specify that any new partitions will be stored on the Latest filegroup.

ALTER PARTITION SCHEME SplitOnDateScheme
	NEXT USED Latest;
GO

-- Step 6 - Split the function range

ALTER PARTITION FUNCTION SplitOnDate()
	SPLIT RANGE ('2020/01/01');
GO

-- Step 7 - Review the current partitions

SELECT O.name, P.partition_number, P.rows AS ApproxRows, 
		AU.total_pages, AU.used_pages, AU.data_pages
	FROM sys.objects AS O
		INNER JOIN sys.partitions AS P
			ON O.object_id = P.object_id
		INNER JOIN sys.allocation_units AS AU
			ON p.partition_id = au.container_id
	WHERE O.type = 'U';
GO

-- Step 8 - Alter the constraint on the dbo.FactSales table.

ALTER TABLE dbo.FactSales
	DROP CONSTRAINT FS_DateCheck;
GO

ALTER TABLE dbo.FactSales
	ADD CONSTRAINT FS_DateCheck
	CHECK (OrderDate >= '2017/01/01' AND OrderDate <'2021/01/01');
GO

-- Step 9 - Switch the NewFactSales table into partition 4 of the FactSales table.

ALTER TABLE dbo.NewfactSales
	SWITCH TO dbo.FactSales PARTITION 4;
GO

SELECT O.name, P.partition_number, P.rows AS ApproxRows, 
		AU.total_pages, AU.used_pages, AU.data_pages
	FROM sys.objects AS O
		INNER JOIN sys.partitions AS P
			ON O.object_id = P.object_id
		INNER JOIN sys.allocation_units AS AU
			ON p.partition_id = au.container_id
	WHERE O.type = 'U';
GO




