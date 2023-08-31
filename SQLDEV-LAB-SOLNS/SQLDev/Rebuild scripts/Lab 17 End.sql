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

/*
	Lab 8 - Unique Constraints and Foreign Keys
	*******************************************
*/

--Exercise 1

ALTER TABLE Info.Courses
	ADD CONSTRAINT UNQ_Courses_TitleVendor
	UNIQUE(Title,Vendor)
GO

--Exercise 2

-- Step 1a
ALTER TABLE Sales.Bookings
	ADD CONSTRAINT FK_Bookings_AccountNo
	FOREIGN KEY (AccountNo)
	REFERENCES Sales.Customers(AccountNo)
GO

-- Step 1b
ALTER TABLE Info.Events
	ADD CONSTRAINT FK_Events_CourseCode
	FOREIGN KEY (CourseCode)
	REFERENCES Info.Courses(CourseCode)
GO

-- Step 1c
ALTER TABLE Sales.Bookings
	ADD CONSTRAINT FK_Bookings_EventID
	FOREIGN KEY (EventID)
	REFERENCES Info.Events(EventID)
	ON DELETE CASCADE
GO

--Exercise 3

TRUNCATE TABLE Sales.Bookings
DELETE FROM Info.Events
DELETE FROM Info.Courses
DELETE FROM Sales.Customers
DBCC CHECKIDENT ('Info.Events',RESEED,1)
DBCC CHECKIDENT ('Sales.Customers',RESEED,1)
GO

INSERT Sales.Customers (Name, Phone, Email)
	VALUES 
		('Alan Apple', '123-4567', 'alan@alanapple.com'),
		('Bertha Banana', '234-5678', 'bertha@berthabanana.com'),
		('Colin Coconut', '345-6789', 'colin@colincoconut.com'),
		('Denise Date', '456-7890', 'denise@denisedate.com'),
		('Eric Egg', '567-8901', 'eric@ericegg.com'),
		('Fiona Fish', '678-9012', 'fiona@fionafish.com');
--SELECT * FROM Sales.Customers
GO

INSERT Info.Courses (CourseCode, Title, Vendor, Duration, Description)
	VALUES
		('DEV_TSQL', 'Querying Databases Using Transact-SQL', 'DEV_', 2, 'This course will provide you with the basic knowledge and skills to create queries using Transact-SQL. It will teach you how to select, filter and sort data from multiple tables and how to use views and stored procedures.'),
		('DEV_TSQLDEV', 'Microsoft SQL Server Database Development Fundamentals', 'DEV_', 3, 'In this course you will learn the fundamentals of designing and building a database in SQL Server.'),
		('M20761', 'Querying Databases Using Transact-SQL', 'Microsoft', 5, 'This course is designed to introduce students to Transact-SQL. It is designed in such a way that the first three days can be taught as a course to students requiring the knowledge for other courses in the SQL Server curriculum. Days 4 & 5 teach the remaining skills required to take exam 70-761.'),
		('SFADX201', 'Administrative Essentials for New Admins in Lightning Experience', 'Salesforce', 5, 'Extensive and interactive, Administrative Essentials in Lightning Experience is the core training that ensures your success with Salesforce Lightning.  It is a must for new administrators, and we recommend completing this course before starting a Salesforce deployment or when taking over an existing deployment.'),
		('DEV_PBIDESK', 'Power BI Desktop for Technical Users', 'DEV_', 2, 'This course will provide you with the basic knowledge and skills to import / ingest data, create a model and create visualisations using Power BI Desktop.'),
		('MAZ103', 'Microsoft Azure Administrator', 'Microsoft', 5, 'This course teaches IT Professionals how to manage their Azure subscriptions, create and scale virtual machines, implement storage solutions, configure virtual networking, back up and share data, connect Azure and on-premises sites, manage network traffic, implement Azure Active Directory, secure identities, and monitor your solution.');
--SELECT * FROM Info.Courses
GO

INSERT Info.Courses (CourseCode, Title, Vendor, Description)
	VALUES
		('DEV_P2FP', 'PRINCE2:2017 Foundation and Practitioner (inc Exams)', 
		'DEV_', 'PRINCE2 is one of the world’s most widely used project management methods. Based on best practice, the method can be applied to any project irrespective of its size, industry sector, geographic location or culture. This course provides a definitive understanding of PRINCE2.');
--SELECT * FROM Info.Courses;
GO

INSERT Info.Events (EventDate, CourseCode, Location)
	VALUES
		('20200608', 'SFADX201', 'Manchester Street'),
		('20200608', 'M20761', 'London Road'),
		('20200608', 'DEV_TSQL', 'Glasgow Street'),
		('20200610', 'DEV_TSQLDEV', 'Glasgow Street'),
		('20200615', 'DEV_PBIDESK', 'Birmingham Grove');
--SELECT * FROM Info.Events
GO

INSERT Sales.Bookings (AccountNo, EventID)
	VALUES
		(1, 5),
		(2, 2),
		(3, 5),
		(4, 1),
		(5, 3),
		(6, 4);
