/*
ADMINISTERING MICROSOFT SQL SERVER (QASQLADMIN)
***********************************************

Module 8 - Data Security and Auditing

Demonstration - Implement Always Encrypted
*/

/*
	STEP 1 - Create a database for the demo
	***************************************
*/

USE master;
CREATE DATABASE AlwaysEncrypted;
GO

--Create a table and load it with data

USE AlwaysEncrypted;
SELECT 
	ProductID, Name, Color, ListPrice
INTO EncryptedTable
FROM AdventureWorks.Production.Product
WHERE ListPrice > 100
AND Color IS NOT NULL;
GO

/*
	STEP 2 - Query the initial data
	*******************************
*/

--Right click the query window.
--Click CONNECTION.
--Click CHANGE CONNECTION.
--Leave all options as they are on the first page.
--Click OPTIONS.
--Click the ALWAYS ENCRYPTED tab.
--Ensure that the option is UNCHECKED.
--Click CONNECT.

--Run the following query:

USE AlwaysEncrypted;
SELECT * FROM EncryptedTable;

--The query should return 194 rows and the data is readable.



/*
	STEP 3 - Create column master and column encryption keys
	********************************************************
*/

--In the Object Explorer, expand Databases \ AlwaysEncrypted \ Security \ Always Encrypted Keys
--Right-click COLUMN MASTER KEYS
--Click NEW COLUMN MASTER KEY
--In the NAME field, enter MK
--Click GENERATE CERTIFICATE.
--Click OK.
--Right-click COLUMN ENCRYPTION KEYS.
--Click NEW COLUMN ENCRYPTION KEY.
--In the NAME field, enter EK.
--Select the MK column master key from the dropdown.
--Click OK.



/*
	STEP 4 - Enable Always Encrypted on the ListPrice and Color columns
	*******************************************************************
*/

--In the Object Explorer, expand Databases \ AlwaysEncrypted \ Tables \ EncryptedTable 
--Right-click EncryptedTable and click ENCRYPT COLUMNS...
--On the INTRODUCTION page, click NEXT.
--On the COLUMN SELECTION page, click the checkbox next to COLOR. 
--In the ENCRYPTION TYPE column, select DETERMINISTIC.
--On the COLUMN SELECTION page, click the checkbox next to ListPrice.
--In the ENCRYPTION TYPE column, select RANDOMIZED.
--Click NEXT, NEXT, NEXT, FINISH.

/*
	STEP 5 - Test
	*************
*/

--Run the following query:

USE AlwaysEncrypted;
SELECT * FROM EncryptedTable;

--The query should return 194 rows.  This time, the data is encrypted.
--Note that the values in the Color column appear different, but look carefully...
--	All products with the word "red" in their name have the same value in the Color column.
--	This is because deterministic encryption was used.

--Attempt to find all of the red products.  This will fail.

SELECT * FROM EncryptedTable WHERE Color = 'red'

--Attempt to query the data using a GROUP BY clause on the Color column.
--This succeeds.

SELECT 
	color, count(*) 
FROM EncryptedTable
GROUP BY color;

--Attempt to find all products that cost more than £1000. This will fail.

SELECT * FROM EncryptedTable
WHERE ListPrice > 1000

--Attempt to query the data using a GROUP BY clause on the ListPrice column.
--This fails.  Data encrypted using randomized encryption cannot be included in a GROUP BY clause.

SELECT 
	ListPrice, count(*) 
FROM EncryptedTable
GROUP BY ListPrice;



/*
	Cleanup
	*******
*/

USE master;
DROP DATABASE AlwaysEncrypted;
