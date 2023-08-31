/*
SQLDEV

Lab 14 - Stored procedures and parameters
*/

--------------------- Exercise 1 - Creating parameterised procedures
-- Step 3
-- <insert your code here>

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


-- Step 4
-- <insert your code here>

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

-- Step 5
-- <insert your code here>

CREATE PROC Info.P_AddEvent
	@EventDate DATETIME,
	@CourseCode VARCHAR (20),
	@Location VARCHAR (50)
AS
INSERT Info.Events (EventDate, CourseCode, Location)
VALUES (@EventDate, @CourseCode, @Location);
GO

-- Step 6
-- <insert your code here>

CREATE PROC Sales.P_AddBooking
	@AccountNo INT,
	@EventID INT,
	@BookingID INT OUTPUT
AS
INSERT Sales.Bookings (AccountNo, EventID)
VALUES (@AccountNo, @EventID)
SELECT @BookingID = SCOPE_IDENTITY ();
GO



--------------------- Exercise 2 - Testing
-- Step 1
USE DEV_Database;
GO

EXEC sp_help 'Sales.P_AddCustomer'
GO

EXEC Sales.P_AddCustomer
	@Name = 'Ian Ice-Cream',
	@Phone = '876-5432',
	@Email = 'ian@icecream.com';
GO

--Check that Ian has been inserted
SELECT * FROM Sales.Customers
GO

-- Step 2
EXEC sp_help 'Info.P_AddCourse'
GO

EXEC Info.P_AddCourse
	@Code = 'DEV_TSQLPLUS',
	@Title = 'Intermediate Querying SQL Databases using T-SQL',
	@Vendor = 'DEV_',
	@Duration = 2,
	@Description = 'This …' ;
GO

--Check that DEV_TSQLPLUS has been inserted.
SELECT * FROM Info.Courses

-- Step 3
USE DEV_Database;
GO

EXEC sp_help 'Info.P_AddEvent'
GO

EXEC Info.P_AddEvent 
	@EventDate = '2020/07/06',
	@CourseCode = 'DEV_TSQLPLUS',
	@Location = 'Leeds City Exchange';
GO

--Check that the event has been added

SELECT * FROM Info.Events

-- Step 4
USE DEV_Database;
GO

EXEC sp_help 'Sales.P_AddBooking'
GO

DECLARE @MyBooking INT -- required to return the OUTPUT
EXEC Sales.P_AddBooking
	@AccountNo = 2,
	@EventID = 1,
	@BookingID = @MyBooking OUTPUT
PRINT 'Your booking has been added - please note your booking reference number is: ' + CAST(@MyBooking AS VARCHAR);
GO

