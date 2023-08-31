/*
Mod 01 Lab A - Review SQL Instance properties
*/

--- Exercise 1

SELECT SERVERPROPERTY('ProductVersion') AS Version,
	SERVERPROPERTY('Edition') AS Edition,
	SERVERPROPERTY('ProductLevel') AS Product,
	ISNULL(SERVERPROPERTY('InstanceName'),'<Default>') AS InstanceName,
	SERVERPROPERTY('ServerName') AS ServerName,
	SERVERPROPERTY('Collation') AS Collation

SELECT * FROM sys.dm_server_services

SELECT * FROM sys.dm_server_registry

--- Exercise 2
SELECT D.name, D.recovery_model_desc, D.compatibility_level,
		D.containment_desc, D.user_access_desc, 
		D.snapshot_isolation_state_desc,
		D.is_recursive_triggers_on
	FROM sys.databases AS D

SELECT * FROM sys.sysfiles
SELECT * FROM sys.master_files

