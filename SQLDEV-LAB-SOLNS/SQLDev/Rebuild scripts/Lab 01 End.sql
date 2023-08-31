/*
	QASQLDEV - REBUILD SCRIPT
	*************************
*/

USE master;
GO

/*
	Lab 1 - Creating Databases
	**************************
*/

DROP DATABASE IF EXISTS DEV_UI, DEV_Database;
GO

--Ignored DEV_UI database as it is created graphically in the lab and is not used in the course.

--Exercise 2

CREATE DATABASE DEV_Database
ON PRIMARY
(
NAME = 'DEV_Database',
FILENAME = 'F:\DEV_Database.mdf',
SIZE = 100MB,
FILEGROWTH = 100MB,
MAXSIZE = 1000MB
)
LOG ON
(
NAME = 'DEV_Database_Log',
FILENAME = 'G:\DEV_Database_Log.ldf',
SIZE = 10MB,
FILEGROWTH = 10MB,
MAXSIZE = 100MB
);
GO
