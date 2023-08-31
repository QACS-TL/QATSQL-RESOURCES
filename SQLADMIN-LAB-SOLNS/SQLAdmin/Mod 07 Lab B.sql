CREATE DATABASE Mod07LabB ON PRIMARY
	(NAME = 'Mod07LabBDB',
	--FILENAME = 'F:\Mod07LabB.mdf',		-- change to drive letter on real
	FILENAME = 'c:\disks\f\Mod07LabB.mdf',		
	SIZE = 100Mb, MaxSize = 1000Mb, FileGrowth = 100Mb)
LOG ON
	(NAME = 'Mod08LabBLog',
	--FILENAME = 'G:\Mod07LabB.ldf',	-- change to drive letter on real
	FILENAME = 'c:\disks\g\Mod07LabB.ldf',
	SIZE = 10Mb, MaxSize = 100mb, FileGrowth = 10Mb)
GO

CREATE LOGIN SchemaTestViewer WITH PASSWORD ='Pa55w.rd'
CREATE LOGIN SchemaOwner WITH PASSWORD ='Pa55w.rd'

USE Mod07LabB
GO

CREATE USER SchemaTestViewer
CREATE USER SchemaOwner
GO

CREATE SCHEMA SecureTables AUTHORIZATION SchemaOwner
GO
CREATE SCHEMA SecureViews AUTHORIZATION SchemaOwner
GO
CREATE SCHEMA SecureProcs AUTHORIZATION SchemaOwner
GO

CREATE TABLE SecureTables.SampleTable(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(30)
)
GO

INSERT INTO SecureTables.SampleTable VALUES
	('A'),('B'),('C')
GO

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
SELECT * FROM SecureTables.SampleTable

-------- default permissions = None
EXECUTE AS USER = 'SchemaTestViewer'
	SELECT * FROM SecureTables.SampleTable
	EXECUTE SecureProcs.UpdateName 'A','Adam'	
	SELECT * FROM SecureViews.NamesList
REVERT

-------- GRANT access to the SecureViews and SecureProcs schema
GRANT SELECT ON SCHEMA::SecureViews TO SchemaTestViewer
GRANT EXECUTE ON SCHEMA::SecureProcs TO SchemaTestViewer

SELECT * FROM SecureTables.SampleTable


EXECUTE AS USER = 'SchemaTestViewer'
	SELECT * FROM SecureTables.SampleTable
REVERT

EXECUTE AS USER = 'SchemaTestViewer'
	EXECUTE SecureProcs.UpdateName 'A','Adam'
	SELECT * FROM SecureViews.NamesList
REVERT

---- Break ownership chain
ALTER AUTHORIZATION ON SCHEMA::SecureTables TO dbo
GO

EXECUTE AS USER = 'SchemaTestViewer'
	SELECT * FROM SecureTables.SampleTable
REVERT

EXECUTE AS USER = 'SchemaTestViewer'
	EXECUTE SecureProcs.UpdateName 'B','Ben'
	SELECT * FROM SecureViews.NamesList
REVERT

ALTER AUTHORIZATION ON SCHEMA::SecureTables TO SchemaOwner
GO

EXECUTE AS USER = 'SchemaTestViewer'
	EXECUTE SecureProcs.UpdateName 'B','Ben'
	SELECT * FROM SecureViews.NamesList
REVERT

----
USE MASTER
DROP DATABASE Mod07LabB
DROP LOGIN SchemaTestViewer
DROP LOGIN SchemaOwner
