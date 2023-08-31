/*
SQLDEV

Lab 7 COMPLETE - Primary Key, Default and Check Constraints
*/

--Exercise 1 - Add Primary Keys

--Step 3
-- <insert your code here>

USE DEV_Database;
GO

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



--Exercise 2 - Add the default constraints
--Step 2
-- <insert your code here>

ALTER TABLE Info.Courses
ADD CONSTRAINT DF_Courses_Duration
DEFAULT 5 FOR Duration;
GO

ALTER TABLE Info.Events
ADD CONSTRAINT DF_Events_Location
DEFAULT 'Birmingham' FOR Location;
GO

ALTER TABLE Info.Events
ADD CONSTRAINT DF_Events_EventDate
DEFAULT DATEADD (DAY,14, GETDATE()) FOR EventDate;
GO



--Exercise 3 - Add the Check constraint
-- <insert your code here>

ALTER TABLE Info.Courses
ADD CONSTRAINT CHK_Courses_Duration
CHECK (Duration BETWEEN 1 AND 5);
GO



-- Exercise 4 - Testing

--Step 1a

USE DEV_Database;
GO

INSERT INTO Info.Events(CourseCode) VALUES ('ADB1234');
GO
SELECT * FROM Info.Events;
GO

--Step 1b

INSERT INTO Info.Courses(CourseCode, Title, Vendor, Description)
VALUES ('ADB1234','Beginners Archery','Sport4All','Shooting stuff');
GO
SELECT * FROM Info.Courses;
GO

--Step 1c (this will fail)

INSERT INTO Info.Courses(CourseCode, Title, Vendor, Duration)
VALUES ('ADB1255','Abseiling','Sport4All',100);
GO

--Step 1d (this will fail)

INSERT INTO Info.Courses(CourseCode, Title, Vendor, Description)
VALUES ('ADB1234','Advanced Archery','Sport4All','Shooting more stuff');
GO


--Challenge exercise (if time permits) - Email check

--Step 1 - Add a check constraint to the email column
-- <insert your code here>

ALTER TABLE Sales.Customers
ADD CONSTRAINT CHK_Customers_Email
CHECK (email LIKE ('_%@_%._%') 
	AND email NOT LIKE ('%[ ,#,%]%')
	AND email NOT LIKE ('%@%@%'));
GO


--Step 2 - testing

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

--Step 3 - remove the constraint

ALTER TABLE Sales.Customers
	DROP CONSTRAINT CHK_Customers_Email;
GO