GO

--SELECT * FROM Sales.Bookings
DELETE Info.Events WHERE EventID = 3;
--SELECT * FROM Sales.Bookings
GO

/*
	Lab 9 - Rowstore Indexes
	************************
*/

USE DEV_Database;
GO

CREATE INDEX IX_NamePhoneEmail
ON Sales.Customers (Name, Phone, Email);
GO

CREATE INDEX IX_Email
	ON Sales.Customers (Email);
GO

CREATE INDEX IX_Phone
ON Sales.Customers(Phone);
GO

CREATE INDEX IX_Vendor
ON Info.Courses (Vendor) INCLUDE (CourseCode, Duration);
GO

CREATE INDEX IX_AccountNo
ON Sales.Bookings (AccountNo);
GO

CREATE INDEX IX_EventID
ON Sales.Bookings (EventID);
GO

CREATE INDEX IX_CourseCodeEventDateLocation
ON Info.Events (CourseCode, EventDate) INCLUDE(Location);
GO

CREATE INDEX IX_CourseCode
ON Info.Events (CourseCode);
GO

/*
	Lab 11 - Creating Views
	***********************
*/

USE DEV_Database;
GO

CREATE VIEW Sales.CourseBookings WITH SCHEMABINDING AS
	SELECT 
		e.EventID, e.EventDate, c.Title, c.Vendor, c.Duration, e.Location, cu.Name AS Customer,
		cu.Phone, cu.Email
		FROM Info.Events AS e
			INNER JOIN Info.Courses AS c
				ON e.CourseCode = c.CourseCode
			INNER JOIN Sales.Bookings AS B
				ON e.EventID = b.EventID
			INNER JOIN Sales.Customers AS cu
				ON b.AccountNo = cu.AccountNo;
GO

CREATE VIEW Info.ShortCourses AS
	SELECT
		c.CourseCode, c.Title, c.Duration, c.Vendor, c.Description
		FROM Info.Courses AS c
		WHERE c.Duration <= 3;
GO

CREATE VIEW Info.PastEvents AS
	SELECT e.EventID, e.EventDate, c.Title, c.Vendor, c.Duration, e.Location
	FROM Info.Events AS e
		INNER JOIN Info.Courses AS c
			ON e.CourseCode = c.CourseCode
	WHERE e.EventDate < GETDATE ();
GO

/*
	Lab 12 - Modifying Views
	************************
*/

USE DEV_Database;
GO


ALTER VIEW Info.ShortCourses
AS
SELECT
	c.CourseCode,
	c.Title,
	c.Duration,
	c.Vendor,
	c.Description
FROM Info.Courses AS c
WHERE Duration <= 3
WITH CHECK OPTION;
GO

ALTER VIEW Info.PastEvents
AS
SELECT
	e.EventID,
	e.EventDate,
	c.Title,
	c.Vendor,
	c.Duration,
	e.Location
FROM Info.Events AS e
JOIN Info.Courses AS c
	ON e.CourseCode = c.CourseCode
WHERE DATEADD(DAY, c.Duration, e.EventDate) < GETDATE();
GO

/*
	Lab 13 - Stored Procedures
	**************************
*/

USE DEV_Database;
GO

CREATE PROC Sales.P_CustomersWithoutEmail
AS 
SET NOCOUNT ON;
BEGIN
SELECT
	AccountNo,
	Name,
	Phone
FROM Sales.Customers
WHERE Email IS NULL
END;
GO

CREATE PROC Sales.P_SetNullEmailToNone
AS
SET NOCOUNT ON;
BEGIN
UPDATE Sales.Customers
SET Email = 'NONE'
WHERE Email IS NULL
END;
GO

INSERT INTO Sales.Customers (Name, Phone, Email)
VALUES ('Gordon Grape','987-6543', NULL);
GO

EXEC Sales.P_SetNullEmailToNone;
GO

/*
	Lab 14 - Stored Procedures and Parameters
	*****************************************
*/

USE DEV_Database;
GO

CREATE PROC Sales.P_AddCustomer
	@Name VARCHAR (50),
	@Phone VARCHAR (30) = NULL,
	@Email VARCHAR (50) = NULL
AS
INSERT INTO Sales.Customers (Name, Phone, Email)
	VALUES (@Name, @Phone, @Email);
GO

CREATE PROC Info.P_AddCourse
	@Code VARCHAR (20),
	@Title VARCHAR (100),
	@Vendor VARCHAR (20),
	@Duration INT,
	@Description VARCHAR(MAX)
AS
INSERT Info.Courses (CourseCode, Title, Vendor, Duration, Description)
VALUES (@Code, @Title, @Vendor, @Duration, @Description);
GO

CREATE PROC Info.P_AddEvent
	@EventDate DATETIME,
	@CourseCode VARCHAR (20),
	@Location VARCHAR (50)
AS
INSERT Info.Events (EventDate, CourseCode, Location)
VALUES (@EventDate, @CourseCode, @Location);
GO

