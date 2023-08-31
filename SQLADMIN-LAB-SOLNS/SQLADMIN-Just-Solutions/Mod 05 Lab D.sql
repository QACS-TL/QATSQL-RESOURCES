/*
Mod 05 Lab D
Create logins for a SQL instance
*/

---------- Module 5 Lab D Execise 1 Step 3
EXEC sp_configure N'contained database authentication'

---------- Module 5 Lab D Execise 1 Step 4
EXEC sp_configure N'contained database authentication', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO

---------- Module 5 Lab D Execise 1 Step 4
USE [master]
GO

CREATE DATABASE Mod05LabD ON PRIMARY
	(NAME = 'Mod05LabDDB',
	FILENAME = 'F:\Mod05LabD.mdf',	
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod05LabDLog',
	FILENAME = 'G:\Mod05LabD.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

USE Mod05LabD
GO

ALTER DATABASE Mod05LabD SET CONTAINMENT = PARTIAL WITH NO_WAIT
GO

---------- Module 5 Lab D Execise 1 Step 6
CREATE USER [LimitedDBAdmin] WITH PASSWORD = 'Pa55w.rd'
CREATE USER [FailoverUser] WITH PASSWORD = 'Pa55w.rd'
GO


ALTER ROLE db_owner ADD MEMBER [LimitedDBAdmin]
ALTER ROLE db_accessadmin ADD MEMBER [FailoverUser]
ALTER ROLE db_securityadmin ADD MEMBER [FailoverUser]
GO



