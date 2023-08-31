/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 17 - Multi Statement Table-Valued Functions
***********************************************
*/

-- Base queries

---- Details of courses with preferred Vendor:

USE DEV_Database;
GO


--------------------- Exercise 1 - Creating multiline table-valued functions

-- Step 1 - Creating the Sales.SalesCoursePriority function

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


-- Step 4

---- Test 1

SELECT * FROM Sales.SalesCoursePriority('DEV_','');
GO

---- Test 2

SELECT * FROM Sales.SalesCoursePriority('Microsoft','SQL');
GO




