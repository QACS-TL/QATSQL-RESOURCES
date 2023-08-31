/*
SQLDEV

Lab 9 - Creating rowstore indexes
*/

--------------------- Exercise 4 - Trial queries
USE DEV_Database;
GO

--Step 3

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

--step 5
SET STATISTICS IO ON;
GO


-- Query 1: 
---- Without index: logical read =221  , subtree cost = 0.92
---- With indexes : logical read =79  , subtree cost =  0.10
SELECT DISTINCT Email FROM Sales.Customers;
GO

-- Query 2: logical read =  , subtree code =
---- Without index: logical read =7  , subtree cost = 0.0068
---- With indexes : logical read =2  , subtree cost = 0.0033
SELECT Vendor, CourseCode, Duration
	FROM Info.Courses
	WHERE Vendor = 'Multi Ltd';
GO

-- Query 3: 
---- Without index: logical read =221  , subtree cost = 0.186
---- With indexes : logical read = 4 , subtree cost = 
SELECT *
	FROM Sales.Customers
	WHERE Phone = '0129-555-0195';
GO

-- Query 4: 
---- Without index: logical read =221  , subtree cost = 0.186
---- With indexes : logical read =  , subtree cost = 0.0083
SELECT *
	FROM Sales.Customers
	WHERE Name LIKE 'Bailey%';
GO

-- Query 5: 
---- Without index: logical read =68  , subtree cost = 0.079
---- With indexes : logical read = 2 , subtree cost = 0.0033
SELECT EventDate, CourseCode, Location
	FROM Info.Events
	WHERE CourseCode = 'BK-R68R-44'
	ORDER BY EventDate;
GO

--------------------- Exercise 5 - Create indexes
-- Step 1
-- <insert your code here>
CREATE INDEX IX_NamePhoneEmail
	ON Sales.Customers (Name, Phone, Email);
GO

-- Step 2
-- <insert your code here>
CREATE INDEX IX_Email
	ON Sales.Customers (Email);
GO

-- Step 3
-- <insert your code here>
CREATE INDEX IX_Phone
ON Sales.Customers(Phone);
GO

-- Step 4
-- <insert your code here>
CREATE INDEX IX_Vendor
ON Info.Courses (Vendor) INCLUDE (CourseCode, Duration);
GO

-- Step 5
-- <insert your code here>
CREATE INDEX IX_AccountNo
ON Sales.Bookings (AccountNo)
GO

-- Step 6
-- <insert your code here>
CREATE INDEX IX_EventID
ON Sales.Bookings (EventID)
GO

-- Step 7
-- <insert your code here>
CREATE INDEX IX_CourseCodeEventDateLocation
ON Info.Events (CourseCode,EventDate) INCLUDE (Location)
GO

-- Step 8
-- <insert your code here>
CREATE INDEX IX_CourseCode
ON Info.Events (CourseCode)
GO

-- Step 9
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
	ORDER BY SchemaName, TableName,type_desc, IndexName;
GO




