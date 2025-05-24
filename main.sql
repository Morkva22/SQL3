USE master
GO

-------

IF DB_ID('master') IS NOT NULL
DROP DATABASE master
IF DB_ID ('master') IS NULL
CREATE DATABASE master

------

USE master
GO

-----