--Why convert a stored procedure to a table function?
-- You can only EXECUTE a procedure but since you SELECT against a table function you can join (CROSS APPLY) to it and also use WHERE and ORDER BY when you call it.

--Here is an interesting question.
--Return the top X orders by TotalDue per customer

Use AdventureWorks
GO

--This is the base query. It will then be converted into a procedure and also a table function

SELECT 
	CustomerID,
	SalesOrderID,
	TotalDue
FROM (
	SELECT
		O.CustomerID,
		O.SalesOrderID, 
		O.TotalDue, 
		ROW_NUMBER = ROW_NUMBER() OVER (
			PARTITION BY O.CustomerID 
			ORDER BY O.TotalDue DESC)
	FROM	
		Sales.SalesOrderHeader AS O
	) AS d

--------------------------------------------------------------------

-- as a parametised procedure - top X orders per customer
-- why could you not just use the TOP keyword?

create proc top_x_orders_by_customer (@x int)
as
SELECT 
	CustomerID,
	SalesOrderID,
	TotalDue
FROM (
	SELECT
		O.CustomerID,
		O.SalesOrderID, 
		O.TotalDue, 
		ROW_NUMBER = ROW_NUMBER() OVER (
			PARTITION BY O.CustomerID 
			ORDER BY O.TotalDue DESC)
	FROM	
		Sales.SalesOrderHeader AS O
	) AS d
WHERE
	d.ROW_NUMBER <= @x

--run -- top 2
exec top_x_orders_by_customer 2

-------------------------------------------------------------------

-- as a function

create function fn_top_x_orders_by_customer (@x int)
returns table
as return
SELECT 
	CustomerID,
	SalesOrderID,
	TotalDue
FROM (
	SELECT
		O.CustomerID,
		O.SalesOrderID, 
		O.TotalDue, 
		ROW_NUMBER = ROW_NUMBER() OVER (
			PARTITION BY O.CustomerID 
			ORDER BY O.TotalDue DESC)
	FROM	
		Sales.SalesOrderHeader AS O
	) AS d
WHERE
	d.ROW_NUMBER <= @x

--run -- top 2 
-- but more flexible due to other key words that can be used with the SELECT statement

select * from fn_top_x_orders_by_customer(2)
--where CustomerID<11005