--Write and Test the following requests using the Northwind Database

--List the expected results (number of rows returned/affected; columns and values) 
--before writing anything

--Ex 1 
--Show the total value of all the products currently held in stock with no decimal places.

select  cast(round(SUM(UnitPrice * UnitsInStock), 0) as decimal(19, 0)) as TotalValueOfStock
from Products

select cast(round(SUM(UnitPrice * UnitsInStock), 0) as int) as TotalValueOfStock 
from Products

--Ex 2 
--Show the total number of Customers.

select COUNT(*) from Customers

--Ex 3 
--List the CustomerID, CompanyName and the number of orders for each
--customer that has more than 20 orders grouping by CustomerID and CompanyName.

select c.CustomerID, CompanyName, COUNT(OrderID) as NumberOfOrders
from Customers c
join Orders o on c.CustomerID = o.CustomerID
group by c.CustomerID, CompanyName
having COUNT(OrderID) > 20

--Ex 4 
--List the CustomerID, CompanyName and the number of orders for the Customer
--that has the highest number of orders using appropriate grouping.

--A little complex but it works (subquery with inline view)
select c.CustomerID, CompanyName, COUNT(c.CustomerID) as NumberOfOrders
from Customers c
join Orders o on c.CustomerID = o. CustomerID
group by c.CustomerID, CompanyName
having COUNT(OrderID) = 
(
	select  max(cnt)
	from (
		select CustomerID, cnt = count(CustomerID) 
		from Orders
		group by CustomerID
	) as CustomerWithMostOrders  -- inline view
)

-- OR!

select top 1 with ties c.CustomerID, CompanyName, COUNT(OrderID) as NumberOfOrders
from Customers c
join Orders o on c.CustomerID = o.CustomerID
group by c.CustomerID, CompanyName
order by NumberOfOrders desc

--Ex 5 
--List the CustomerID and CompanyName for all customers who have had
--no dealings with employees whose last names are either “Davolio” or “Fuller”.

select distinct o.CustomerID, c.CompanyName
from Orders o
join Customers c on o.CustomerID = c.CustomerID
where o.CustomerID not in
(
	select distinct CustomerID
	from Orders o
	join Employees e on o.EmployeeID = e.EmployeeID
	where LastName in ('Davolio', 'Fuller')
)
order by o.CustomerID

--Ex 260 
--Create an index named SHIP_CompanyName on the CompanyName field 
--in the Shippers table. Provide a printout showing that the 
--index has been created.

Create Index SHIP_CompanyName On Shippers(CompanyName)