
USE Mod06LabB
GO

----- Test permissions to create objects

-- DDLAdmin
CREATE TABLE dbo.TestTable(
	ID INT PRIMARY KEY,
	Name VARCHAR(50)
)
GO

-- DataWriter
INSERT INTO dbo.TestTable VALUES (1,'Added by Barry')
GO

-- DataReader
SELECT * FROM dbo.TestTable
GO

-- AccessAdmin
CREATE USER GGalway
GO

-- SecurityAdmin
GRANT SELECT ON dbo.TestTable TO GGalway
GO


