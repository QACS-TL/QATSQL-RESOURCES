/*
SQLDEV

Lab 11 - Creating views
*/

--------------------- Exercise 1 - Creating views
-- Step 3

USE DEV_Database;
GO

SELECT 
	e.EventID, e.EventDate, c.Title, c.Duration, e.Location, cu.Name AS Customer,
	cu.Phone, cu.Email
	FROM Info.Events AS e
		INNER JOIN Info.Courses AS c
			ON e.CourseCode = c.CourseCode
		INNER JOIN Sales.Bookings AS B
			ON e.EventID = b.EventID
		INNER JOIN Sales.Customers AS cu
			ON b.AccountNo = cu.AccountNo;
GO

SELECT
	c.CourseCode, c.Title, c.Duration, c.Vendor, c.Description
	FROM Info.Courses AS c
	WHERE c.Duration <= 3;
GO

SELECT
	e.EventID, e.EventDate, c.Title, c.Vendor, c.Duration, e.Location
	FROM Info.Events AS e
		INNER JOIN Info.Courses AS c
			ON e.CourseCode = c.CourseCode
	WHERE e.EventDate < GETDATE();
GO

-- Step 4
--------------- add code below here to create the Sales.Coursebookings view
-- <insert your code here>

CREATE VIEW Sales.CourseBookings WITH SCHEMABINDING AS
	SELECT 
		e.EventID, e.EventDate, c.Title, c.Duration, e.Location, cu.Name AS Customer,
		cu.Phone, cu.Email
		FROM Info.Events AS e
			INNER JOIN Info.Courses AS c
				ON e.CourseCode = c.CourseCode
			INNER JOIN Sales.Bookings AS B
				ON e.EventID = b.EventID
			INNER JOIN Sales.Customers AS cu
				ON b.AccountNo = cu.AccountNo
GO


-- Step 5
--------------- add code below here for the Info.ShortCourses view
-- <insert your code here>
CREATE VIEW Info.ShortCourses AS
	SELECT
		c.CourseCode, c.Title, c.Duration, c.Vendor, c.Description
		FROM Info.Courses AS c
		WHERE c.Duration <= 3;
GO

-- Step 6
--------------- add code below here for the Info.PastEvents view
-- <insert your code here>
CREATE VIEW Info.PastEvents AS
	SELECT e.EventID, e.EventDate, c.Title, c.Vendor, c.Duration, e.Location
	FROM Info.Events AS e
		INNER JOIN Info.Courses AS c
			ON e.CourseCode = c.CourseCode
	WHERE e.EventDate < GETDATE();
GO

--------------------- Exercise 2 - Testing views
-- Step 1
SELECT * FROM Sales.CourseBookings;

-- Step 2
SELECT * FROM Info.ShortCourses;

-- Step 3
SELECT * FROM Info.ShortCourses WHERE Duration = 2;
GO

-- Step 4
SELECT * FROM Info.ShortCourses WHERE Duration = 5;
GO

-- Step 5
SELECT * FROM Info.PastEvents;
GO

--------------------- Exercise 3 - Testing views
-- Step 1
INSERT INTO Info.ShortCourses(CourseCode, Title, Duration, Vendor, Description)
	VALUES ('STI1','Short Course',2,'DEV_','A short description');
SELECT * FROM Info.ShortCourses;
GO

-- Step 2
INSERT INTO Info.ShortCourses(CourseCode, Title, Duration, Vendor, Description)
	VALUES ('STI2','Long Course',5,'DEV_','A long description');
SELECT * FROM Info.ShortCourses;
GO

-- Step 3
SELECT * FROM Info.Courses;
SELECT * FROM Info.ShortCourses;

-- Step 4
DELETE FROM Info.Courses WHERE CourseCode LIKE 'STI%';
GO


---------------------- Suggested answers

-- Step 4
--------------- add code below here for the Sales.Coursebookings view
CREATE VIEW Sales.CourseBookings WITH SCHEMABINDING AS
	SELECT 
		e.EventID, e.EventDate, c.Title, c.Duration, e.Location, cu.Name AS Customer,
		cu.Phone, cu.Email
		FROM Info.Events AS e
			INNER JOIN Info.Courses AS c
				ON e.CourseCode = c.CourseCode
			INNER JOIN Sales.Bookings AS B
				ON e.EventID = b.EventID
			INNER JOIN Sales.Customers AS cu
				ON b.AccountNo = cu.AccountNo
GO

-- Step 5
--------------- add code below here for the Info.ShortCourses view
CREATE VIEW Info.ShortCourses AS
	SELECT
		c.CourseCode, c.Title, c.Duration, c.Vendor, c.Description
		FROM Info.Courses AS c
		WHERE c.Duration <= 3
GO

-- Step 6
--------------- add code below here for the Info.PastEvents view
CREATE VIEW Info.PastEvents AS
	SELECT e.EventID, e.EventDate, c.Title, c.Vendor, c.Duration, e.Location
	FROM Info.Events AS e
		INNER JOIN Info.Courses AS c
			ON e.CourseCode = c.CourseCode
	WHERE e.EventDate < GETDATE()
GO