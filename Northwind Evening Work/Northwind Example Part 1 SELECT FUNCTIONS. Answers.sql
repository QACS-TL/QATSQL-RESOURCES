--Write and Test the following requests using the Northwind Database

--List the expected results (number of rows returned/affected; columns and values) 
--before writing anything

--Ex 1 
--List all the data for Products sorted in ascending order of ProductID.

select *
from Products
order by ProductID

--or

select 
	ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, 
	UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
from Products
order by ProductID

--Ex 2 
--List all the data for all Products where the the ReorderLevel is greater 
--than 25 sorted in descending order of UnitsInStock.

select * 
from Products 
where ReorderLevel > 25
order by UnitsInStock desc

--Ex 3 
--List the ProductName and UnitPrice of all Products with a CategoryID 
--of 2 or 3 together with a NewUnitPrice (rounded to 2 decimal places) 
--calculated by adding 3% to the UnitPrice, sorted in ascending order of ProductName.

SELECT ProductName, UnitPrice, 
   CAST(UnitPrice*1.03 AS decimal(18,2)) AS NewUnitPrice
FROM Products
WHERE CategoryID IN (2,3)
ORDER BY ProductName

select ProductName, UnitPrice, 
	   cast(round(UnitPrice*1.03, 2) as decimal(18, 2)) as NewPrice
from Products
where CategoryID in (2, 3)
order by ProductName


--Ex 4
--List the OrderID, CustomerID and OrderDate of all Orders that were placed
--on or before 31 December 1996 sorted in 
--ascending order of OrderDate within CustomerID.

Select OrderID, CustomerID, OrderDate
from Orders 
where OrderDate <=  '1996/12/31'  
order by CustomerID, OrderDate

--Ex 5 
--List the OrderID, CustomerID and OrderDate of all Orders that were placed 
--between 16/06/1997 and 20/06/1997 sorted in ascending order of OrderDate

select OrderID, CustomerID, OrderDate
from Orders
where OrderDate Between '1997/06/16' and '1997/06/20'
order by OrderDate


--Ex 6 
--List the CompanyName, ContactName, Country, Region and Phone of Customers 
--whose Region is specified sorted in ascending order of Region within Country.

select CompanyName, ContactName, Country, Region, Phone
from Customers
where Region is not NULL
order by Country, Region



--Ex 7 
--Produce a list of Products showing Percentage Raises, ProductID and 
--old and new UnitPrices. Products with a CategoryID of 1, 3 or 5 are 
--given a 5% rise, Products with a CategoryID of 2, 4 or 6 are given 
--a 10% rise and other Products should not be given a rise. Display 
--the results in ascending PercentageRaise sequence and display 
--the new UnitPrices with 2 decimal places.

-- remember hasn't asked for CategoryID

SELECT  ProductID, 
    UnitPrice as OldUnitPrice, percentraise = 5,
	cast(UnitPrice * 1.05 as decimal(19, 2)) as NewUnitPrice
FROM Products 
Where CategoryID in (1, 3, 5)
UNION
SELECT   ProductID, 
    UnitPrice as OldUnitPrice, percentraise = 10,
	cast(UnitPrice * 1.10 as decimal(19, 2)) as NewUnitPrice
FROM Products 
Where CategoryID in  (2, 4, 6)
UNION
SELECT  ProductID, 
     UnitPrice as OldUnitPrice, percentraise = 0, 
	 cast(UnitPrice as decimal(19, 2)) as NewUnitPrice 
FROM Products
Where CategoryID not between 1 and 6
ORDER BY PercentRaise ASC
-- Can also be done with CASE statement and Subquery

SELECT ProductID, UnitPrice As OldUnitPrice,
	CASE 
		WHEN CategoryID IN (2, 4, 6) THEN 10
		WHEN CategoryID IN (1, 3, 5) THEN 5
		ELSE 0
	END As PercentRaise,
	CASE
		WHEN CategoryID IN (2, 4, 6) THEN CAST(UnitPrice * 1.1 AS decimal(18,2))
		WHEN CategoryID IN (1, 3, 5) THEN CAST(UnitPrice * 1.05 AS decimal(18,2))
		ELSE 0
	END As NewPrice
FROM Products
ORDER BY PercentRaise ASC
