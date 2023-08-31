/*
Mod 03 Lab D Ex 1
1. Create a new database, table and insert data
2. Execute DML statements to fragment the indexes
3. Review page content
4. Review fragmentation of the clustered index
5. Rebuild the clustered index
6. Review fragmentation of the clustered index
*/

--- Create Mod03LabD database
CREATE DATABASE Mod03LabD ON PRIMARY
	(NAME = 'Mod03LabDDB',
	--FILENAME = 'F:\Mod03LabD.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod03LabD.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod03LabDLog',
	--FILENAME = 'G:\Mod03LabD.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod03LabD.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

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

INSERT INTO dbo.SampleTable
	SELECT LEFT(CONVERT(VARCHAR(100),NEWID()),30),REPLICATE('A',1500)
GO 100

SELECT * FROM dbo.SampleTable
GO

--- Review pages allocated in the SampleTable
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

--- Review the index fragmentation of the clustered index
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

--- Rebuild the clustered index
ALTER INDEX Clust_ReferenceIndex ON SampleTable REBUILD
GO

--- Review the index fragmentation of the clustered index after rebuild
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

--- Review pages allocated in the SampleTable after rebuild
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

--- Clean-up module 03
USE MASTER
IF EXISTS (SELECT * FROM sys.databases WHERE Name = 'Mod03LabA')
	DROP DATABASE Mod03LabA
IF EXISTS (SELECT * FROM sys.databases WHERE Name = 'Mod03LabC')
	DROP DATABASE Mod03LabC
IF EXISTS (SELECT * FROM sys.databases WHERE Name = 'Mod03LabD')
	DROP DATABASE Mod03LabD









