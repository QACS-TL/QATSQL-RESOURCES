/*
	QASQLDEV - REBUILD SCRIPT
	*************************
*/

USE master;
GO

/*
	Lab 1 - Creating Databases
	**************************
*/

DROP DATABASE IF EXISTS DEV_UI, DEV_Database;
GO

--Ignored DEV_UI database as it is created graphically in the lab and is not used in the course.

--Exercise 2

CREATE DATABASE DEV_Database
ON PRIMARY
(
NAME = 'DEV_Database',
FILENAME = 'F:\DEV_Database.mdf',
SIZE = 100MB,
FILEGROWTH = 100MB,
MAXSIZE = 1000MB
)
LOG ON
(
NAME = 'DEV_Database_Log',
FILENAME = 'G:\DEV_Database_Log.ldf',
SIZE = 10MB,
FILEGROWTH = 10MB,
MAXSIZE = 100MB
);
GO

/*
	Lab 4 - Creating Tables and Schemas
	***********************************
*/

--Exercise 1

USE DEV_Database;
GO

CREATE SCHEMA Sales AUTHORIZATION dbo;
GO
CREATE SCHEMA Info AUTHORIZATION dbo;
GO

--Exercise 2

CREATE TABLE Sales.Customers
(
AccountNo	INT			NOT NULL	IDENTITY(1,1),
Name		VARCHAR(50)	NOT NULL,
Phone		VARCHAR(30)	NULL,
Email		VARCHAR(50)	NULL
);

CREATE TABLE Info.Courses
(
CourseCode	VARCHAR(20)		NOT NULL,
Title		VARCHAR(100)	NOT NULL,
Vendor		VARCHAR(20)		NOT NULL,
Duration	TINYINT			NOT NULL,
Description	VARCHAR(MAX)	NULL
);

CREATE TABLE Info.Events
(
EventID		INT			NOT NULL	IDENTITY(1,1),
EventDate	DATETIME	NOT NULL,
CourseCode	VARCHAR(20)	NOT NULL,
Location	VARCHAR(50)	NOT NULL
);

CREATE TABLE Sales.Bookings
(
BookingID	INT	NOT NULL	IDENTITY(1,1),
AccountNo	INT	NOT NULL,
EventID		INT	NOT NULL
);
GO

--Challenge exercises omitted as they don't create anything permanent in the database.


/*
	Lab 7 - Primary Key, Default and Check Constraints
	**************************************************
*/

USE DEV_Database;
GO

--Exercise 1

ALTER TABLE Sales.Customers
ADD CONSTRAINT PK_Customers_AccountNo
PRIMARY KEY (AccountNo);
GO

ALTER TABLE Info.Courses
ADD CONSTRAINT PK_Course_CourseCode
PRIMARY KEY (CourseCode);
GO

ALTER TABLE Sales.Bookings
ADD CONSTRAINT PK_Bookings_BookingID
PRIMARY KEY (BookingID);
GO

ALTER TABLE Info.Events
ADD CONSTRAINT PK_Events_EventID
PRIMARY KEY (EventID);
GO

--Exercise 2

ALTER TABLE Info.Courses
ADD CONSTRAINT DF_Courses_Duration
DEFAULT 5 FOR Duration
GO

ALTER TABLE Info.Events
ADD CONSTRAINT DF_Events_Location
DEFAULT 'Birmingham' FOR Location
GO

ALTER TABLE Info.Events
ADD CONSTRAINT DF_Events_EventDate
DEFAULT DATEADD (day,14, getdate()) FOR EventDate
GO

ALTER TABLE Info.Courses
ADD CONSTRAINT CHK_Courses_Duration
CHECK (Duration BETWEEN 1 AND 5)
GO

