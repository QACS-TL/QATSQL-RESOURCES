
------ backup database
DECLARE @SQL VARCHAR(200)
DECLARE @DB VARCHAR(30) = 'Mod09'
DECLARE @BackupBaseDirectory VARCHAR(50) = 'H:\'

SET @SQL = 
	'BACKUP DATABASE [' + @DB + '] ' +
	'TO DISK =' + '''' + @BackupBaseDirectory + @DB + '_' +
	FORMAT(GETDATE(),'yyyyMMdd_HHmm') + '.bak' + ''''
EXEC(@SQL)
GO

------ backup database differential
DECLARE @SQL VARCHAR(200)
DECLARE @DB VARCHAR(30) = 'Mod09'
DECLARE @BackupBaseDirectory VARCHAR(50) = 'H:\'

SET @SQL = 
	'BACKUP DATABASE [' + @DB + '] ' +
	'TO DISK =' + '''' + @BackupBaseDirectory + @DB + '_' +
	FORMAT(GETDATE(),'yyyyMMdd_HHmm') + '.bak' + '''' +
	' WITH DIFFERENTIAL'
EXEC(@SQL)
GO

------ backup database log
DECLARE @SQL VARCHAR(200)
DECLARE @DB VARCHAR(30) = 'Mod09'
DECLARE @BackupBaseDirectory VARCHAR(50) = 'H:\'

SET @SQL = 
	'BACKUP LOG [' + @DB + '] ' +
	'TO DISK =' + '''' + @BackupBaseDirectory + @DB + '_LOG_' +
	FORMAT(GETDATE(),'yyyyMMdd_HHmm') + '.trn' + ''''
EXEC(@SQL)
GO

