--Write and Test the following requests using the Northwind Database

--List the expected results (number of rows returned/affected; columns and values) 
--before writing anything

--Ex 1
--List the OrderID, CustomerID and OrderDate of all Orders that were placed
--on or before 31 December 1996 sorted in 
--ascending order of OrderDate within CustomerID.

--Ex 2 
--List the OrderID, CustomerID and OrderDate of all Orders that were placed 
--between 16/06/1997 and 20/06/1997 sorted in ascending order OrderDate

--Ex 3 
--List all the data for all Products where the the ReorderLevel is greater 
--than 25 sorted in descending order of UnitsInStock.

--Ex 4 
--List the CompanyName, ContactName, Country, Region and Phone of Customers 
--whose Region is specified sorted in ascending order of Region within Country.

--Ex 5 
--List the distinct Company Names of Customers who place their orders with 
--employees whose last names are either “Davolio” or “Fuller”. 

--Ex 6 
--List the ProductName and UnitPrice of all Products with a CategoryID 
--of 2 or 3 together with a NewUnitPrice (rounded to 2 decimal places) 
--calculated by adding 3% to the UnitPrice, sorted in ascending order of ProductName.


--Ex 7 
--Show the total value of all the products currently held in stock with no decimal places.

--Ex 8 
--Show the total number of Customers.

--Ex 9 
--List the CustomerID, CompanyName and the number of orders for each
--customer that has more than 20 orders grouping by CustomerID and CompanyName.

--Ex 10 
--List the CustomerID, CompanyName and the number of orders for the Customer
--that has the highest number of orders using appropriate grouping.

--Ex 11 
--List the CustomerID and CompanyName for all customers who have had
--no dealings with employees whose last names are either “Davolio” or “Fuller”.

--Ex 12 
--Add the following new customer:
--ALAVO, Al's Avocados, Alan Tracy, Owner, 34 Porridge Pot Alley, 
--Chelmsford, Essex, CM3 2BZ, UK, 01926 401697, 01926 401698

--Ex 13 
--Update all the UnitPrice’s for Products with an increase of 5%.

--Ex 14 
--List all the data for Products sorted in ascending order of ProductID.

--Ex 15 
--a) Add the following Region:
--5, Europe
--
--b Add the following Territories:
--09000, UK, 5
--09001, France, 5
----
--c) List all the territories in ascending order of TerritoryID.
--
--d) List all the regions in ascending order of RegionID.
--
--e) Imagine that some time has passed and the region with an 
--ID of 5 and all its associated territories needs to be removed 
--from the database. Delete the appropriate records.
--
--f) List all the territories in ascending order of TerritoryID.
--
--g) List all the regions in ascending order of RegionID.

--Ex 16 
--Produce a list of Products showing Percentage Raises, ProductID and 
--old and new UnitPrices. Products with a CategoryID of 1, 3 or 5 are 
--given a 5% rise, Products with a CategoryID of 2, 4 or 6 are given 
--a 10% rise and other Products should not be given a rise. Display 
--the results in ascending PercentageRaise sequence and display 
--the new UnitPrices with 2 decimal places.

--Ex 17 
--Create a new view for all employees who are managers only using 
--all the fields from the employee table. Include the EmployeeID, LastName, 
--FirstName, Title, TitleOfCourtesy, HomePhone, Extension and ReportsTo columns. 
-- Apply a CHECK constraint.

--Ex 18 
--Using the view for managers show all the fields for the manager(s) who 
--don’t report to anyone sorted in ascending order of EmployeeID.

--Ex 19 
--Grant the authority to all other users to access the view for 
--managers for SELECT statements only.

--Ex 20 
--Create an index named SHIP_CompanyName on the CompanyName field 
--in the Shippers table. Provide a printout showing that the 
--index has been created.
