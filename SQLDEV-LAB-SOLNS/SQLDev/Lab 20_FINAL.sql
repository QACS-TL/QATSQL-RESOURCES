


--Lab10


--for use with Azure Data Studio

-- changes will need to be propogated from v1 to v2
-- execute the following restore commands to give you a before changes (v2) and after changes (v1)


USE [master]
RESTORE DATABASE [DEV_Database_v2] FROM  DISK = N'E:\QASQLDev\Backups\lab04_1_start.bak' WITH  FILE = 1,  MOVE N'DEV_Database' TO N'F:\DEV_Database_v2.mdf',  MOVE N'DEV_Database_log' TO N'G:\DEV_Database_v2_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5

GO

USE [master]
RESTORE DATABASE [DEV_Database_v1] FROM  DISK = N'E:\QASQLDev\Backups\lab09_1_end.bak' WITH  FILE = 1,  MOVE N'DEV_Database' TO N'F:\DEV_Database_v1.mdf',  MOVE N'DEV_Database_log' TO N'G:\DEV_Database_v1_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5

GO



