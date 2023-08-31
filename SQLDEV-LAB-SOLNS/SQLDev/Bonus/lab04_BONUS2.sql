--SEQUENCE NUMBERS

--An interesting exercise in table and constraint management

--check that 'c:\disks\D\ and 'c:\disks\L\ are created

--**RUN THE STEPS INDIVIDUALLY**

CREATE DATABASE [Sequence]
 ON  PRIMARY 
( NAME = N'Sequence', FILENAME = N'C:\disks\D\Sequence.mdf')
 LOG ON 
( NAME = N'Sequence_log', FILENAME = N'C:\disks\L\Sequence_log.ldf')
GO

USE Sequence
Go

--create base table with and identity column
CREATE TABLE Table1 
(
ID int identity(1,1) NOT NULL, 
    Data varchar(30) NOT NULL,
    CONSTRAINT PK_Table1_ID PRIMARY KEY CLUSTERED(ID ASC)
);
GO

INSERT INTO Table1(Data) 
VALUES 
('a1'),
('b2'),
('c3');

SELECT * FROM Table1;

--create a table with a foreign key reference that refers to ID - just so that we have another issue to manage
CREATE TABLE Table2 (ID int);
GO

ALTER TABLE Table2
ADD CONSTRAINT FK_Table2_ID FOREIGN KEY (ID) REFERENCES Table1(ID);

--add a column to the Table1 table that will eventually become a sequence number
ALTER TABLE Table1 ADD SN int NULL;
GO

-- update existing records so that SN matches the ID column
UPDATE Table1
   Set SN = ID;
GO

SELECT * FROM Table1;

--primary key needs to be moved to the new SN column

--find all foreign keys to be dropped first (associated with Table1.ID, the primary key)
SELECT 
FK.TABLE_NAME as ForeignKeyTable,
C.CONSTRAINT_NAME as Constraint_Name 
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK 
ON C.CONSTRAINT_NAME =Fk.CONSTRAINT_NAME
INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK 
ON C.UNIQUE_CONSTRAINT_NAME=PK.CONSTRAINT_NAME 
INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU 
ON C.CONSTRAINT_NAME = KCU.CONSTRAINT_NAME 
INNER JOIN
(
        SELECT TC1.TABLE_NAME, KCU2.COLUMN_NAME
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC1
            INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU2 
     ON TC1.CONSTRAINT_NAME =KCU2.CONSTRAINT_NAME 
        WHERE TC1.CONSTRAINT_TYPE = 'PRIMARY KEY'
 ) X 
 ON X.TABLE_NAME = PK.TABLE_NAME
WHERE PK.TABLE_NAME = 'Table1' and X.COLUMN_NAME = 'ID';

-- drop the foreign key on Table2
ALTER TABLE Table2 DROP CONSTRAINT FK_Table2_ID;

-- now remove the primary key on Table1
ALTER TABLE Table1
DROP CONSTRAINT PK_Table1_ID;
GO

-- remove the identity column on Table1
ALTER TABLE Table1
DROP COLUMN ID ;
GO

-- rename the SN column as ID
EXEC sp_rename 'Table1.SN', 'ID'
GO

-- make the ID column obligatory
ALTER TABLE Table1 
ALTER COLUMN [ID] int NOT NULL;
GO

-- make the ID column the primary key
ALTER TABLE Table1
   ADD CONSTRAINT PK_Table1_ID PRIMARY KEY CLUSTERED (ID ASC) ;
GO

-- create the sequencing object but it must start 1 after the latest ID number
DECLARE @Start int;
DECLARE @SQL nvarchar(100);
SELECT @Start = MAX(ID) + 1 FROM Table1;
SET @SQL = 'CREATE SEQUENCE Table_SN AS INT START WITH ' + CAST(@Start as CHAR) + ' INCREMENT BY 1';
EXEC sp_executesql @SQL
GO

--Get the cuurent value of the sequence - ie the next number to be used
SELECT current_value FROM sys.sequences WHERE name = 'Table_SN' ;

--add a default to the ID column to take the next value in the sequence.
ALTER TABLE Table1
ADD CONSTRAINT ID_Default 
   DEFAULT (NEXT VALUE FOR Table_SN) FOR ID;
GO

--add the foreign key bak to Table2
ALTER TABLE Table2
ADD CONSTRAINT FK_Table2_ID FOREIGN KEY (ID) REFERENCES Table1(ID);

--insert some new rows to test the sequence

INSERT INTO Table1 (Data)    
   VALUES ('d4'),
          ('e5')
GO

SELECT * FROM Table1

--create another table that will also use the sequence
CREATE TABLE [dbo].[Table3]
(
	[Data] [varchar](30) NOT NULL,
	[ID] [int] NOT NULL,
 CONSTRAINT [PK_Table3_ID] PRIMARY KEY CLUSTERED ([ID] ASC)
)
GO

ALTER TABLE [dbo].[Table3] 
ADD  CONSTRAINT [ID_Table3_Default]  DEFAULT (NEXT VALUE FOR [Table_SN]) FOR [ID]
GO


--insert the following 4 rows 
INSERT INTO Table1(Data) 
VALUES 
('f6')
GO

INSERT INTO Table3(Data) 
VALUES 
('insert1')
GO

INSERT INTO Table1(Data) 
VALUES 
('g7')
GO

INSERT INTO Table3(Data) 
VALUES 
('insert2')
GO

-- read the tables and the current sequence number
SELECT * FROM Table1;
SELECT * FROM Table3;

SELECT current_value FROM sys.sequences WHERE name = 'Table_SN'