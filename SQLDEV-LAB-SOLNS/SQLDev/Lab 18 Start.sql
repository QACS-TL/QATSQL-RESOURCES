/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 18 - DML FOR / AFTER Trigger
********************************
*/

--------------------- Exercise 1 - Create a DML FOR or AFTER trigger

-- Step 3 - Create the Info.AggregatedAttendees table

USE DEV_Database;
GO

CREATE TABLE Info.AggregatedAttendees
	(
		CourseCode VARCHAR(20)	NOT NULL,
		AttendeeCount INT NOT NULL DEFAULT(0)
	);
GO

INSERT INTO Info.AggregatedAttendees
	SELECT CourseCode, COUNT(*) AS NumberAttendees
		FROM Sales.Bookings AS b
			INNER JOIN Info.Events AS e
				ON b.EventID = e.EventID
		GROUP BY CourseCode

SELECT * FROM Info.AggregatedAttendees;
GO

-- Step 4 - Create the I_IncreaseAttendees trigger

CREATE TRIGGER I_IncreaseAttendees
ON Sales.Bookings
FOR INSERT
AS
BEGIN
	SET NOCOUNT ON
	UPDATE t
		SET AttendeeCount = AttendeeCount + 1
		FROM inserted AS i
			INNER JOIN Info.Events AS e
				ON i.EventID = e.EventID
			INNER JOIN Info.Courses AS c
				ON e.CourseCode = c.CourseCode
			INNER JOIN Info.AggregatedAttendees AS t
				ON c.CourseCode = t.CourseCode;
END;
GO


-- Step 5 - Insert a new booking

INSERT INTO sales.Bookings (AccountNO, EventID) VALUES (4,2);
GO

-- Step 6 - Query the Info.AggregatedAttendees table

SELECT * FROM Info.AggregatedAttendees;

-- Step 7a - Try to add multiple bookings as a single transaction

SELECT * FROM Info.AggregatedAttendees
INSERT INTO Sales.Bookings (AccountNo, EventID) VALUES (4,2),(4,2),(4,2)
SELECT * FROM Info.AggregatedAttendees

-- Step 7b - Try to add a new course and a related event, then add a booking

EXEC Info.P_AddCourse @Code = 'DEV_TestNoAttendees', @Title='Test',
		@Vendor = 'ME_', @Duration = 2, @Description = 'Test course'
EXEC Info.P_AddEvent @EventDate = '2020/07/06', @CourseCode = 'DEV_TestNoAttendees', 
		@Location='Saturn'
DECLARE @NewEventID INT
SELECT @NewEventID = MAX(EventID) FROM Info.Events
INSERT INTO Sales.Bookings VALUES (2,@NewEventID)
SELECT * FROM Sales.Bookings
SELECT * FROM Info.AggregatedAttendees
DELETE FROM Sales.Bookings WHERE EventID = @NewEventID
GO

-- Step 8 - Modify the trigger

DROP TRIGGER Sales.I_IncreaseAttendees
GO

CREATE TRIGGER Sales.I_IncreaseAttendees
	ON Sales.Bookings
	FOR INSERT
	AS
	BEGIN
		SET NOCOUNT ON;
		MERGE INTO Info.AggregatedAttendees AS a
			USING (SELECT e.CourseCode, COUNT(*) AS Adding
					FROM Inserted AS i
						INNER JOIN Info.Events AS e
							ON i.EventID = e.EventID
					GROUP BY CourseCode) AS b
			ON a.CourseCode = b.CourseCode
			WHEN MATCHED THEN 
					UPDATE SET AttendeeCount=AttendeeCount+b.Adding
			WHEN NOT MATCHED THEN 
					INSERT VALUES (b.CourseCode, b.Adding);
	END
GO

-- Step 9 - Retest

SELECT * FROM Info.AggregatedAttendees

EXEC Info.P_AddCourse @Code = 'DEV_NewCourse2', @Title='Test2',
		@Vendor = 'ME_', @Duration = 2, @Description = 'Test course2'

EXEC Info.P_AddEvent @EventDate = '2020/07/06', @CourseCode = 'DEV_NewCourse2', 
		@Location='Mars'

DECLARE @NewEventID INT
SELECT @NewEventID = MAX(EventID) FROM Info.Events
INSERT INTO Sales.Bookings VALUES (2,@NewEventID)
SELECT * FROM Info.AggregatedAttendees
GO

SELECT * FROM Info.AggregatedAttendees
GO

DECLARE @NewEventID INT
SELECT @NewEventID = MAX(EventID) FROM Info.Events
INSERT INTO Sales.Bookings VALUES (2,@NewEventID),(2,@NewEventID),(2,@NewEventID);
GO

SELECT * FROM Info.AggregatedAttendees
GO
















