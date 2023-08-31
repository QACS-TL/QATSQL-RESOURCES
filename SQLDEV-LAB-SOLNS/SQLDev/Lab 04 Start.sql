/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 4 - Creating Tables and Schemas
***********************************
*/

-- Exercise 1 - Create two schemas

-- Step 3 - Connect to the DEV_Database database
-- <insert your code here>




-- Step 4 - Create the Sales and Info schemas, owned by dbo
-- <insert your code here>




-- Step 5 - Check that the schemas have been added

SELECT S.name AS SchemaName, S.schema_id, DP.name AS OwnerName
	FROM sys.schemas AS S
		INNER JOIN sys.database_principals AS DP
			ON S.principal_id = DP.principal_id
	WHERE S.name IN ('Sales','Info');
GO

-- Exercise 2 - Create the tables
-- Step 1 - Create the Sales.Customers table
-- <insert your code here>




-- Step 3 - Create the Info.Courses table
-- <insert your code here>




-- Step 4 - Create the Info.Events table
-- <insert your code here>




-- Step 5 - Create the Sales.Bookings table
-- <insert your code here>




-- Step 6 - Check that the tables and columns have been created
SELECT S.name as SchemaName, O.name as TableName, AC.name AS ColumnName,
		T.name as TypeName , AC.max_length,
		AC.is_nullable, AC.is_identity
	FROM sys.schemas AS S
		INNER JOIN sys.objects AS O
			ON S.schema_id = O.schema_id
		INNER JOIN sys.all_columns AS AC
			ON O.object_id = AC.object_id
		INNER JOIN sys.types AS T
			ON AC.user_type_id = T.user_type_id
	WHERE O.type = 'U'
	ORDER BY S.name, O.name, AC.column_id;
GO



-- Challenge exercise 1 (if time permits) - Change an objects schema

-- Step 1 - Change the schema of the Info.Events table to Sales

ALTER SCHEMA Sales TRANSFER Info.Events;
GO

-- Step 2 - Check that the table has been moved

SELECT S.name as SchemaName, O.name as TableName, AC.name AS ColumnName,
		T.name as TypeName , AC.max_length,
		AC.is_nullable, AC.is_identity
	FROM sys.schemas AS S
		INNER JOIN sys.objects AS O
			ON S.schema_id = O.schema_id
		INNER JOIN sys.all_columns AS AC
			ON O.object_id = AC.object_id
		INNER JOIN sys.types AS T
			ON AC.user_type_id = T.user_type_id
	WHERE O.type = 'U'
	ORDER BY S.name, O.name, AC.column_id;
GO

-- Step 3 - Move the Sales.Events table back to the Info schema

ALTER SCHEMA Info TRANSFER Sales.Events


-- Challenge exercise 2 - Table with computed column

-- Step 1 - Create the Info.CoursePrice table

CREATE TABLE Info.CoursePrice
(
	CourseCode varchar(20),
	Price decimal(8,2),
	Tax decimal(4,2),
	Total as Price * (1+Tax)
);
GO

-- Step 2 - Insert a new row

INSERT INTO Info.CoursePrice(CourseCode,Price,Tax) 
	VALUES ('AAA',1200.00,0.20)

-- Step 3 - Review the table row

SELECT * FROM Info.CoursePrice

-- Step 5 - Drop the table

DROP TABLE Info.CoursePrice






