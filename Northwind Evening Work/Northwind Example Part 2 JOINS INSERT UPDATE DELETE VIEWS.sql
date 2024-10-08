--Write and Test the following requests using the Northwind Database

--List the expected results (number of rows returned/affected; columns and values) 
--before writing anything


--Ex 1
--List the distinct Company Names of Customers who place their orders with 
--employees whose last names are either “Davolio” or “Fuller”. 

--Ex 2 
--Add the following new customer:
--ALAVO, Al's Avocados, Alan Tracy, Owner, 34 Porridge Pot Alley, 
--Chelmsford, Essex, CM3 2BZ, UK, 01926 401697, 01926 401698

--Ex 3 
--Update all the UnitPrice’s for Products with an increase of 5%.

--Ex 4 
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

--Ex 5 
--Create a new view for all employees who are managers only using 
--all the fields from the employee table. Include the EmployeeID, LastName, 
--FirstName, Title, TitleOfCourtesy, HomePhone, Extension and ReportsTo columns. 
-- Apply a CHECK constraint.

--Ex 6 
--Using the view for managers show all the fields for the manager(s) who 
--don’t report to anyone sorted in ascending order of EmployeeID.

--Ex 7 
--Grant the authority to all other users to access the view for 
--managers for SELECT statements only.
