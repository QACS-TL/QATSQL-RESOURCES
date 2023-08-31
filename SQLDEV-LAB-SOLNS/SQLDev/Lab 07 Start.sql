/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 7 - Primary Key, Default and Check Constraints
**************************************************
*/

--Exercise 1 - Add Primary Keys

--Step 3 - Add primary keys to the columns specified in the table design and rules specified

-- <insert your code here>




--Exercise 2 - Add the default constraints

--Step 2 - Add the default constraints to the Info.Courses and Info.Events tables as specified in the design.

-- <insert your code here>




--Exercise 3 - Add the Check constraint

--Step 1 - Add the check constraint to the Info.Courses table.

-- <insert your code here>




-- Exercise 4 - Testing

--Step 1a - Test the Info.Events table Identity value.

USE DEV_Database;
GO

INSERT INTO Info.Events(CourseCode) VALUES ('ADB1234');
GO
SELECT * FROM Info.Events;
GO

--Step 1b - Test the default on the Info.Courses table.  The Duration should default to 5 days.


INSERT INTO Info.Courses(CourseCode, Title, Vendor, Description)
VALUES ('ADB1234','Beginners Archery','Sport4All','Shooting stuff');
GO
SELECT * FROM Info.Courses;
GO

--Step 1c - Test the Check constraint on the Info.Courses table.  Attempt to insert a course with a duration of 100 (this will fail)

INSERT INTO Info.Courses(CourseCode, Title, Vendor, Duration)
VALUES ('ADB1255','Abseiling','Sport4All',100);
GO

--Step 1d - Test the Primary Key on the Info.Courses table.  Attempt to insert a course with a duplicate course code (this will fail)

INSERT INTO Info.Courses(CourseCode, Title, Vendor, Description)
VALUES ('ADB1234','Advanced Archery','Sport4All','Shooting more stuff');
GO


--Challenge exercise (if time permits) - Email check

--Step 1 - Add a check constraint to the email column
-- <insert your code here>


--Step 2 - Testing

-- Successful
INSERT INTO Sales.Customers 
	VALUES ('Customer1','999', 'name1@company1.com');
GO

-- Failures
INSERT INTO Sales.Customers 
	VALUES ('No Name','888', '@company2.com');
GO

INSERT INTO Sales.Customers 
	VALUES ('Two Ats','777','name3@company3@com');
GO

INSERT INTO Sales.Customers 
	VALUES ('No Countries','666','name4@company4');
GO

--Step 3 - Remove the constraint

ALTER TABLE Sales.Customers
	DROP CONSTRAINT CHK_Customers_Email;
GO


