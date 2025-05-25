USE master
GO

-------

IF DB_ID('Hosp') IS NOT NULL
DROP DATABASE Hosp
IF DB_ID ('Hosp') IS NULL
CREATE DATABASE Hosp

------

USE Hosp
GO

-- Create a table with departments
CREATE TABLE Departments (
 ID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    Name NVARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT CHK_Department_Name CHECK(Name <> '')
)

-- Create a table with doctors
CREATE TABLE Doctors (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Name NVARCHAR(MAX) NOT NULL,
    Surname NVARCHAR(MAX) NOT NULL,
    Premium MONEY NOT NULL DEFAULT(0),
    Salary MONEY NOT NULL,

    CONSTRAINT CHK_Doctors_Name CHECK(Name <> ''),
    CONSTRAINT CHK_Doctors_Surname CHECK(Surname <> ''),
    CONSTRAINT CHK_Doctors_Premium CHECK(Premium >= 0),
    CONSTRAINT CHK_Doctors_Salary CHECK(Salary > 0)
)

-- Create a table with specializations
CREATE TABLE Specializations (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT CHK_Specializations_Name CHECK(Name <> '')
)

-- Create a table with DoctorsSpecializations
CREATE TABLE DoctorsSpecializations (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    DoctorId INT NOT NULL,
    SpecializationId INT NOT NULL,

    CONSTRAINT FK_DoctorsSpecializations_Doctor FOREIGN KEY (DoctorId) REFERENCES Doctors(Id),
    CONSTRAINT FK_DoctorsSpecializations_Specialization FOREIGN KEY (SpecializationId) REFERENCES Specializations(Id),
    CONSTRAINT CHK_DoctorsSpecializations_DoctorId CHECK(DoctorId > 0),
    CONSTRAINT CHK_DoctorsSpecializations_SpecializationId CHECK(SpecializationId > 0)
    )

--Create a table with Donations
CREATE TABLE Donations (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Amount MONEY NOT NULL,
    Date DATE NOT NULL DEFAULT(GETDATE()),
    DepartmentId INT NOT NULL,
    SponsorId INT NOT NULL,

    CONSTRAINT CHK_Donations_Amount CHECK(Amount > 0),
    CONSTRAINT CHK_Donations_Date CHECK(Date <= GETDATE()),
    CONSTRAINT FK_Donations_Department FOREIGN KEY(DepartmentId) REFERENCES Departments(Id),
    CONSTRAINT FK_Donations_Sponsor FOREIGN KEY(SponsorId) REFERENCES Sponsors(Id)
)

--Create a table with Sponsors
CREATE TABLE Sponsors (
    ID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    Name NVARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT CHK_Sponsors_Name CHECK(Name <> '')
)

--Create a table with Vacations
CREATE TABLE Vacations (
    ID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    EndDate DATE NOT NULL,
    StartDate DATE NOT NULL,
    DoctorId INT NOT NULL,

    CONSTRAINT CHK_Vacations_EndDate CHECK(EndDate > StartDate),
    CONSTRAINT FK_Vacations_Doctor FOREIGN KEY (DoctorId) REFERENCES Doctors(Id),
)

--Create a table with Wards
CREATE TABLE Wards (
    ID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    Name NVARCHAR(20) NOT NULL UNIQUE,
    DepartmentID INT NOT NULL,

    CONSTRAINT CHK_Wards_Name CHECK(Name <> ''),
    CONSTRAINT FK_Wards_Department FOREIGN KEY (DepartmentID) REFERENCES Departments (ID)
)

-- Create a table with examinations
CREATE TABLE Examinations (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    DiseaseId INT NOT NULL,
    DepartmentId INT NOT NULL,
    WardId INT NOT NULL,
    ExamDate DATE NOT NULL DEFAULT(GETDATE()),

    CONSTRAINT FK_Examinations_Disease FOREIGN KEY(DiseaseId) REFERENCES Diseases(Id),
    CONSTRAINT FK_Examinations_Department FOREIGN KEY(DepartmentId) REFERENCES Departments(Id),
    CONSTRAINT FK_Examinations_Ward FOREIGN KEY(WardId) REFERENCES Wards(Id)
)

-- Create a table with diseases
CREATE TABLE Diseases (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL UNIQUE,
    SeverityLevel INT NOT NULL,
    IsContagious BIT NOT NULL,

    CONSTRAINT CHK_Diseases_Name CHECK(Name <> ''),
    CONSTRAINT CHK_Diseases_Severity CHECK(SeverityLevel >= 1 AND SeverityLevel <= 10)
)

-- Create a table with disease specializations
CREATE TABLE DiseaseSpecializations (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    DiseaseId INT NOT NULL,
    SpecializationId INT NOT NULL,

    CONSTRAINT FK_DiseaseSpecializations_Disease FOREIGN KEY(DiseaseId) REFERENCES Diseases(Id),
    CONSTRAINT FK_DiseaseSpecializations_Specialization FOREIGN KEY(SpecializationId) REFERENCES Specializations(Id)
)



