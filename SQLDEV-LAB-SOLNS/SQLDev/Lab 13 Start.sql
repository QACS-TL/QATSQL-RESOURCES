/*
QASQLDEV - Developing Databases on Microsoft SQL Server
*******************************************************
*/

/*
Lab 13 - Stored procedures
**************************
*/

--------------------- Exercise 1 - Creating simple procedures

-- Step 3 - Create the Sales.P_CustomersWithoutEmail procedure

USE DEV_Database;
GO

--<Add your code here>




-- Step 4 - Create the Sales.P_SetNullEmailToNone procedure

--<Add your code here>





--------------------- Exercise 2 - Testing

-- Step 1 - Test the two procedures

INSERT INTO Sales.Customers (Name, Phone, Email)
VALUES ('Gordon Grape','987-6543', NULL)
GO

EXEC Sales.P_CustomersWithoutEmail
GO

EXEC Sales.P_SetNullEmailToNone
GO

EXEC Sales.P_CustomersWithoutEmail
GO












