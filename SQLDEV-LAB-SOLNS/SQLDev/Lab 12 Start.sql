/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 12 - Modifying views
************************
*/

--------------------- Exercise 1 - Altering views

-- Step 3 - Alter the Info.ShortCourses view using WITH CHECK OPTION

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

-- Step 4 - Alter the Info.PastEvents view

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

--------------------- Exercise 2 - Testing the views

-- Step 1 - Attempt to insert a new course into the Info.ShortCourses view.  The first insert will succeed, but the second will fail.

INSERT Info.ShortCourses (CourseCode, Title, Duration, Vendor, Description)
VALUES ('ST11', 'Short Course', 2, 'DEV_', 'A short course');
GO
INSERT Info.ShortCourses (CourseCode, Title, Duration, Vendor, Description)
VALUES ('ST12', 'Long Course', 5, 'DEV_', 'A long course');
GO



