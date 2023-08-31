/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 14 - Stored procedures and parameters
*****************************************
*/

--------------------- Exercise 1 - Creating parameterised procedures

-- Step 3 - Create the Sales.P_AddCustomer procedure

-- <insert your code here>




-- Step 4 - Create the Info.P_AddCourse procedure

-- <insert your code here>




-- Step 5 - Create the Info.P_AddEvent procedure

-- <insert your code here>




-- Step 6 - Create the Sales.P_AddBooking procedure

-- <insert your code here>




--------------------- Exercise 2 - Testing

-- Step 1 - Execute each command individually to test your procedures

USE DEV_Database;
GO

EXEC sp_help 'Sales.P_AddCustomer'
GO

EXEC Sales.P_AddCustomer
	@Name = 'Ian Ice-Cream',
	@Phone = '876-5432',
	@Email = 'ian@icecream.com';
GO

--Check that Ian has been inserted

SELECT * FROM Sales.Customers
GO

--Test the Info.P_AddCourse procedure

EXEC sp_help 'Info.P_AddCourse'
GO

EXEC Info.P_AddCourse
	@Code = 'DEV_TSQLPLUS',
	@Title = 'Intermediate Querying SQL Databases using T-SQL',
	@Vendor = 'DEV_',
	@Duration = 2,
	@Description = 'This …' ;
GO

--Check that DEV_TSQLPLUS has been inserted.

SELECT * FROM Info.Courses

USE DEV_Database;
GO

EXEC sp_help 'Info.P_AddEvent'
GO

EXEC Info.P_AddEvent 
	@EventDate = '2020/07/06',
	@CourseCode = 'DEV_TSQLPLUS',
	@Location = 'Leeds City Exchange';
GO

--Check that the event has been added

SELECT * FROM Info.Events

-- Test the Sales.P_AddBooking procedure

--Run this code first to check the names of your parameters.
--You may need to substitute the parameters in the testing code with the parameter names you used.

USE DEV_Database;
GO

EXEC sp_help 'Sales.P_AddBooking'
GO

DECLARE @MyBooking INT -- required to return the OUTPUT
EXEC Sales.P_AddBooking
	@AccountNo = 2,
	@EventID = 1,
	@BookingID = @MyBooking OUTPUT
PRINT 'Your booking has been added - please note your booking reference number is: ' + CAST(@MyBooking AS VARCHAR);
GO

