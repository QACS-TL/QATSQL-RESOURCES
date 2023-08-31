
CREATE DATABASE Mod08Demo;
GO

USE Mod08Demo;
GO

CREATE TABLE dbo.ColumnPermissions(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(30),
	PhoneNumber VARCHAR(20),
	Salary MONEY
)

CREATE LOGIN Reception WITH PASSWORD = 'Pa55w.rd'
CREATE LOGIN HR WITH PASSWORD = 'Pa55w.rd'
CREATE LOGIN Auditor WITH PASSWORD = 'Pa55w.rd'

CREATE USER Reception
CREATE USER HR
CREATE USER Auditor

-- Reception should not see Salary
-- HR should see all columns
-- Auditor should see ID and Name only

---------- Testing
INSERT INTO dbo.ColumnPermissions VALUES ('Fred','123456',90000)

---------- No permissions set

EXECUTE AS USER = 'Reception'
	SELECT * FROM dbo.ColumnPermissions
REVERT
EXECUTE AS USER = 'HR'
	SELECT * FROM dbo.ColumnPermissions
REVERT
EXECUTE AS USER = 'Auditor'
	SELECT * FROM dbo.ColumnPermissions
REVERT

---------- Set permission for Reception
GRANT SELECT ON dbo.ColumnPermissions TO Reception
DENY SELECT ON dbo.ColumnPermissions(Salary) TO Reception

EXECUTE AS USER = 'Reception'
	SELECT * FROM dbo.ColumnPermissions
	SELECT ID, Name, PhoneNumber FROM dbo.ColumnPermissions
REVERT

---------- Set permission for Reception
GRANT SELECT ON dbo.ColumnPermissions TO HR

EXECUTE AS USER = 'HR'
	SELECT * FROM dbo.ColumnPermissions
REVERT

---------- Set permission for Auditor
DENY SELECT ON dbo.ColumnPermissions TO HR
GRANT SELECT ON dbo.ColumnPermissions(ID,Name) TO HR

EXECUTE AS USER = 'HR'
	SELECT * FROM dbo.ColumnPermissions
	SELECT ID, Name FROM dbo.ColumnPermissions
REVERT

--- clean up
DROP USER Auditor
DROP USER HR
DROP USER Reception
DROP LOGIN Auditor
DROP LOGIN HR
DROP LOGIN Reception

---------------------------- 

