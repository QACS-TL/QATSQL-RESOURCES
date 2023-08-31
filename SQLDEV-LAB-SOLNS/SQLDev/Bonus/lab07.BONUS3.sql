--It is very common to have a multi database application. It is possible to set up all the databases to use a single security principal

--Accessing one database from another using a certificate as a security principal

--Use a signed stored procedure in the SOURCE database to read data in the TARGET database

--For further details - see:
--https://www.sommarskog.se/grantperm.html#:~:text=Ownership%20chaining.-,Certificate%20signing.,-The%20EXECUTE%20AS

-----------------------------------------------------------

-- create TARGET database and a target table with data
CREATE DATABASE TARGET
GO

USE TARGET
GO

-- a simple table to access
CREATE TABLE dbo.TARGETTable
(data nvarchar(50))
GO

INSERT INTO dbo.TARGETTable
VALUES
('Some data in the TARGET database')

-----------------------------------------------------------

-- create SOURCE database
CREATE DATABASE SOURCE
GO

USE SOURCE
GO

-- create a security context within the SOURCE database
CREATE USER SOURCEUser WITHOUT LOGIN;
GO

-- the basic procedure with the SOURCEUser context
CREATE PROCEDURE dbo.GetTARGETDataUnsigned
WITH EXECUTE AS 'SOURCEUser'
AS
SELECT * FROM TARGET.dbo.TARGETTable
GO

-- the same basic procedure that will get signed by a certificate
CREATE PROCEDURE dbo.GetTARGETDataSigned
WITH EXECUTE AS 'SOURCEUser'
AS
SELECT * FROM TARGET.dbo.TARGETTable
GO

-- create certificate and sign procedure

-- master key for the SOURCE database
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '23987hxJ#KL95234nl0zBe'
GO

--create certificate
CREATE CERTIFICATE SOURCECert 
   WITH SUBJECT = 'SOURCE cert', 
   EXPIRY_DATE = '12/31/2030'  -- use this format
GO

--sign the GetTARGETDataSigned procedure with the SOURCECert certificate
ADD SIGNATURE TO dbo.GetTARGETDataSigned
BY CERTIFICATE SOURCECert
GO

-- export the certificate
BACKUP CERTIFICATE SOURCECert TO FILE = 'E:\SQLDev\SOURCECert.cer'

-----------------------------------------------------------

-- import the certificate that was used to sign the procedure in the SOURCE database to the TARGET database
USE TARGET
GO

CREATE CERTIFICATE SOURCECert
FROM FILE = 'E:\SQLDev\SOURCECert.cer'
GO

-- create the authenticator in TARGET from the SOURCECert certificate
-- did you realise you could do this?
-- note that there is no direct security context for SOURCEUser within the TARGET database
CREATE USER SOURCECertUser
FROM CERTIFICATE SOURCECert
GO

--now you can grant permissions to SOURCECertUser
GRANT AUTHENTICATE TO SOURCECertUser -- so the certificate can gain access from outside the database

GRANT SELECT ON dbo.TARGETTable TO SOURCECertUser

-----------------------------------------------------------

-- back to the SOURCE database to test both procedures
-- remember, you are using a procedure in the SOURCE database to read data in the TARGET database

-- test the unsigned procedure - this FAILS
USE SOURCE
GO
EXEC dbo.GetTARGETDataUnsigned

-- test the signed procedure - this SUCCEEDS
EXEC dbo.GetTARGETDataSigned

-- tidy up
USE master
DROP DATABASE SOURCE
DROP DATABASE TARGET
