/*
Mod 06 Lab B
Assigning database roles
*/

---------- Module 6 Lab B Execise 1 Step 4
CREATE DATABASE Mod06LabB ON PRIMARY
	(NAME = 'Mod06LabBDB',
	FILENAME = 'F:\Mod06LabB.mdf',
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod06LabBLog',
	FILENAME = 'G:\Mod06LabB.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

USE Mod06LabB
GO

---------- Module 6 Lab B Execise 1 Step 6
CREATE ROLE DatabaseDeveloper
GO

ALTER ROLE db_ddladmin ADD MEMBER DatabaseDeveloper
ALTER ROLE db_accessadmin ADD MEMBER DatabaseDeveloper
ALTER ROLE db_securityadmin ADD MEMBER DatabaseDeveloper
ALTER ROLE db_datareader ADD MEMBER DatabaseDeveloper
ALTER ROLE db_datawriter ADD MEMBER DatabaseDeveloper
GO

---------- Module 6 Lab B Execise 1 Step 7
CREATE LOGIN NNowall WITH PASSWORD = 'Pa55w.rd'
CREATE USER NNowall
GO

---------- Module 6 Lab B Execise 3 Step 1
ALTER ROLE DatabaseDeveloper ADD MEMBER NNowall



