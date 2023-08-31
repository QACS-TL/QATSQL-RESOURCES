--MOD XX - SMALL DATASET

-- Revert to the standard small dataset

USE Dev_Database;
GO

TRUNCATE TABLE Sales.Bookings;
DELETE FROM Info.Events;
DELETE FROM Info.Courses;
DELETE FROM Sales.Customers;
DBCC CHECKIDENT ('Info.Events',RESEED,0);
DBCC CHECKIDENT ('Sales.Customers',RESEED,0);
GO

INSERT Sales.Customers (Name, Phone, Email)
	VALUES 
		('Alan Apple', '123-4567', 'alan@alanapple.com'),
		('Bertha Banana', '234-5678', 'bertha@berthabanana.com'),
		('Colin Coconut', '345-6789', 'colin@colincoconut.com'),
		('Denise Date', '456-7890', 'denise@denisedate.com'),
		('Eric Egg', '567-8901', 'eric@ericegg.com'),
		('Fiona Fish', '678-9012', 'fiona@fionafish.com');
GO

INSERT Info.Courses (CourseCode, Title, Vendor, Duration, Description)
	VALUES
		('DEV_TSQL', 'Querying Databases Using Transact-SQL', 'DEV_', 2, 'This course will provide you with the basic knowledge and skills to create queries using Transact-SQL. It will teach you how to select, filter and sort data from multiple tables and how to use views and stored procedures.'),
		('DEV_TSQLDEV', 'Microsoft SQL Server Database Development Fundamentals', 'DEV_', 3, 'In this course you will learn the fundamentals of designing and building a database in SQL Server.'),
		('M20761', 'Querying Databases Using Transact-SQL', 'Microsoft', 5, 'This course is designed to introduce students to Transact-SQL. It is designed in such a way that the first three days can be taught as a course to students requiring the knowledge for other courses in the SQL Server curriculum. Days 4 & 5 teach the remaining skills required to take exam 70-761.'),
		('SFADX201', 'Administrative Essentials for New Admins in Lightning Experience', 'Salesforce', 5, 'Extensive and interactive, Administrative Essentials in Lightning Experience is the core training that ensures your success with Salesforce Lightning.  It is a must for new administrators, and we recommend completing this course before starting a Salesforce deployment or when taking over an existing deployment.'),
		('DEV_PBIDESK', 'Power BI Desktop for Technical Users', 'DEV_', 2, 'This course will provide you with the basic knowledge and skills to import / ingest data, create a model and create visualisations using Power BI Desktop.'),
		('MAZ103', 'Microsoft Azure Administrator', 'Microsoft', 5, 'This course teaches IT Professionals how to manage their Azure subscriptions, create and scale virtual machines, implement storage solutions, configure virtual networking, back up and share data, connect Azure and on-premises sites, manage network traffic, implement Azure Active Directory, secure identities, and monitor your solution.');
GO

INSERT Info.Courses (CourseCode, Title, Vendor, Description)
	VALUES
		('DEV_P2FP', 'PRINCE2:2017 Foundation and Practitioner (inc Exams)', 
		'DEV_', 'PRINCE2 is one of the world’s most widely used project management methods. Based on best practice, the method can be applied to any project irrespective of its size, industry sector, geographic location or culture. This course provides a definitive understanding of PRINCE2.');
GO

INSERT Info.Events (EventDate, CourseCode, Location)
	VALUES
		('20200608', 'SFADX201', 'Manchester Street'),
		('20200608', 'M20761', 'London Road'),
		('20200608', 'DEV_TSQL', 'Glasgow Street'),
		('20200610', 'DEV_TSQLDEV', 'Glasgow Street'),
		('20200615', 'DEV_PBIDESK', 'Birmingham Grove');
GO

INSERT Sales.Bookings (AccountNo, EventID)
	VALUES
		(1, 5),
		(2, 2),
		(3, 5),
		(4, 1),
		(5, 3),
		(6, 4);
GO

SELECT 'Bookings' AS TableName, COUNT(*) AS NumberOfRows FROM Sales.Bookings
UNION
SELECT 'Courses' AS TableName, COUNT(*) AS NumberOfRows FROM Info.Courses
UNION
SELECT 'Customers' AS TableName, COUNT(*) AS NumberOfRows FROM Sales.Customers
UNION
SELECT 'Events' AS TableName, COUNT(*) AS NumberOfRows FROM Info.Events;
GO


