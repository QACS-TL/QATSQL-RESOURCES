/*
Mod 04 Extra demonstration 
Review transaction log
*/

----- From current log file
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
	FROM fn_dblog (NULL, NULL)
	) AS Trans
	WHERE TranName IN ('INSERT','UPDATE','DELETE','TRUNCATE TABLE','SPLITPAGE') AND 
		([ObjectName] NOT LIKE 'sys%' AND [ObjectName] != 'Unknown Alloc Unit')
	ORDER BY [Transaction ID],[Current LSN]

----- From backup file

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
