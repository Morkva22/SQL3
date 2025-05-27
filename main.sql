USE master
GO

-------

IF DB_ID('Academy') IS NOT NULL
DROP DATABASE Academy
IF DB_ID ('Academy') IS NULL
CREATE DATABASE Academy

------

USE Academy
GO

-----

-- Create a table with curators
CREATE TABLE Curators (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    Name NVARCHAR(MAX) NOT NULL,
    Surname NVARCHAR(MAX) NOT NULL,

    CONSTRAINT CHK_Curators_Name CHECK (Name <> ''),
    CONSTRAINT CHK_Curators_Surname CHECK (Surname <> '')
);


-- Create a table with curators groups
CREATE TABLE GroupsCurators (
    Id INT PRIMARY KEY NOT NULL IDENTITY (1, 1),
    CuratorId INT NOT NULL,
    GroupId INT NULL,

    CONSTRAINT FK_GroupsCurators_Curators FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
    CONSTRAINT FK_GroupsCurators_Groups FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);

-- Create a table with Teachers
CREATE TABLE Teachers (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Name NVARCHAR(max) NOT NULL,
    Surname NVARCHAR(max) NOT NULL,
    Salary MONEY NOT NULL,

    CONSTRAINT CHK_Teachers_Name CHECK (Name <> ''),
    CONSTRAINT CHK_Teachers_Surname CHECK (Surname <> ''),
    CONSTRAINT CHK_Salary CHECK (Salary > 0)

);


-- Create a table with Lectures
CREATE TABLE  Lectures (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    LectureRoom NVARCHAR(max) NOT NULL,
    SubjectId INT NOT NULL,
    TeacherId INT NOT NULL,

    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id),
    CONSTRAINT CHK_Lecture_Room CHECK (LectureRoom <> '')
);


-- Create a table with Subjects
    CREATE TABLE Subjects (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL UNIQUE ,


    CONSTRAINT CHK_Subject_Name CHECK (Name <> '')
);


-- Create a table with faculties
CREATE TABLE Faculties (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Financing MONEY NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT CHK_Faculty_Name CHECK (Name <> ''),
    CONSTRAINT CHK_Faculty_Financing CHECK (Financing = 0 OR Financing > 0)
);


-- Create a table with Departments
CREATE TABLE Departments (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL UNIQUE,
    Financing MONEY NOT NULL DEFAULT (0),
    FacultyId INT NOT NULL,

    CONSTRAINT CHK_Department_Name CHECK (Name <> ''),
    CONSTRAINT CHK_Department_Financing CHECK (Financing = 0 OR Financing > 0),
    CONSTRAINT FK_Departments_Faculties FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)

);


-- Create a table with Groups
CREATE TABLE Groups (
    Id INT NOT NULL UNIQUE IDENTITY (1,1),
    Name NVARCHAR(10) NOT NULL UNIQUE,
    Year INT NOT NULL,
    DepartmentId INT NOT NULL,

    CONSTRAINT CHK_Group_Name CHECK (Name <> ''),
    CONSTRAINT CHK_Group_Year CHECK (Year > 0 AND Year <= 6),
    CONSTRAINT FK_Groups_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);


-- Create a table with GroupLectures
CREATE TABLE GroupsLectures (
    Id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    GroupId INT NOT NULL,
    LectureId INT NOT NULL,

    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);

-- Execute the current batch of scripts
GO


-- Insert data into curators table
INSERT INTO Curators (Name, Surname) VALUES
(N'Alex', N'Johnson'),
(N'Samantha', N'Adams'),
(N'Linda', N'White');

-- Insert data into faculties table
INSERT INTO Faculties (Financing, Name) VALUES
(100000, N'Computer Science'),
(80000, N'Mathematics'),
(120000, N'Physics');

-- Insert data into departments table
INSERT INTO Departments (Financing, Name, FacultyId) VALUES
(110000, N'Software Engineering', 1),
(70000, N'Applied Math', 2),
(130000, N'Theoretical Physics', 3),
(90000, N'Artificial Intelligence', 1);

-- Insert data into groups table
INSERT INTO Groups (Name, Year, DepartmentId) VALUES
(N'P107', 5, 1),
(N'M201', 3, 2),
(N'CS301', 5, 4),
(N'PHY101', 2, 3);

-- Insert data into curators groups table
INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Insert data into subjects table
INSERT INTO Subjects (Name) VALUES
(N'Database theory'),
(N'Linear Algebra'),
(N'Quantum Mechanics'),
(N'Artificial Intelligence');

-- Insert data into teachers table
INSERT INTO Teachers (Name, Salary, Surname) VALUES
(N'Samantha', 6000, N'Adams'),
(N'John', 5500, N'Smith'),
(N'Linda', 5800, N'White'),
(N'Alex', 6200, N'Johnson');