-- Execute the current batch of scripts
GO

-- Insert data into departments table
INSERT INTO Departments (Name) VALUES
(N'Intensive Treatment department'),
(N'Cardiology'),
(N'Neurology'),
(N'Oncology'),
(N'Pediatrics'),
(N'Orthopedics'),
(N'Dermatology'),
(N'Gastroenterology'),
(N'Urology'),
(N'Psychiatry'),
(N'Radiology'),
(N'Test Department')

-- Insert data into doctors table
INSERT INTO Doctors (Name, Surname, Premium, Salary) VALUES
(N'John', N'Smith', 1000, 5000),
(N'Anna', N'Brown', 500, 4800),
(N'Mark', N'Lee', 0, 5100),
(N'Linda', N'White', 200, 5300),
(N'James', N'Green', 300, 5200),
(N'Emily', N'Black', 0, 4900),
(N'Robert', N'King', 150, 5050),
(N'Susan', N'Young', 0, 4950),
(N'Michael', N'Clark', 400, 5150),
(N'Jessica', N'Wright', 250, 5000),
(N'Peter', N'Adams', 300, 5200),
(N'Olivia', N'Evans', 0, 5100),
(N'Test', N'Doctor', 0, 5000)

-- Insert data into specializations table
INSERT INTO Specializations (Name) VALUES
(N'Cardiologist'),
(N'Neurologist'),
(N'Oncologist'),
(N'Pediatrician'),
(N'Orthopedist'),
(N'Dermatologist'),
(N'Gastroenterologist'),
(N'Urologist'),
(N'Psychiatrist'),
(N'Radiologist'),
(N'Test Specialization')

-- Insert data into doctors specializations table
INSERT INTO DoctorsSpecializations (DoctorId, SpecializationId) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10)

INSERT INTO DoctorsSpecializations (DoctorId, SpecializationId) VALUES (
    (SELECT Id FROM Doctors WHERE Name = N'Test' AND Surname = N'Doctor'),
    (SELECT Id FROM Specializations WHERE Name = N'Test Specialization')
)

-- Insert data into sponsors table
INSERT INTO Sponsors (Name) VALUES
(N'HealthCorp'),
(N'MedLife'),
(N'PharmaPlus'),
(N'Wellness Inc'),
(N'CareGivers'),
(N'BioSupport'),
(N'LifeAid'),
(N'CharityMed'),
(N'GoodHealth'),
(N'HopeFund'),
(N'Umbrella Corporation')

-- Insert data into donation table
INSERT INTO Donations (Amount, Date, DepartmentId, SponsorId) VALUES
(100000, '2024-01-10', 1, 1),
(80000, '2024-02-15', 2, 2),
(120000, '2024-03-20', 3, 3),
(90000, '2024-04-05', 4, 4),
(11000, '2024-05-12', 5, 5),
(9500, '2024-06-18', 6, 6),
(10500, '2024-07-22', 7, 7),
(11500, '2024-08-30', 8, 8),
(9800, '2024-09-14', 9, 9),
(10200, '2024-10-01', 10, 10),
(10200, '2024-10-01', 1, 11),
(15000, CAST(GETDATE() AS DATE), 1, 1),
(12000, DATEADD(DAY, -10, CAST(GETDATE() AS DATE)), 2, 2),
(13000, DATEADD(MONTH, -2, CAST(GETDATE() AS DATE)), 3, 3)

-- Insert data into wards table
INSERT INTO Wards (Name, DepartmentId) VALUES
(N'WardA', 1),
(N'WardB', 2),
(N'WardC', 3),
(N'WardD', 4),
(N'WardE', 5),
(N'WardF', 6),
(N'WardG', 7),
(N'WardH', 8),
(N'WardI', 9),
(N'WardJ', 10),
(N'WardK', 1),
(N'WardL', 1),
(N'WardM', 1)

-- Insert data into vacations table
INSERT INTO Vacations (StartDate, EndDate, DoctorId) VALUES
('2024-07-01', '2024-07-10', 1),
('2024-08-05', '2024-08-15', 2),
('2024-09-10', '2024-09-20', 3),
('2024-10-01', '2024-10-11', 4),
('2024-11-15', '2024-11-25', 5),
('2024-12-01', '2024-12-10', 6),
('2025-01-05', '2025-01-15', 7),
('2025-02-10', '2025-02-20', 8),
('2025-03-01', '2025-03-11', 9),
('2025-04-05', '2025-04-15', 10),
('2025-05-01', '2025-05-10', 11),
('2025-06-01', '2025-06-10', 12)

-- Insert data into diseases table
INSERT INTO Diseases (Name, SeverityLevel, IsContagious) VALUES
(N'Flu', 4, 1),
(N'Cancer', 5, 0),
(N'COVID-19', 7, 1),
(N'Migraine', 2, 0)


