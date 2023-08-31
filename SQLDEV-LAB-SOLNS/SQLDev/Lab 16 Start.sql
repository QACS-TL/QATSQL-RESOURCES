/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 16 - Inline Table-Valued Functions
**************************************
*/

-- Base queries

---- Details of a booking:

USE DEV_Database;
GO

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
WHERE b.BookingID = 3;
GO

--------------------- Exercise 1 - Creating table-valued functions

-- Step 3 - Create the Sales.SalesBookingInfo function

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


-- Step 4 - Create the Sales.VendorSales function

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


--------------------- Exercise 2 - Testing

--Step 1 - Test the functions

SELECT * FROM Sales.BookingInfo (3); 
GO

SELECT * FROM Sales.VendorSales ('DEV_')
GO

--------------------- Exercise 3 - Using CROSS APPLY

--Step 1 - Use CROSS APPLY

SELECT  b.*, bi.*
from Sales.Bookings AS b 
CROSS APPLY Sales.BookingInfo (b.BookingID) as bi






