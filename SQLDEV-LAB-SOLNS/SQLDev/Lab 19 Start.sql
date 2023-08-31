/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 19 - DML Instead Of Trigger
*******************************
*/

--------------------- Exercise 1 - Creating a DML INSTEAD OF trigger

-- Step 3 - Alter the definition of the Info.Courses table

USE DEV_Database;
GO
ALTER TABLE Info.Courses 
ADD Discontinued BIT NOT NULL DEFAULT(0);
GO

-- Step 4 - Create an INSTEAD OF trigger

CREATE TRIGGER IO_DeleteCourse
ON Info.Courses
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON
	UPDATE Info.Courses
	SET Discontinued = 1
	FROM Info.Courses 
	JOIN deleted
	ON Info.Courses.CourseCode = deleted.CourseCode;
END;

-- Step 5 - Query the Info.Courses table

SELECT * FROM Info.Courses;

-- Step 6 - Add a new course, then delete it.

EXEC Info.P_AddCourse 
@Code = 'DEV_DemoNotDelete', 
@Title='DoNotDelete',
	@Vendor = 'ME_', 
@Duration = 2, 
@Description = 'Test course'

DELETE FROM Info.Courses WHERE CourseCode = 'DEV_DemoNotDelete'

SELECT * FROM Info.Courses








