USE Mod06LabC
GO

INSERT INTO dbo.TillRoll(ReceiptID,ProductID,Quantity)
	VALUES (2,1001,10)

SELECT * FROM dbo.TillRoll

DELETE FROM dbo.TillRoll WHERE ItemID = 2

UPDATE dbo.TillRoll SET Quantity = 5 WHERE ItemID = 1
GO