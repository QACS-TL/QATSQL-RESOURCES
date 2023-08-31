/*
Mod 05 Lab C - Inst3
Add linked server
*/

---------- Module 5 Lab C Execise 2 Step 2
SELECT * FROM [SERVER2019\INST3].Mod05LabC.dbo.Customers
GO

---------- Module 5 Lab C Execise 2 Step 4
SELECT * FROM OPENQUERY([SERVER2019\INST3],'SELECT * FROM Mod05LabC.dbo.Customers')
GO
