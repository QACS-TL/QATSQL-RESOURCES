--Lab07

--Bonus challenges:
--1. Controlling the security context within a stored procedure
--2. Useful meta data queries

--1. Review and execute the following code in sections to test security.

--***Make sure you run each section individually***

--this stops you running the ENTIRE script. How many times have you done that?
SET PARSEONLY ON; 
GO
--see SET PARSEONLY OFF at the bottom of the script
----------------------------------------------------------------

----------------------------------------------------------------
--section 1 start

USE master;
GO
CREATE DATABASE SP_EXECUTE_AS_DEMO;
GO
 
USE SP_EXECUTE_AS_DEMO;
GO
CREATE USER Jane WITHOUT LOGIN;
CREATE USER Harry WITHOUT LOGIN;
GO
 
CREATE TABLE Customer(
       CustomerName varchar(100) NULL,
       CustomerEmail varchar(100) NULL,
       SalesPersonUserName varchar(20) NULL
);  
GO

-- create a test table to which users will have no access
CREATE TABLE TestTable (Column1 int)

--Grant permissions
--In reality you would use roles
GRANT INSERT, SELECT ON dbo.Customer TO Jane;
GRANT SELECT ON dbo.Customer TO Harry;
GO
 
INSERT INTO Customer VALUES 
   ('B Company','a@b.COM','Jane'),
   ('D Services','c@d.COM','Jane'),
   ('F Data','e@f.COM','Harry'),
   ('H Utilities','g@h.COM','Harry'),
   ('J Co','i@j.COM','Jane')
GO

--end section 1
--------------------------------------------------------

----------------------------------------------------------------
--section 2 start

--test as yourself
select USER_NAME() as 'user'
select SUSER_NAME() as 'sysuser'
SELECT * FROM Customer
SELECT * FROM TestTable

--end section 2
--------------------------------------------------------

----------------------------------------------------------------
--section 3 start

-- test as Jane
EXECUTE AS USER='Jane'
select USER_NAME() as 'user'
select SUSER_NAME() as 'sysuser'
SELECT * FROM Customer
SELECT * FROM TestTable -- no access
Revert

--end section 3
--------------------------------------------------------

----------------------------------------------------------------
--section 4 start

-- create procedure to execute as Jane
Create proc usp_insert_customer 
(
@CustomerName varchar(100)
,@CustomerEmail varchar(100)
,@SalesPersonUserName varchar(20)
) 
WITH EXECUTE AS 'Jane'
as
INSERT INTO [dbo].[Customer]
           ([CustomerName]
           ,[CustomerEmail]
           ,[SalesPersonUserName])
     VALUES
           (@CustomerName
           ,@CustomerEmail
           ,@SalesPersonUserName)
GO

--end section 4
----------------------------------------------------------------

----------------------------------------------------------------
--section 5 start

--give only Harry the permission to execute the procedure
GRANT EXECUTE ON dbo.usp_insert_customer TO Harry;

--end section 5
--------------------------------------------------------

----------------------------------------------------------------
--section 6 start

--test as Harry (direct insert fails but using the procedure succeeds)
EXECUTE AS USER='Harry'
SELECT * FROM Customer
go
INSERT INTO [dbo].[Customer]
           ([CustomerName]
           ,[CustomerEmail]
           ,[SalesPersonUserName])
     VALUES
           ('Fail'
           ,'x@y.com'
           ,'Harry') -- this insert fails (Harry has no permission to insert directly)
go
Exec dbo.usp_insert_customer 'Succeed with procedure','x@y.com','Harry' -- succeeds
go
SELECT * FROM Customer
go
REVERT

--end section 6
----------------------------------------------------------------

--------------------------------------------------------
--section 7 start

--test as Jane (direct insert succeeds but using the procedure fails)
EXECUTE AS USER='Jane'
SELECT * FROM Customer
go
INSERT INTO [dbo].[Customer]
           ([CustomerName]
           ,[CustomerEmail]
           ,[SalesPersonUserName])
     VALUES
           ('Succeed with direct insert'
           ,'1@2.com'
           ,'Jane') -- this insert succeeds
go
Exec dbo.usp_insert_customer 'Fail','1@2.com','Jane' -- fails (Jane has no permission to execute the procedure)
go
SELECT * FROM Customer
go
REVERT

