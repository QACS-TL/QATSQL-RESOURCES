-----connected to sqladmin1\inst2

USE [master]
GO

CREATE DATABASE Mod05LabC ON PRIMARY
	(NAME = 'Mod05LabCDB',
	--FILENAME = 'F:\Mod05LabC.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod05LabC.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod05LabCLog',
	--FILENAME = 'G:\Mod05LabC.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod05LabC.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

CREATE LOGIN LinkedServerConnection WITH PASSWORD = 'Pa55w.rd'
GO

USE Mod05LabC
GO

CREATE USER LinkedServerConnection
GO

CREATE TABLE dbo.Customers(
	CustomerID INT PRIMARY KEY,
	CustomerName VARCHAR(50),
	CompanyName VARCHAR(100)
)

INSERT INTO dbo.Customers VALUES
	(1,'Ian Brew','Drinks Co'),
	(2,'Woody Stoke','The Surgery Ltd'),
	(3,'R.A. Thomas','Southern Ventures'),
	(4,'T. Brewing','Retee')
GO

GRANT SELECT ON dbo.Customers TO LinkedServerConnection
GO


