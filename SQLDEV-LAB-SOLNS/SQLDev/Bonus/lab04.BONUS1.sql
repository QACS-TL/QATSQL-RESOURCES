--DISABLING CONSTRAINTS

USE Dev_Database;
GO

CREATE TABLE dbo.TestTable 
( TestTableID int NOT NULL,
  TestTableName varchar(10) NOT NULL,
  Salary decimal(18,2) NOT NULL CONSTRAINT SalaryCap CHECK (Salary < 100000)
);

--alternatively
--ALTER TABLE dbo.TestTable  WITH CHECK ADD  CONSTRAINT SalaryCap CHECK  (Salary < 100000)
GO

-- Step 2:Insert valid data
--        (2 rows will be inserted)

INSERT INTO dbo.TestTable VALUES (1,'Joe Brown',65000);
INSERT INTO dbo.TestTable VALUES (2,'Mary Smith',75000);
GO

-- Step 3: Try to insert data that violates the constraint.
--         (Will fail with a constraint violation)

INSERT INTO dbo.TestTable VALUES (3,'Pat Jones',105000);
GO

-- Step 4: Disable the constraint and try again. Point out that the insert will work now.
--         (1 row will be inserted)

ALTER TABLE dbo.TestTable NOCHECK CONSTRAINT SalaryCap;
GO

INSERT INTO dbo.TestTable VALUES (3,'Pat Jones',105000);
GO

-- Step 5: Re-enable the constraint. Notice that it works even though
--         existing data does not meet the constraint. 
--         Note that NOCHECK is the default.

ALTER TABLE dbo.TestTable CHECK CONSTRAINT SalaryCap;

-- Step 6: Disable the constraint and and enable again but this time use WITH CHECK. 
--         Note that it is not working, since the existing data is checked now.

ALTER TABLE dbo.TestTable NOCHECK CONSTRAINT SalaryCap;
GO

ALTER TABLE dbo.TestTable WITH CHECK CHECK CONSTRAINT SalaryCap;
GO

-- Step 7: DELETE the row and try to enable again. Note that it is working now.

DELETE FROM dbo.TestTable WHERE TestTableID = 3;
GO

ALTER TABLE dbo.TestTable WITH CHECK CHECK CONSTRAINT SalaryCap;
GO

-- clean up
drop table dbo.TestTable
GO