-- Insert data into lectures table
INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId) VALUES
(N'B103', 1, 1), -- Samantha Adams, Database theory
(N'B104', 2, 2), -- John Smith, Linear Algebra
(N'B103', 4, 3), -- Linda White, Artificial Intelligence
(N'C201', 3, 4); -- Alex Johnson, Quantum Mechanics

-- Insert data into lectures groups table
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
(1, 1), -- P107, Database theory
(2, 2), -- M201, Linear Algebra
(3, 3), -- CS301, Artificial Intelligence
(4, 4), -- PHY101, Quantum Mechanics
(1, 3); -- P107, Artificial Intelligence

-- Execute the current batch of scripts
GO

-- Print all possible pairs of rows of teachers and groups.
SELECT G.Name AS [Group], T.Name + N' ' + T.Surname AS [Teachers full name] FROM Groups AS G
JOIN Teachers AS T ON TRUE
ORDER BY G.Name
GO

-- Print the names of the faculties where the departmental funding exceeds the faculty funding.
SELECT D.Name AS [Departtment], D.Financing AS [Department Financing], F.Name AS [Faculteit], F.Financing AS [Faculteit Financing] FROM Faculties AS F
JOIN Departments AS D ON F.Id = D.FacultyId
WHERE D.Financing > F.Financing
ORDER BY D.Financing
GO

-- Print the names of the group curators and the names of the groups they curate.
SELECT C.Name + N' ' + C.Surname AS [Curator Full Name], G.Name AS [Group Name] FROM GroupsCurators AS GC
JOIN Curators AS C ON GC.CuratorId = C.Id
JOIN Groups AS G ON GC.GroupId = G.Id
GO

-- Print the names of teachers who give lectures in group "P107".
SELECT T.Name + N' ' + T.Surname AS [Teacher Full Name] FROM Teachers AS T
JOIN Lectures AS L ON T.Id = L.TeacherId
JOIN GroupsLectures AS GL ON L.Id = GL.LectureId
JOIN Groups AS G ON GL.GroupId = G.Id
WHERE G.Name = N'P107'
GO



-- Print the names of the lecturers and the names of the faculties where they lecture.
SELECT T.Name + N' ' + T.Surname AS [Teacher Full Name], F.Name AS [Faculty] FROM Teachers AS T
JOIN Lectures AS L ON L.TeacherId = T.Id
Join GroupsLectures AS GL on GL.LectureId = L.Id
JOIN Groups AS GR ON GR.ID = GL.GroupId
JOIN Departments AS D ON D.Id = GR.DepartmentId
JOIN Faculties AS F ON F.Id = D.FacultyId
GO


-- Print the names of the departments and the names of the groups that belong to them.
SELECT Dep.Name AS [Department], Gr.Name AS [Group] FROM Groups AS Gr
JOIN Departments AS Dep ON Dep.Id = Gr.DepartmentId
GO;


-- Print the names of the subjects taught by the teacher "Samantha Adams".
SELECT S.Name AS [Subject] FROM Subjects AS S
JOIN Lectures AS L ON L.SubjectId = S.Id
JOIN Teachers AS T ON T.ID = L.TeacherID
WHERE T.Name = N'Samatha' AND T.Surname = N'Adams'
GO


-- Print the names of the departments where the subject "Database theory" is taught.
SELECT D.Name AS [Department] FROM Departments AS D
JOIN Groups AS Gr ON GR.DepartmentId = D.ID
JOIN GroupsLectures AS GL ON GL.GroupID = Gr.ID
JOIN Lectures AS L ON L.Id = GL.LectureId
JOIN Subjects AS S ON S.Id = L.SubjectId
WHERE S.Name = N'Database theory'
GO


-- Print the names of the groups that belong to the faculty "Computer Science".
SELECT Gr.Name AS [Group] FROM Groups AS GR
JOIN Departments AS D ON D.Id = Gr.DepartmentId
JOIN Faculties AS F ON F.Id = D.FacultyId
WHERE F.Name = 'Computer Science'
GO;


-- Print the names of the 5th year groups and the names of the faculties they belong to.
SELECT F.Name AS [Faculty], G.Name AS [Group] FROM Groups AS G
JOIN Departments D on G.DepartmentId = D.Id
JOIN Faculties AS F ON F.Id = D.FacultyId
WHERE G.Year = 5
GO;

-- Print the names of the lecturers and the lectures they give (names of disciplines and groups), and print only those lectures that are given in the classroom "B103".
SELECT T.Name + N' ' + T.Surname AS [Teacher Full Name], S.Name AS [Subject], G.Name AS [Group], L.LectureRoom FROM Teachers AS T
JOIN Lectures AS L ON L.TeacherId = T.Id
JOIN Subjects AS S ON S.Id = L.SubjectId
JOIN GroupsLectures GL on L.Id = GL.LectureId
JOIN Groups AS G ON G.Id = GL.GroupId
WHERE L.LectureRoom = N'B103'
GO