/*
Mod 04 Extra demonstration 
Review transaction log and restore to checkpoint
*/

SELECT * FROM (
	SELECT  [Transaction ID], [Current LSN], 
			max([Transaction Name]) over (partition by [Transaction ID]) as TranName, 
			max([SPID]) over (partition by [Transaction ID]) as SPID,
			[Operation],  
			max([AllocUnitName]) over (partition by [Transaction ID]) as ObjectName,
			[Begin Time],
			[End Time],
			suser_sname([Transaction SID]) as WhoDidIt,
			[Description],
			[Number of Locks],
			[Log Record Length],
			[Log Record]
    FROM fn_dump_dblog (
        NULL, NULL, N'DISK', 1, N'H:\Mod04LabC_Tail.bak',
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
        DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT)
		) AS Trans
	WHERE TranName IN ('INSERT','UPDATE','DELETE','TRUNCATE TABLE','SPLITPAGE') AND 
		([ObjectName] NOT LIKE 'sys%' AND [ObjectName] != 'Unknown Alloc Unit')
	ORDER BY [Transaction ID],[Current LSN]
GO


RESTORE DATABASE Mod04LabC
	FROM DISK = 'H:\Mod04LabC_Initial.bak'
	WITH REPLACE, NORECOVERY
GO

RESTORE DATABASE Mod04LabC
	FROM DISK = 'H:\Mod04LabC_Diff.bak'
	WITH NORECOVERY
GO

RESTORE LOG Mod04LabC 
	FROM DISK = 'H:\Mod04LabC_Tail.bak'
	WITH RECOVERY,STOPBEFOREMARK = 'lsn:0x...'
GO

SELECT * FROM Mod04LabC.dbo.Products
GO

ALTER DATABASE Mod04LabC SET MULTI_USER
GO