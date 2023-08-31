/*
Mod 03 Lab D 
Review index fragmentation
*/

---------- Module 3 Lab D Execise 1 Step 3

CREATE DATABASE Mod03LabD ON PRIMARY
	(NAME = 'Mod03LabDDB',
	FILENAME = 'F:\Mod03LabD.mdf',	
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod03LabDLog',
	FILENAME = 'G:\Mod03LabD.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

---------- Module 3 Lab D Execise 1 Step 4

USE Mod03LabD
GO

CREATE TABLE dbo.SampleTable(
	ID INT IDENTITY PRIMARY KEY NONCLUSTERED,
	REFERENCEID VARCHAR(30) NOT NULL,
	FILLER VARCHAR(1500) -- used to fill pages
)
GO

CREATE CLUSTERED INDEX Clust_ReferenceIndex ON dbo.SampleTable(REFERENCEID)
GO

---------- Module 3 Lab D Execise 1 Step 5

INSERT INTO dbo.SampleTable
	SELECT LEFT(CONVERT(VARCHAR(100),NEWID()),30),REPLICATE('A',1500)
GO 100

SELECT * FROM dbo.SampleTable
GO

---------- Module 3 Lab D Execise 1 Step 6

select db_name(database_id) as DatabaseName, 
	OBJECT_NAME(object_id) TableName, 
	allocation_unit_type, 
	allocation_unit_type_desc, 
	allocated_page_file_id, 
	allocated_page_page_id 
from 
	sys.dm_db_database_page_allocations(
		db_id('Mod03LabD'),
		object_id('SampleTable'),
		NULL,NULL,'DETAILED')
where page_type = 1;
GO

---------- Module 3 Lab D Execise 1 Step 7

SELECT	O.Name as TableName, 
		I.Name as IndexName, 
		I.type_desc,
		PS.avg_fragmentation_in_percent,
		PS.page_count
	FROM sys.objects AS O
		INNER JOIN sys.indexes AS I
			ON O.object_id = I.object_id
		CROSS APPLY sys.dm_db_index_physical_stats(
						db_id('Mod03LabD'),
						O.object_id,
						I.index_id,
						0,
						null) AS PS
	WHERE O.Name = 'SampleTable'

---------- Module 3 Lab D Execise 2 Step 1

ALTER INDEX Clust_ReferenceIndex ON SampleTable REBUILD
GO

---------- Module 3 Lab D Execise 2 Step 2

SELECT	O.Name as TableName, 
		I.Name as IndexName, 
		I.type_desc,
		PS.avg_fragmentation_in_percent,
		PS.page_count
	FROM sys.objects AS O
		INNER JOIN sys.indexes AS I
			ON O.object_id = I.object_id
		CROSS APPLY sys.dm_db_index_physical_stats(
						db_id('Mod03LabD'),
						O.object_id,
						I.index_id,
						0,
						null) AS PS
	WHERE O.Name = 'SampleTable'

---------- Module 3 Lab D Execise 2 Step 3

select db_name(database_id) as DatabaseName, 
	OBJECT_NAME(object_id) TableName, 
	allocation_unit_type, 
	allocation_unit_type_desc, 
	allocated_page_file_id, 
	allocated_page_page_id 
from 
	sys.dm_db_database_page_allocations(
		db_id('Mod03LabD'),
		object_id('SampleTable'),
		NULL,NULL,'DETAILED')
where page_type = 1;
GO

---------- Module 3 Lab D Execise 2 Step 4

USE MASTER
IF EXISTS (SELECT * FROM sys.databases WHERE Name = 'Mod03LabA')
	DROP DATABASE Mod03LabA
IF EXISTS (SELECT * FROM sys.databases WHERE Name = 'Mod03LabC')
	DROP DATABASE Mod03LabC
IF EXISTS (SELECT * FROM sys.databases WHERE Name = 'Mod03LabD')
	DROP DATABASE Mod03LabD