CREATE PROC Sales.P_AddBooking
	@AccountNo INT,
	@EventID INT,
	@BookingID INT OUTPUT
AS
INSERT Sales.Bookings (AccountNo, EventID)
VALUES (@AccountNo, @EventID)
SELECT @BookingID = SCOPE_IDENTITY ();
GO

EXEC Sales.P_AddCustomer
	@Name = 'Ian Ice-Cream',
	@Phone = '876-5432',
	@Email = 'ian@icecream.com';
GO

EXEC Info.P_AddCourse
	@Code = 'DEV_TSQLPLUS',
	@Title = 'Intermediate Querying SQL Databases using T-SQL',
	@Vendor = 'DEV_',
	@Duration = 2,
	@Description = 'This …';
GO

EXEC Info.P_AddEvent 
	@EventDate = '2020/07/06',
	@CourseCode = 'DEV_TSQLPLUS',
	@Location = 'Leeds City Exchange';
GO

DECLARE @MyBooking INT -- required to return the OUTPUT
EXEC Sales.P_AddBooking
	@AccountNo = 2,
	@EventID = 1,
	@BookingID = @MyBooking OUTPUT
--PRINT 'Your booking has been added - please note your booking reference number is: ' + CAST (@MyBooking AS VARCHAR);
GO

/*
	Lab 15 - Scalar Functions
	*************************
*/

USE DEV_Database;
GO

CREATE FUNCTION Sales.TotalBookingsForCourse
	(@CourseCode VARCHAR (20))
RETURNS INT
AS
BEGIN
	DECLARE @BookingCount INT;
	SELECT @BookingCount = COUNT (*) 
	FROM Sales.Bookings AS b
	JOIN Info.Events AS e
		ON b.EventID = e.EventID
	WHERE e.CourseCode = @CourseCode;
	RETURN @BookingCount;
END;
GO

CREATE FUNCTION Sales.TotalDaysForCustomer
	(@AccountNo INT)
RETURNS INT
AS
BEGIN
	DECLARE @TotalDays INT
	SELECT @TotalDays = SUM(Duration)
	FROM Info.Courses AS c
	INNER JOIN Info.Events AS e
	ON c.CourseCode = e.CourseCode
	INNER JOIN Sales.Bookings AS b
	ON e.EventID = b.EventID
	WHERE b.AccountNo = @AccountNo;
	RETURN @TotalDays;
END;
GO

/*
	Lab 16 - Inline Table-Valued Functions
	**************************************
*/

USE DEV_Database;
GO

CREATE FUNCTION Sales.BookingInfo
	(@BookingID INT)
RETURNS TABLE
AS
RETURN (
SELECT	
	c.Name AS Customer,
	co.Title AS Course,
	co.Duration,
	co.Vendor,
	e.EventDate AS StartDate
FROM Sales.Customers AS c
JOIN sales.Bookings AS b
	ON c.AccountNo = b.AccountNo
JOIN Info.Events AS e
	ON e.EventID = b.EventID
JOIN Info.Courses AS co
	ON e.CourseCode = co.CourseCode
WHERE b.BookingID = @BookingID
);
GO

CREATE FUNCTION Sales.VendorSales
	(@Vendor VARCHAR (20))
RETURNS TABLE
AS
RETURN
(
SELECT
	b.BookingID AS BookingID,
	c.Name AS Customer,
	e.Location,
	e.EventDate AS StartDate,
	co.Title AS Course
FROM Sales.Bookings AS b
JOIN Sales.Customers AS c
	ON b.AccountNo = c.AccountNo
JOIN Info.Events AS e
	ON e.EventID = b.EventID
JOIN Info.Courses AS co
	ON co.CourseCode = e.CourseCode
WHERE co.Vendor = @Vendor);
GO

/*
	Lab 17 - Multi-Line Table Valued Functions
	******************************************
*/

USE DEV_Database;
GO

CREATE FUNCTION Sales.SalesCoursePriority
	(@Vendor VARCHAR (20), @SearchCriteria VARCHAR (100))
RETURNS @selectedCourses TABLE
	(CourseType VARCHAR (30), 
		CourseCode VARCHAR (20), 
		Title VARCHAR (100),
		Vendor VARCHAR (20), 
		Duration TINYINT, 
		Description VARCHAR(MAX))
AS
BEGIN
	INSERT INTO @selectedCourses
			SELECT '1-Chosen Vendor', CourseCode, Title, Vendor, 
							Duration, Description 
			FROM Info.Courses	
			WHERE Vendor = @Vendor AND 
							Description LIKE '%' + @SearchCriteria + '%'

	IF @@ROWCOUNT < 3
		INSERT INTO @selectedCourses
			SELECT '2-Alternative Supplier', CourseCode, Title, Vendor, 
							Duration, Description 
				FROM Info.Courses	
				WHERE NOT (Vendor = @Vendor) AND 
							Description LIKE '%' + @SearchCriteria + '%'
	RETURN
END;
GO


