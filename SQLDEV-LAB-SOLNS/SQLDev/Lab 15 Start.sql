/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 15 - Scalar functions
**************************
*/

-- Base queries

---- Bookings for a course:
USE DEV_Database;
GO
SELECT  COUNT(*) AS NumberBookings
	FROM Sales.Bookings AS b
	INNER JOIN Info.Events AS e
		ON b.EventID = e.EventID
       WHERE e.CourseCode = 'DEV_TSQLDEV'

---- Total days booked by a customer:
SELECT SUM(Duration)
	FROM Info.Courses AS c
	INNER JOIN Info.Events AS e
	ON c.CourseCode = e.CourseCode
	JOIN Sales.Bookings AS b
	ON e.EventID = b.EventID
	WHERE b.AccountNo = 1;
GO


--------------------- Exercise 1 - Creating scalar functions

-- Step 3 - Create the Sales.TotalBookingsForCourse function

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


-- Step 4 - Create the Sales.TotalDaysForCustomer function

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

--------------------- Exercise 2 - Testing

--Step 1 - Test the functions

SELECT Sales.TotalBookingsForCourse('DEV_TSQLDEV') AS NumberBookings
GO

SELECT Sales.TotalDaysForCustomer(2) AS Days
GO



















--------------------- Suggested answers
-- Step 1
CREATE FUNCTION Sales.TotalBookingsForCourse
	(@CourseCode VARCHAR(20))
RETURNS INT
AS
BEGIN
	DECLARE @BookingCount INT;

	SELECT @BookingCount = COUNT(*) 
	FROM Sales.Bookings AS b
	JOIN Info.Events AS e
		ON b.EventID = e.EventID
	WHERE e.CourseCode = @CourseCode;

	RETURN @BookingCount;
END;

-- Step 2
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
