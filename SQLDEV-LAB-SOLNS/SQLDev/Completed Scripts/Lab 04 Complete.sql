/*
SQLDEV

Lab 4 COMPLETE - Creating tables and schemas
*/

-- Exercise 1 - Create two schemas
-- Step 3
-- <insert your code here>
USE DEV_Database;
go


-- Step 4
-- <insert your code here>
CREATE SCHEMA Sales AUTHORIZATION dbo;
GO
CREATE SCHEMA Info AUTHORIZATION dbo;
GO

-- Step 5
SELECT S.name AS SchemaName, S.schema_id, DP.name AS OwnerName
	FROM sys.schemas AS S
		INNER JOIN sys.database_principals AS DP
			ON S.principal_id = DP.principal_id
	WHERE S.name IN ('Sales','Info');
GO

-- Exercise 2 - Create the tables
-- Step 1
-- <insert your code here>
CREATE TABLE Sales.Customers
(
AccountNo int NOT NULL IDENTITY(1,1),
Name varchar(50) NOT NULL,
Phone varchar(30) NULL,
Email varchar(50) NULL
);
GO


-- Step 3
-- <insert your code here>
CREATE TABLE Info.Courses
(
CourseCode varchar(20) NOT NULL,
Title varchar(100) NOT NULL,
Vendor varchar(20) NOT NULL,
Duration tinyint NOT NULL,
Description varchar(max) NULL
);
GO

-- Step 4
-- <insert your code here>
CREATE TABLE Sales.Bookings
(
BookingID int NOT NULL IDENTITY(1,1),
AccountNO int NOT NULL,
EventID int NOT NULL
);


-- Step 5
-- <insert your code here>
CREATE TABLE Info.Events
(
EventID int NOT NULL IDENTITY(1,1),
EventDate datetime NOT NULL,
CourseCode varchar(20) NOT NULL,
Location varchar(50) NOT NULL
);
GO


-- Step 6
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

-- Challenge exercise 1 - Change an objects schema
-- Step 1
ALTER SCHEMA Sales TRANSFER Info.Events;
GO

-- Step 2
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

-- Step 3
ALTER SCHEMA Info TRANSFER Sales.Events;
GO

-- Challenge exercise 2 - Table with computed column
-- Step 1
CREATE TABLE Info.CoursePrice
(
	CourseCode varchar(20),
	Price decimal(8,2),
	Tax decimal(4,2),
	Total as Price * (1+Tax)
);
GO

-- Step 2
INSERT INTO Info.CoursePrice(CourseCode,Price,Tax) 
	VALUES ('AAA',1200.00,0.20);
GO

-- Step 3
SELECT * FROM Info.CoursePrice;
GO

-- Step 5
DROP TABLE Info.CoursePrice;
GO














-------------------- Suggested answers

USE [DEV_Database]
GO

CREATE SCHEMA Sales AUTHORIZATION dbo
GO
CREATE SCHEMA Info AUTHORIZATION dbo
GO


CREATE TABLE Sales.Customers(
	AccountNo INT NOT NULL IDENTITY(1,1),
	Name VARCHAR(50) NOT NULL,
	Phone VARCHAR(30) NULL,
	Email VARCHAR(50) NULL
)

CREATE TABLE Info.Courses(
	CourseCode VARCHAR(20) NOT NULL,
	Title VARCHAR(100) NOT NULL,
	Vendor VARCHAR(20) NOT NULL,
	Duration TINYINT NOT NULL,
	Description VARCHAR(MAX) NULL
)

CREATE TABLE Info.Events(
	EventID INT NOT NULL IDENTITY(1,1),
	EventDate DATETIME NOT NULL,
	CourseCode VARCHAR(20) NOT NULL,
	Location VARCHAR(50) NOT NULL
)

CREATE TABLE Sales.Bookings(
	BookingID INT NOT NULL IDENTITY(1,1),
	AccountNo INT NOT NULL,
	EventID INT NOT NULL
)



