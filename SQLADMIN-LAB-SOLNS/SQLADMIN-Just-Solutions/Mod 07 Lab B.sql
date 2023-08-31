/*
Mod 07 Lab B
Using schemas
*/

---------- Module 7 Lab B Execise 1 Step 4
CREATE DATABASE Mod07LabB ON PRIMARY
	(NAME = 'Mod07LabBDB',
	FILENAME = 'F:\Mod07LabB.mdf',	
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod08LabBLog',
	FILENAME = 'G:\Mod07LabB.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

---------- Module 7 Lab B Execise 1 Step 5
CREATE LOGIN SchemaTestViewer WITH PASSWORD ='Pa55w.rd'
CREATE LOGIN SchemaOwner WITH PASSWORD ='Pa55w.rd'

---------- Module 7 Lab B Execise 1 Step 6
USE Mod07LabB
GO

CREATE USER SchemaTestViewer
CREATE USER SchemaOwner
GO

---------- Module 7 Lab B Execise 1 Step 7
CREATE SCHEMA SecureTables AUTHORIZATION SchemaOwner
GO
CREATE SCHEMA SecureViews AUTHORIZATION SchemaOwner
GO
CREATE SCHEMA SecureProcs AUTHORIZATION SchemaOwner
GO

---------- Module 7 Lab B Execise 1 Step 8
CREATE TABLE SecureTables.SampleTable(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(30)
)
GO

INSERT INTO SecureTables.SampleTable VALUES
	('A'),('B'),('C')
GO

---------- Module 7 Lab B Execise 1 Step 9
CREATE VIEW SecureViews.NamesList AS
	SELECT ID, Name 
		FROM SecureTables.SampleTable
GO

CREATE PROC SecureProcs.UpdateName 
	@OldName VARCHAR(30),
	@NewName VARCHAR(30)
AS
	BEGIN
		UPDATE SecureTables.SampleTable
			SET Name = @NewName
			WHERE Name = @OldName
	END
GO

---------- Module 7 Lab B Execise 1 Step 10
EXECUTE AS USER = 'SchemaTestViewer'
	SELECT * FROM SecureTables.SampleTable
	EXECUTE SecureProcs.UpdateName 'A','Adam'	
	SELECT * FROM SecureViews.NamesList
REVERT

---------- Module 7 Lab B Execise 2 Step 1
GRANT SELECT ON SCHEMA::SecureViews TO SchemaTestViewer
GRANT EXECUTE ON SCHEMA::SecureProcs TO SchemaTestViewer

---------- Module 7 Lab B Execise 2 Step 2
SELECT * FROM SecureTables.SampleTable

---------- Module 7 Lab B Execise 3 Step 1
EXECUTE AS USER = 'SchemaTestViewer'
	SELECT * FROM SecureTables.SampleTable
REVERT

---------- Module 7 Lab B Execise 3 Step 2
EXECUTE AS USER = 'SchemaTestViewer'
	EXECUTE SecureProcs.UpdateName 'A','Adam'
	SELECT * FROM SecureViews.NamesList
REVERT

---------- Module 7 Lab B Execise 4 Step 1
ALTER AUTHORIZATION ON SCHEMA::SecureTables TO dbo
GO

---------- Module 7 Lab B Execise 4 Step 3
EXECUTE AS USER = 'SchemaTestViewer'
	EXECUTE SecureProcs.UpdateName 'B','Ben'
	SELECT * FROM SecureViews.NamesList
REVERT

---------- Module 7 Lab B Execise 4 Step 4
ALTER AUTHORIZATION ON SCHEMA::SecureTables TO SchemaOwner
GO

---------- Module 7 Lab B Execise 4 Step 5
EXECUTE AS USER = 'SchemaTestViewer'
	EXECUTE SecureProcs.UpdateName 'B','Ben'
	SELECT * FROM SecureViews.NamesList
REVERT

