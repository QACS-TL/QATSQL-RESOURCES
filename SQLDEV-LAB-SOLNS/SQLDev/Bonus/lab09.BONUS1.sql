-- Using OUTPUT as an alternative to triggers

--In lab07.1 you wrote the following procedure

CREATE PROC Sales.P_AddCustomer
	@Name VARCHAR(50),
	@Phone VARCHAR(30) = NULL,
	@Email VARCHAR(50) = NULL
AS
INSERT Sales.Customers (Name, Phone, Email)
VALUES (@Name, @Phone, @Email)

--Sales.P_AddCustomerWithAudit (below), does the same operation but also writes the entire new row, via an OUTPUT command, to an audit table, Sales.CustomersAudit, along with who executed the procedure and when.

-- create the audit table first
CREATE TABLE [Sales].[CustomersAudit](
	[AccountNo] [int]  NOT NULL, -- identity has been removed
	[Name] [varchar](50) NOT NULL,
	[Phone] [varchar](30) NULL,
	[Email] [varchar](50) NULL,
	[WhoDidIt] [varchar](50) NULL, -- added
	[When] [datetime] NULL, -- added
) ON [PRIMARY]
GO

--use SUSER_NAME(),GETDATE() for WhoDidit and When
CREATE PROC Sales.P_AddCustomerWithAudit
	@Name VARCHAR(50),
	@Phone VARCHAR(30) = NULL,
	@Email VARCHAR(50) = NULL
AS
INSERT Sales.Customers (Name, Phone, Email)
OUTPUT inserted.*,SUSER_NAME(),GETDATE() into Sales.CustomersAudit
VALUES (@Name, @Phone, @Email)

-- use the procedure to insert a new customer
Exec Sales.P_AddCustomerWithAudit 'Jon Jackfruit','079-4326','Jon@Jackfruit.com'

-- the customer has also been added to the audit table.
Select * from Sales.CustomersAudit



