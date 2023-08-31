-- 1. Create a new database

--- Create Mod08LabD database and create some salespeople (logins and users)
CREATE DATABASE Mod08LabE ON PRIMARY
	(NAME = 'Mod08LabEDB',
	FILENAME = 'F:\Mod08LabE.mdf',	
	SIZE = 10Mb, MaxSize = 100Mb, FileGrowth = 10Mb)
LOG ON
	(NAME = 'Mod08LabELog',
	FILENAME = 'G:\Mod08LabE.ldf',	
	SIZE = 1Mb, MaxSize = 10mb, FileGrowth = 1Mb)
GO

USE Mod08LabE
GO

CREATE TABLE dbo.AA(
	ID int identity(1,1),
	Name_Plain varchar(30),
	Name_Deterministic varchar(30),
	Name_Randomized varchar(30)
)

INSERT INTO dbo.AA values ('AAAA','AAAA','AAAA')
INSERT INTO dbo.AA values ('AAAA','AAAA','AAAA')
INSERT INTO dbo.AA values ('BBBB','BBBB','BBBB')
SELECT * FROM dbo.AA

--- Use object explorer
/*
1. Create column master key
2. Create column encryption key
3. Encrypt columns
*/

SELECT * FROM dbo.AA

USE Master
DROP DATABASE Mod08LabE
