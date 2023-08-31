
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
USE BIE2EDW

SELECT A.audit_guid, A.audit_id, A.name, A.create_date, A.modify_date,
		A.type_desc, A.on_failure_desc, A.queue_delay,
		AUS.status_desc, AUS.status_time, AUS.audit_file_path, AUS.audit_file_size,
		DAS.*, 
		DASD.audit_action_name, DASD.class_desc, DASD.audited_result,
		DP.name AS AppliesTo, SS.Name AS SchemaName, SO.name AS ObjectName
	FROM sys.server_audits AS A
		LEFT JOIN sys.dm_server_audit_status AS AUS
			ON A.audit_id = AUS.audit_id
		LEFT JOIN sys.database_audit_specifications AS DAS
			ON DAS.audit_guid = A.audit_guid
		LEFT JOIN sys.database_audit_specification_details AS DASD
			ON DAS.database_specification_id = DASD.database_specification_id
		LEFT JOIN sys.database_principals as DP
			ON DP.principal_id = DASD.audited_principal_id
		LEFT JOIN sys.objects as SO
			ON SO.object_id = DASD.major_id
		LEFT JOIN sys.schemas AS SS
			ON SS.schema_id = DASD.major_id OR SO.schema_id = SS.schema_id