--end section 7 
----------------------------------------------------------------

--------------------------------------------------------
--2. Useful meta data queries. You can just run these.

-- display create datetime and last modified datetime of procedures (P) in the database

select 
 [database name] = db_name() 
,[schema name] =  SCHEMA_NAME([schema_id])
,name [stored proc name]
,create_date [create date]
,modify_date [last modify date]
from sys.objects
where type = 'P'

-- for other types see the following link:
--https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-objects-transact-sql?f1url=%3FappId%3DDev15IDEF1%26l%3DEN-US%26k%3Dk(sys.objects_TSQL);k(sql13.swb.tsqlresults.f1);k(sql13.swb.tsqlquery.f1);k(MiscellaneousFilesProject);k(DevLang-TSQL)%26rd%3Dtrue&view=sql-server-ver15#:~:text=a%20child%20object.-,type,Object%20type%3A,-AF%20%3D%20Aggregate%20function

-- have you ever been asked when procedures last ran or how many times?

SELECT 
o.name
,ps.last_execution_time 
,ps.execution_count
FROM   sys.dm_exec_procedure_stats ps 
INNER JOIN 
       sys.objects o 
       ON ps.object_id = o.object_id 
WHERE  DB_NAME(ps.database_id) = 'SP_EXECUTE_AS_DEMO' 
ORDER  BY 
       ps.last_execution_time DESC 

-- since you may be wondering, what about the last time a table was accessed or how many times?

SELECT 
index_id
,OBJECT_NAME([object_id]) AS [Table] 
,Last_user_update
, Last_user_seek
, Last_user_scan
, Last_user_lookup
,user_seeks
,user_scans
,user_lookups
,user_updates
FROM sys.dm_db_index_usage_stats
WHERE database_id = DB_ID('SP_EXECUTE_AS_DEMO')
GO

--objects created in the last 7 days
--you could always create this as a procedure and parametise the 7

SELECT o.name AS [Object_Name],
s.name [Schema_Name],
o.type_desc [Description],
o.create_date [Creation_Date],
o.modify_date [Modified_Date] FROM   sys.all_objects o
LEFT OUTER JOIN sys.schemas s
ON o.schema_id = s.schema_id
WHERE  create_date > (GETDATE() - 7) OR modify_date > (GETDATE() - 7)

--Similarly, how old are your statistics? Useful for query performance management.
--Out of date statistics may mean that the query optimiser makes a bad decision
--Again, you could parametise the DaysOld number

SELECT DISTINCT
OBJECT_SCHEMA_NAME(s.[object_id]) AS SchemaName,
OBJECT_NAME(s.[object_id]) AS TableName,
c.name AS ColumnName,
s.name AS StatName,
STATS_DATE(s.[object_id], s.stats_id) AS LastUpdated,
DATEDIFF(d,STATS_DATE(s.[object_id], s.stats_id),getdate()) as DaysOld,
dsp.modification_counter,
s.auto_created,
s.user_created,
s.no_recompute,
s.[object_id],
s.stats_id,
sc.stats_column_id,
sc.column_id
FROM sys.stats s
JOIN sys.stats_columns sc
ON sc.[object_id] = s.[object_id] AND sc.stats_id = s.stats_id
JOIN sys.columns c ON c.[object_id] = sc.[object_id] AND c.column_id = sc.column_id
JOIN sys.partitions par ON par.[object_id] = s.[object_id]
JOIN sys.objects obj ON par.[object_id] = obj.[object_id]
CROSS APPLY sys.dm_db_stats_properties(sc.[object_id], s.stats_id) AS dsp
WHERE OBJECTPROPERTY(s.OBJECT_ID,'IsUserTable') = 1
-- AND (s.auto_created = 1 OR s.user_created = 1) -- filter out stats for indexes
and DATEDIFF(d,STATS_DATE(s.[object_id], s.stats_id),getdate())>1 -- over X days old
ORDER BY DaysOld;


----------------------------------------------------------------
-- see SET PARSEONLY ON at top of script
SET PARSEONLY OFF;
RAISERROR('Ooops. Did you run the WHOLE script by hitting F5, Control-E, or the "Execute" button?', 16, 1)
