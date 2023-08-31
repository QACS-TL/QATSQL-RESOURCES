

CREATE DATABASE Mod09 ON PRIMARY
(
	NAME = 'Mod09LabDB',
	FILENAME ='C:\disks\f\Mod09Lab.mdf',
	--FILENAME ='F:\Mod09Lab.mdf',
	SIZE = 100Mb, MaxSize = 1000Mb, Filegrowth = 100Mb
)
LOG ON
(
	NAME = 'Mod09LabLog',
	FILENAME ='C:\disks\f\Mod09Lab.ldf',
	--FILENAME ='F:\Mod09Lab.mdf',
	SIZE = 1Mb, Filegrowth = 0
)

--- SQL Agent review
SELECT * FROM sys.dm_server_services

SELECT * FROM sys.dm_server_registry	
	WHERE registry_key LIKE '%AGENT%'
GO


EXEC msdb.dbo.sysmail_help_account_sp
EXEC msdb.dbo.sysmail_help_profile_sp
EXEC msdb.dbo.sysmail_help_profileaccount_sp

EXEC msdb.dbo.sysmail_help_configure_sp
EXEC msdb.dbo.sysmail_help_status_sp

SELECT * FROM msdb.dbo.sysmail_sentitems
SELECT * FROM msdb.dbo.sysmail_unsentitems
SELECT * FROM msdb.dbo.sysmail_event_log
SELECT * FROM msdb.dbo.sysmail_faileditems
SELECT * FROM msdb.dbo.sysmail_mailattachments

-- sysmail clean up
DECLARE @MonthAgo DATETIME = DATEADD(mm,-1,getdate())
	EXEC msdb.dbo.sysmail_delete_mailitems_sp @sent_before = @MonthAgo
	EXEC msdb.dbo.sysmail_delete_log_sp @Logged_before = @MonthAgo


