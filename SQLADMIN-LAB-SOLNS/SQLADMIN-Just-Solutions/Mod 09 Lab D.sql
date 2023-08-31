/*
Mod 09 Lab D
Implementing alerts
*/

---------- Module 9 Lab D Exercise 1 Step 5
USE MASTER
EXEC sp_addmessage 50001,16,'Custom error (%s)'
GO

---------- Module 9 Lab D Exercise 1 Step 13
RAISERROR(50001,5,1,'Customer 24 was deleted by Fred')with log
GO

---------- Module 9 Lab D Exercise 2 Step 2
BACKUP DATABASE Mod09
	TO DISK='H:\Mod09_Backup_AlertStart.bak'
GO

---------- Module 9 Lab D Exercise 2 Step 6
USE Mod09;
GO
CREATE TABLE dbo.BigRow(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	BigColumn CHAR(2000)
)
GO

DECLARE @X INT = 0
WHILE @X < 50
	BEGIN
		INSERT INTO dbo.BigRow SELECT REPLICATE(@X,500)
		SET @X = @X + 1
	END
GO

---------- Module 9 Lab D Exercise 3 Step 3
USE Mod09;
GO

DECLARE @X INT = 0
WHILE @X < 50
	BEGIN
		INSERT INTO dbo.BigRow SELECT REPLICATE(@X,500)
		SET @X = @X + 1
	END
GO








