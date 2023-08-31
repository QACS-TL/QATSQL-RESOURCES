/*
Mod 09 Lab C
Implementing jobs
*/

---------- Module 9 Lab C Exercise 2 Step 5
DECLARE @SQL VARCHAR(200)
DECLARE @DB VARCHAR(30) = 'Mod09'
DECLARE @BackupBaseDirectory VARCHAR(50) = 'H:\'

SET @SQL = 
	'BACKUP DATABASE [' + @DB + '] ' +
	'TO DISK =' + '''' + @BackupBaseDirectory + @DB + '_' +
	FORMAT(GETDATE(),'yyyyMMdd_HHmm') + '.bak' + ''''
EXEC(@SQL)
GO

---------- Module 9 Lab C Exercise 3 Step 5
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

---------- Module 9 Lab C Exercise 4 Step 5
DECLARE @SQL VARCHAR(200)
DECLARE @DB VARCHAR(30) = 'Mod09'
DECLARE @BackupBaseDirectory VARCHAR(50) = 'H:\'

SET @SQL = 
	'BACKUP LOG [' + @DB + '] ' +
	'TO DISK =' + '''' + @BackupBaseDirectory + @DB + '_LOG_' +
	FORMAT(GETDATE(),'yyyyMMdd_HHmm') + '.trn' + ''''
EXEC(@SQL)
GO

