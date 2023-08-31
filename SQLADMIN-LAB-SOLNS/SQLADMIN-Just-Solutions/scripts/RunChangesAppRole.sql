USE Mod06LabC
GO

SELECT 'Before Setting' AS Timing, user_name() AS UserName, suser_sname() AS SystemLogin
DECLARE @cookie varbinary(8000);  
EXEC sys.sp_setapprole 'Supervisor', 'Pa55w.rd1234' , @fCreateCookie = true, @cookie = @cookie OUTPUT;  
SELECT 'After Setting' AS Timing, user_name() AS UserName, suser_sname() AS SystemLogin

INSERT INTO dbo.TillRoll(ReceiptID,ProductID,Quantity)
	VALUES (2,1001,10)

SELECT * FROM dbo.TillRoll

DELETE FROM dbo.TillRoll WHERE ItemID = 2

UPDATE dbo.TillRoll SET Quantity = 5 WHERE ItemID = 1

EXEC sys.sp_unsetapprole @cookie = @cookie
SELECT 'After Unsetting' AS Timing, 
		user_name() AS UserName, suser_sname() AS SystemLogin
GO