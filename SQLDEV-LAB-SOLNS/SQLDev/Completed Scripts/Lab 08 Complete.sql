/*
SQLDEV

Lab 8 - Unique constraints and foreign key
*/
-------- Exercise 1 - Add the unique constraint
USE DEV_Database;
GO

-- Step 3
-- <insert your code here>

------------- Suggested answers
ALTER TABLE Info.Courses
	ADD CONSTRAINT UNQ_Courses_TitleVendor
	UNIQUE(Title,Vendor)
GO


-------- Exercise 2 - Add the foreign keys
-- Step 1a, 1b and 1c
-- <insert your code here>

ALTER TABLE Sales.Bookings
	ADD CONSTRAINT FK_Bookings_AccountNo
	FOREIGN KEY (AccountNo)
	REFERENCES Sales.Customers(AccountNo)
GO

ALTER TABLE Info.Events
	ADD CONSTRAINT FK_Events_CourseCode
	FOREIGN KEY (CourseCode)
	REFERENCES Info.Courses(CourseCode)
GO

ALTER TABLE Sales.Bookings
	ADD CONSTRAINT FK_Bookings_EventID
	FOREIGN KEY (EventID)
	REFERENCES Info.Events(EventID)
	ON DELETE CASCADE
GO


-- Step 2
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE;
SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS;
GO

-------- Exercise 3 - Testing
--Step 1
USE DEV_Database;
GO

TRUNCATE TABLE Sales.Bookings;
DELETE FROM Info.Events;
DELETE FROM Info.Courses;
DELETE FROM Sales.Customers;
DBCC CHECKIDENT ('Info.Events',RESEED,1);
DBCC CHECKIDENT ('Sales.Customers',RESEED,1);
GO

--Step 2 - Insert initial Sales.Customers
INSERT Sales.Customers (Name, Phone, Email)
	VALUES 
		('Alan Apple', '123-4567', 'alan@alanapple.com'),
		('Bertha Banana', '234-5678', 'bertha@berthabanana.com'),
		('Colin Coconut', '345-6789', 'colin@colincoconut.com'),
		('Denise Date', '456-7890', 'denise@denisedate.com'),
		('Eric Egg', '567-8901', 'eric@ericegg.com'),
		('Fiona Fish', '678-9012', 'fiona@fionafish.com');
SELECT * FROM Sales.Customers;
GO

--Step 3 - Insert initial Info.courses
INSERT Info.Courses (CourseCode, Title, Vendor, Duration, Description)
	VALUES
		('DEV_TSQL', 'Querying Databases Using Transact-SQL', 'DEV_', 2, 'This course will provide you with the basic knowledge and skills to create queries using Transact-SQL. It will teach you how to select, filter and sort data from multiple tables and how to use views and stored procedures.'),
		('DEV_TSQLDEV', 'Microsoft SQL Server Database Development Fundamentals', 'DEV_', 3, 'In this course you will learn the fundamentals of designing and building a database in SQL Server.'),
		('M20761', 'Querying Databases Using Transact-SQL', 'Microsoft', 5, 'This course is designed to introduce students to Transact-SQL. It is designed in such a way that the first three days can be taught as a course to students requiring the knowledge for other courses in the SQL Server curriculum. Days 4 & 5 teach the remaining skills required to take exam 70-761.'),
		('SFADX201', 'Administrative Essentials for New Admins in Lightning Experience', 'Salesforce', 5, 'Extensive and interactive, Administrative Essentials in Lightning Experience is the core training that ensures your success with Salesforce Lightning.  It is a must for new administrators, and we recommend completing this course before starting a Salesforce deployment or when taking over an existing deployment.'),
		('DEV_PBIDESK', 'Power BI Desktop for Technical Users', 'DEV_', 2, 'This course will provide you with the basic knowledge and skills to import / ingest data, create a model and create visualisations using Power BI Desktop.'),
		('MAZ103', 'Microsoft Azure Administrator', 'Microsoft', 5, 'This course teaches IT Professionals how to manage their Azure subscriptions, create and scale virtual machines, implement storage solutions, configure virtual networking, back up and share data, connect Azure and on-premises sites, manage network traffic, implement Azure Active Directory, secure identities, and monitor your solution.');
SELECT * FROM Info.Courses;
GO

--Step 6 - Test unique constraint
INSERT Info.Courses VALUES ('MTEST', 'Querying Databases Using Transact-SQL', 'Microsoft', 5, 'Test');
GO

--Step 7 - Test default
INSERT Info.Courses (CourseCode, Title, Vendor, Description)
	VALUES
		('DEV_P2FP', 'PRINCE2:2017 Foundation and Practitioner (inc Exams)', 
		'DEV_', 'PRINCE2 is one of the world’s most widely used project management methods. Based on best practice, the method can be applied to any project irrespective of its size, industry sector, geographic location or culture. This course provides a definitive understanding of PRINCE2.');
SELECT * FROM Info.Courses;
GO

--Step 8 - Test duration check (fails as the course duration is too short)
INSERT Info.Courses (CourseCode, Title, Vendor, Duration, Description)
	VALUES
		('DEV_SHORT', 'Short Course', 'DEV_', 0, 'This course is too short and cannot be inserted.');
SELECT * FROM Info.Courses;
GO

--Step 9 - Test duration check (fails as the course duration is too long)
INSERT Info.Courses (CourseCode, Title, Vendor, Duration, Description)
	VALUES
		('DEV_LONG', 'Long Course', 'DEV_', 10, 'This course is too long and cannot be inserted.');
SELECT * FROM Info.Courses;
GO

--Step 10 - Initial insert of events
INSERT Info.Events (EventDate, CourseCode, Location)
	VALUES
		('20200608', 'SFADX201', 'Manchester Street'),
		('20200608', 'M20761', 'London Road'),
		('20200608', 'DEV_TSQL', 'Glasgow Street'),
		('20200610', 'DEV_TSQLDEV', 'Glasgow Street'),
		('20200615', 'DEV_PBIDESK', 'Birmingham Grove');
SELECT * FROM Info.Events;
GO

--Step 11 - Test PK-FK constraint
INSERT Info.Events (EventDate, CourseCode, Location)
	VALUES
		('20200622', 'ABC123', 'London Road');
GO

--Step 12 - Insert initial sales.bookings
INSERT Sales.Bookings (AccountNo, EventID)
	VALUES
		(1, 5),
		(2, 2),
		(3, 5),
		(4, 1),
		(5, 3),
		(6, 4);
GO

--Step 13 - Test PK-FK constraint
INSERT Sales.Bookings (AccountNo, EventID)
	VALUES (1, 99);
GO

--Step 14 - Test PK-FK constraint
INSERT Sales.Bookings (AccountNo, EventID)
	VALUES (99, 1);
GO

--Step 15 - Test PK-FK constraint (no cascade delete)
SELECT * FROM Sales.Bookings
DELETE Sales.Customers WHERE AccountNo = 1;
GO

--Step 16 - Test PK-FK constraint (cascade delete)
SELECT * FROM Sales.Bookings
DELETE Info.Events WHERE EventID = 3;
SELECT * FROM Sales.Bookings
GO




