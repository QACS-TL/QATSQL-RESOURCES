/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 3 - Working with Databases

Demonstration - Review fragmentation and rebuild indexes
*/

/*
		STEP 1 - Create a database
		**************************
*/


--This database will be used within this demonstration.

CREATE DATABASE FragDemo;
GO

/*
		STEP 2 - Create a table
		***********************
*/


--This table, called FragTable, contains two columns...
--	RandomValues - a CHAR(10)
--	SomeText - a CHAR(200)

USE FragDemo;

CREATE TABLE FragTable
(
RandomValues CHAR(10)	NOT NULL,
FillerColumn	CHAR(200)
)

--Add a primary key constraint to the RandomValues column

ALTER TABLE FragTable
	ADD CONSTRAINT PK_RandomData
	PRIMARY KEY (RandomValues);
GO

/*
		STEP 3 - Check the fragmentation
		********************************
*/


--The following query displays fragmentation details for the index we have just created on the FragTable table.  There is currently no data, so there is no fragmentation.

SELECT
	OBJECT_NAME(ips.OBJECT_ID),
	i.Name,
	ips.index_id,
	index_type_desc,
	avg_fragmentation_in_percent,
	avg_page_space_used_in_percent,
	page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'DETAILED') AS ips
INNER JOIN sys.indexes AS i
	ON ips.object_id = i.object_id
	AND ips.index_id = i.index_id
WHERE i.name = 'PK_RandomData'
ORDER BY avg_fragmentation_in_percent DESC


/*
		STEP 4 - Insert some data
		*************************
*/


--The following query inserts 200 rows of data into the table.
--The data inserted is based on the NEWID() function, which is not sequential.
--As the data is being inserted into a primary key / clustered index, the data has to be sorted, and as a result the index will become fragmented.

INSERT dbo.FragTable
	VALUES (CONVERT(CHAR(10),CONVERT(VARCHAR(100),NEWID())),'A');
GO 200

SELECT * FROM FragTable;


/*
	STEP 5 - Review the fragmentation again
	***************************************
*/

--Run the query below to recheck the fragmentation of the index.  The numbers should show that the index is fragmented.

SELECT
	OBJECT_NAME(ips.OBJECT_ID),
	i.Name,
	ips.index_id,
	index_type_desc,
	avg_fragmentation_in_percent,
	avg_page_space_used_in_percent,
	page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'DETAILED') AS ips
INNER JOIN sys.indexes AS i
	ON ips.object_id = i.object_id
	AND ips.index_id = i.index_id
WHERE i.name = 'PK_RandomData'
ORDER BY avg_fragmentation_in_percent DESC

/*
		STEP 6 - Insert some more data
		******************************
*/

--The following query inserts 200 rows of data into the table.
--The data inserted is based on the NEWID() function, which is not sequential.
--As the data is being inserted into a primary key / clustered index, the data has to be sorted, and as a result the index will become fragmented.

INSERT dbo.FragTable
	VALUES (CONVERT(CHAR(10),CONVERT(VARCHAR(100),NEWID())),'A');
GO 200

SELECT * FROM FragTable;

/*
		STEP 7 - Review the fragmentation again
		***************************************
*/

--Run the query below to recheck the fragmentation of the index.  The numbers should show that the index is fragmented.

SELECT
	OBJECT_NAME(ips.OBJECT_ID),
	i.Name,
	ips.index_id,
	index_type_desc,
	avg_fragmentation_in_percent,
	avg_page_space_used_in_percent,
	page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'DETAILED') AS ips
INNER JOIN sys.indexes AS i
	ON ips.object_id = i.object_id
	AND ips.index_id = i.index_id
WHERE i.name = 'PK_RandomData'
ORDER BY avg_fragmentation_in_percent DESC


/*
		STEP 8 - Rebuild the index
		**************************
*/


--The following query rebuilds the index.

ALTER INDEX PK_RandomData ON FragTable REBUILD;

/*
		STEP 9 - Review the fragmentation again
		***************************************
*/

--Run the query below to recheck the fragmentation of the index.  The numbers should show that the index is now defragmented.

SELECT
	OBJECT_NAME(ips.OBJECT_ID),
	i.Name,
	ips.index_id,
	index_type_desc,
	avg_fragmentation_in_percent,
	avg_page_space_used_in_percent,
	page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'DETAILED') AS ips
INNER JOIN sys.indexes AS i
	ON ips.object_id = i.object_id
	AND ips.index_id = i.index_id
WHERE i.name = 'PK_RandomData'
ORDER BY avg_fragmentation_in_percent DESC


/*
		Cleanup
		*******
*/


--The following query drops the FragDemo database

USE Master;
DROP DATABASE FragDemo;
