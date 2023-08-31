/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 11 - Creating views
***********************
*/

--------------------- Exercise 1 - Creating views

-- Step 3 - Base queries

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

-- Step 4 - Create the Sales.Coursebookings view

-- <insert your code here>




-- Step 5 - Create the Info.ShortCourses view

-- <insert your code here>





-- Step 6 - Create the Info.PastEvents view

-- <insert your code here>




--------------------- Exercise 2 - Testing views

-- Step 1 - Test the Sales.CourseBookings view

SELECT * FROM Sales.CourseBookings;

-- Step 2 - Test the Info.ShortCourses view

SELECT * FROM Info.ShortCourses;

-- Step 3
SELECT * FROM Info.ShortCourses WHERE Duration = 2;
GO

-- Step 4 - Test the Info.Shortcourses view

SELECT * FROM Info.ShortCourses WHERE Duration = 5;
GO

-- Step 5 - Test the Info.PastEvents view

SELECT * FROM Info.PastEvents;
GO

--------------------- Exercise 3 - Editing rows through views

-- Step 1 - Insert a new course to the Info.ShortCourses view

INSERT INTO Info.ShortCourses(CourseCode, Title, Duration, Vendor, Description)
	VALUES ('STI1','Short Course',2,'DEV_','A short description');
SELECT * FROM Info.ShortCourses;
GO

-- Step 2 - Insert a course into the Info.ShortCourses view.  This will succeed, but the course will not appear in the view as it is too long.

INSERT INTO Info.ShortCourses(CourseCode, Title, Duration, Vendor, Description)
	VALUES ('STI2','Long Course',5,'DEV_','A long description');
SELECT * FROM Info.ShortCourses;
GO

-- Step 3 - Examine the table and the view

SELECT * FROM Info.ShortCourses;
SELECT * FROM Info.Courses;
GO

-- Step 4 - Remove the test courses

DELETE FROM Info.Courses WHERE CourseCode LIKE 'STI%';
GO


