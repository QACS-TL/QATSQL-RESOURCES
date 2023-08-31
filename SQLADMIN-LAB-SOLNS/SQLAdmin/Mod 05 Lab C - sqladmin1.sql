

EXEC master.dbo.sp_addlinkedserver 
	@server = N'MFLAPTOP\INST2', 
	@srvproduct=N'SQL Server'
GO

EXEC master.dbo.sp_addlinkedsrvlogin 
	@rmtsrvname = N'MFLAPTOP\INST2', 
	@locallogin = NULL , 
	@useself = N'True'
GO

SELECT * FROM [MFLAPTOP\INST2].Mod05LabC.dbo.Customers
GO

SELECT * FROM OPENQUERY([MFLAPTOP\INST2],'SELECT * FROM Mod05LabC.dbo.Customers')
GO
