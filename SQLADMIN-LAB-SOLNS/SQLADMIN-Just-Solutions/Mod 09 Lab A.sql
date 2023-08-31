/*
Mod 09 Lab A
SQL Agent and database mail
*/

---------- Module 9 Lab A Exercise 1 Step 4
CREATE DATABASE Mod09 ON PRIMARY
(
	NAME = 'Mod09LabDB',
	FILENAME ='F:\Mod09Lab.mdf',
	SIZE = 100Mb, MaxSize = 1000Mb, Filegrowth = 100Mb
)
LOG ON
(
	NAME = 'Mod09LabLog',
	FILENAME ='G:\Mod09Lab.ldf',
	SIZE = 1Mb, Filegrowth = 0
)

---------- Module 9 Lab A Exercise 1 Step 6
SELECT * FROM sys.dm_server_services

SELECT * FROM sys.dm_server_registry	
	WHERE registry_key LIKE '%AGENT%'
GO

---------- Module 9 Lab A Exercise 3 Step 2
EXEC msdb.dbo.sysmail_help_account_sp
EXEC msdb.dbo.sysmail_help_profile_sp
EXEC msdb.dbo.sysmail_help_profileaccount_sp


