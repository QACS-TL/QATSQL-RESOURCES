/*
SQLDEV

Lab 13 - Stored procedures
*/

--------------------- Exercise 1 - Creating simple procedures
-- Step 3

USE DEV_Database;
GO

--<Add your code here>

CREATE PROC Sales.P_CustomersWithoutEmail
AS 
SET NOCOUNT ON;
BEGIN
SELECT
	AccountNo,
	Name,
	Phone
FROM Sales.Customers
WHERE Email IS NULL
END;
GO



-- Step 4

--<Add your code here>

CREATE PROC Sales.P_SetNullEmailToNone
AS
SET NOCOUNT ON;
BEGIN
UPDATE Sales.Customers
SET Email = 'NONE'
WHERE Email IS NULL
END;
GO




--------------------- Exercise 2 - Testing
-- Step 1
INSERT INTO Sales.Customers (Name, Phone, Email)
VALUES ('Gordon Grape','987-6543', NULL)
GO

EXEC Sales.P_CustomersWithoutEmail
GO

EXEC Sales.P_SetNullEmailToNone
GO

EXEC Sales.P_CustomersWithoutEmail
GO












----------- Suggested answers
CREATE PROC Sales.P_CustomersWithoutEmail
AS 
SET NOCOUNT ON;
BEGIN
SELECT
	AccountNo,
	Name,
	Phone
FROM Sales.Customers
WHERE Email IS NULL
END
GO



CREATE PROC Sales.P_SetNullEmailToNone
AS
SET NOCOUNT ON;
BEGIN
UPDATE Sales.Customers
SET Email = 'NONE'
WHERE Email IS NULL
END
GO

