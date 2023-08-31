/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 9 - Creating rowstore indexes
*********************************
*/

--------------------- Exercise 4 - Trial queries

--Step 3 - Review current indexes 

USE DEV_Database;
GO

SELECT S.name as SchemaName, O.name as TableName,
		I.name as IndexName, I.type_desc, ICol.Cols AS Columns
	FROM sys.schemas AS S
		INNER JOIN sys.objects AS O
			ON s.schema_id = O.schema_id
		INNER JOIN sys.indexes AS I
			ON O.object_id = I.object_id
		INNER JOIN (
			select IC.object_id, IC.index_id,
				string_agg(AC.name,',') WITHIN GROUP (ORDER BY Index_Column_ID ASC) AS Cols
					from sys.index_columns AS IC
						INNER JOIN sys.all_columns AS AC
							ON IC.object_id = AC.object_id AND IC.column_id = AC.column_id 
				group by IC.object_id, IC.index_id
		) AS ICol
			ON I.object_id = ICol.object_id AND I.index_id = ICol.index_id
	WHERE O.type = 'U'
	ORDER BY SchemaName, TableName,type_desc, IndexName

--Step 5 - Turn on IO statistics

SET STATISTICS IO ON;
GO


-- Query 1: 
---- Without index: logical read =221  , subtree cost = 0.92
---- With indexes : logical read =79  , subtree cost =  0.10
SELECT DISTINCT Email FROM Sales.Customers

-- Query 2: logical read =  , subtree code =
---- Without index: logical read =7  , subtree cost = 0.0068
---- With indexes : logical read =2  , subtree cost = 0.0033
SELECT Vendor, CourseCode, Duration
	FROM Info.Courses
	WHERE Vendor = 'Multi Ltd'

-- Query 3: 
---- Without index: logical read =221  , subtree cost = 0.186
---- With indexes : logical read = 4 , subtree cost = 
SELECT *
	FROM Sales.Customers
	WHERE Phone = '0129-555-0195'

-- Query 4: 
---- Without index: logical read =221  , subtree cost = 0.186
---- With indexes : logical read =  , subtree cost = 0.0083
SELECT *
	FROM Sales.Customers
	WHERE Name LIKE 'Bailey%'

-- Query 5: 
---- Without index: logical read =68  , subtree cost = 0.079
---- With indexes : logical read = 2 , subtree cost = 0.0033
SELECT EventDate, CourseCode, Location
	FROM Info.Events
	WHERE CourseCode = 'BK-R68R-44'
	ORDER BY EventDate

--------------------- Exercise 5 - Create indexes

-- Step 1 - Create a nonclustered index on the Sales.Customers table

-- <insert your code here>



-- Step 2 - Create a nonclustered index on the Sales.Customers table

-- <insert your code here>




-- Step 3 - Create a nonclustered index on the Sales.Customers table

-- <insert your code here>




-- Step 4 - Create a nonclustered index on the Info.Courses table

-- <insert your code here>




-- Step 5 - Create a nonclustered index on the Sales.Bookings table

-- <insert your code here>




-- Step 6 - Create a nonclustered index on the Sales.Bookings table

-- <insert your code here>




-- Step 7 - Create a nonclustered index on the Info.Events table

-- <insert your code here>




-- Step 8 - Create a nonclustered index on the Info.Events table

-- <insert your code here>




-- Step 9 - Review the indexes

SELECT S.name as SchemaName, O.name as TableName,
		I.name as IndexName, I.type_desc, ICol.Cols AS Columns
	FROM sys.schemas AS S
		INNER JOIN sys.objects AS O
			ON s.schema_id = O.schema_id
		INNER JOIN sys.indexes AS I
			ON O.object_id = I.object_id
		INNER JOIN (
			select IC.object_id, IC.index_id,
				string_agg(AC.name,',') WITHIN GROUP (ORDER BY Index_Column_ID ASC) AS Cols
					from sys.index_columns AS IC
						INNER JOIN sys.all_columns AS AC
							ON IC.object_id = AC.object_id AND IC.column_id = AC.column_id 
				group by IC.object_id, IC.index_id
		) AS ICol
			ON I.object_id = ICol.object_id AND I.index_id = ICol.index_id
	WHERE O.type = 'U'
	ORDER BY SchemaName, TableName,type_desc, IndexName


