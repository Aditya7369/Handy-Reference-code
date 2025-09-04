--MSSQL (Microsoft SQL Server) is RDBMS that handles data storage,retrievel and management using SQL language.
--SSMS (SQL Server Management Studio) is GUI tool designed for managing and administering SQL server instances.

--# https://www.sqlservertutorial.net/getting-started/what-is-sql-server/

--# Query Converter from MSSQL to MySQL Online.
--# http://www.sqlines.com/online

--import sqlalchemy
--from sqlalchemy import create_engine
--user="sa"
--password="SA@123"
--server="Aditya-7369\SQLSERVER22DEV" # SELECT @@SERVERNAME;
--db="Local_DB"
--# ms_sql_db_Engine = create_engine(f"mssql+pyodbc://{user}:{password}@{server}/{db}?driver=ODBC+Driver+17+for+SQL+Server",fast_executemany=True)
--ms_sql_db_Engine = create_engine(f"mssql+pyodbc://{server}/{db}?driver=ODBC+Driver+17+for+SQL+Server",fast_executemany=True)
--ms_sql_db_Connection = ms_sql_db_Engine.connect()

--=======================================================| SQL | DDL,DML,DCL,TCL and DQL Commands |START|
--DQL (Data Query Language)
--/ SELECT /
--DDL (Data Definition Language)
--/ CREATE / ALTER / DROP / TRUNCATE / RENAME / ENABLE (Trigger) / DISABLE (Trigger) /
--DML(Data Manipulation Language)
--/ INSERT / UPDATE / DELETE / LOCK /
--DCL (Data Control Language)
--/ GRANT / REVOKE /
--TCL (Transaction Control Language)
--/ COMMIT / ROLLBACK / SAVEPOINT (SAVE TRANSACTION) /
-------------------------------------------------------------------------------|
--# https://media.geeksforgeeks.org/wp-content/uploads/20210920153429/new.png
-------------------------------------------------------------------------------|
--=======================================================| SQL | DDL,DML,DCL,TCL and DQL Commands |END|




-- This will delay execution for 10 seconds
WAITFOR DELAY '00:00:10';

-- This will delay execution until 2:30 PM today
WAITFOR TIME '14:30:00';


SELECT @@SERVERNAME;

CREATE DATABASE Local_DB;
USE Local_DB;

select databases;
SELECT * FROM sys.databases;

--# sys : system schema :
SELECT TOP 500 * FROM sys.objects;
SELECT TOP 500 * FROM sys.columns;
SELECT TOP 500 * FROM sys.views;
SELECT TOP 500 * FROM sys.tables;
SELECT TOP 500 * FROM sys.procedures;
SELECT TOP 500 * FROM sys.events;
SELECT TOP 500 * FROM sys.indexes;
SELECT TOP 500 * FROM sys.index_columns;
SELECT TOP 500 * FROM sys.foreign_keys;
SELECT TOP 500 * FROM sys.foreign_key_columns;
SELECT TOP 500 * FROM sys.triggers;
SELECT TOP 500 * FROM sys.server_triggers;
SELECT TOP 500 * FROM sys.database_permissions;

SELECT top 10 ROUTINE_CATALOG,ROUTINE_SCHEMA,ROUTINE_NAME,ROUTINE_DEFINITION
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE';


select iif(null>1,1,0);


select distinct ROUTINE_TYPE from INFORMATION_SCHEMA.ROUTINES;
--ROUTINE_TYPE
--FUNCTION
--PROCEDURE

--DQL (Data Query Language) ===================================================|START|
--/ SELECT /
SELECT * FROM #T1;
--=============================================================|START|
--# TOP/LIMIT , PERCENT AND WITH OFFSET
--# in MySQL ---------------------------------------------------|
SELECT employee_id, employee_name
FROM employees
LIMIT 1 OFFSET 5;
--# in In Microsoft SQL Server (MSSQL) -------------------------|
SELECT EmployeeID, EmployeeName
FROM Employees
ORDER BY EmployeeID
OFFSET 5 ROWS
FETCH NEXT 1 ROW ONLY;
--# fetch 6th record.
---------------------------------------------------------------|

SELECT TOP 50 * FROM #Employee;
SELECT TOP 50 PERCENT * FROM #Employee;

--# The OFFSET and FETCH clauses are the options of the ORDER BY clause. 
SELECT * FROM #Employee 
ORDER BY EmpCode 
OFFSET 2 ROWS;

SELECT * FROM #Employee 
ORDER BY EmpCode 
OFFSET 2 ROWS 
FETCH NEXT 3 ROWS ONLY;
--=============================================================|END|
-------------------------------------------------------------------------------|
--DQL (Data Query Language) ===================================================|END|




--DDL (Data Definition Language)  --# Not able to ROLLBACK. ===================|START|
--/ CREATE / ALTER / DROP / TRUNCATE / RENAME / ENABLE (Trigger) / DISABLE (Trigger) /
CREATE TABLE #SPL_SA_VideosTable1 (
    VID INT IDENTITY(1,1) PRIMARY KEY,
	Title VARCHAR(MAX),
    YoutubeEmbedCode VARCHAR(MAX),
	SourceID INT FOREIGN KEY REFERENCES #T1(ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);
ALTER TABLE #T1 ADD C_New INT;
ALTER TABLE #T1 ALTER COLUMN C_New VARCHAR(10);
ALTER TABLE #T1 DROP COLUMN C_New;
DROP TABLE #T1;
TRUNCATE TABLE #T1;
EXEC SP_RENAME @objname = '#T1.Old_ColName', @newname = 'New_ColName', @objtype = 'COLUMN'; --# To Rename Column.
EXEC SP_RENAME @objname = 'table1', @newname = 'table2', @objtype = 'OBJECT';

EXEC SP_RENAME '#T1.Old_ColName','New_ColName','COLUMN';
EXEC SP_RENAME '#table_Name','#table_Name_New','OBJECT';

--------------------------------------|
SELECT TOP 5 * FROM sys.Tables;
--------------------------------------|

--------------------------------------|
--====================================|Constraints|START|
SELECT TOP 5 * FROM sys.key_constraints;
--------------------------------------|
ALTER TABLE #t1   
ADD ColumnD int NULL   
CONSTRAINT CHK_ColumnD_T1   
CHECK (ColumnD > 10 AND ColumnD < 50);

ALTER TABLE #t1
ALTER COLUMN ColumnD INT NULL;
ALTER TABLE #t1
ADD CONSTRAINT CHK_ColumnD_T1 CHECK (ColumnD > 10 AND ColumnD < 50);

--------------------------------------------------|
ALTER TABLE #t1  
DROP CONSTRAINT PK_ID;
--------------------------------------------------|
DROP TABLE IF EXISTS #T1;
CREATE TABLE #T1 
   (
      ID int NOT NULL,
      TempID int NOT NULL,
      Age int NOT NULL,
	  Gender VARCHAR(1),
	  Name nvarchar(50),
      BirthDate DATE NOT NULL check(BirthDate>='2000-01-01'),
	  SpidFilter SMALLINT NOT NULL DEFAULT (0)
	  , CONSTRAINT CH_T1_Age CHECK(Age>=18)
	  , CONSTRAINT CH_T1_Gender CHECK(Gender IN ('M','F'))
      , CONSTRAINT PK_T1 PRIMARY KEY NONCLUSTERED (ID)
      , CONSTRAINT FK_T1 FOREIGN KEY (TempID) REFERENCES #T2 (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
   )
;
--------------------------------------------------|
CREATE TABLE #t11  
 (  
   ID int NOT NULL,   
   CONSTRAINT AK_ID UNIQUE(ID)   
); 
--------------------------------------------------|
ALTER TABLE #T1   
ADD CONSTRAINT AK_Columns UNIQUE (C1, C2);
--------------------------------------------------|
--# Primary Key:
--  A table can have only one Primary Key.
--  But This key can contain No. of Columns.
--EX.
ALTER TABLE tbl_TableName ADD PRIMARY KEY (C1); --# Normal Key.
ALTER TABLE tbl_TableName ADD PRIMARY KEY (C1,C2); --# Composite Key.
--------------------------------------------------|
--====================================|Constraints|END|

--------------------------------------------------|
--# Normal, Computed OR Calculated Columns:
CREATE TABLE TBL_NCC_Columns(
	ID INT IDENTITY --# Normal Column
	,C2 INT --# Normal Column
	,C3 INT --# Normal Column
	,C4 AS C2+C3--# Computed Column --# NonPersisted
	,C5 AS 'ConstantValue'--# Computed Column --# Persisted
	,C6 AS GETDATE() --# Computed Column --# Persisted
);
--------------------------------------------------|
--# There are two types of Computed Columns:
--  1. Persisted : Column is calculated when data is stored on table and Stores value in the Physical Table.
--  2. NonPersisted : Column value is calculated when SELECT statement is Executed and not Stores value in Physical Table.
-- Persisted Columns are faster than NonPersisted Columns.
-------------------------------------------------------------------------------|
--DDL (Data Definition Language)  --# Not able to ROLLBACK. ===================|END|



--DML (Data Manipulation Language)  ===========================================|START|
--syntax
-------------------------------------------------------------------------------|
SELECT * INTO #T2 FROM #T1;
-- OR --
INSERT INTO #T2(C1,C2) VALUES (1,2),(11,22),(111,222);
-------------------------------------------------------------------------------|
UPDATE #T1 SET C2=5 WHERE C1=1;
-- OR --
UPDATE T1
SET T1.C2=T2.C2
FROM #T1 T1 
JOIN #T2 T2 ON T2.C1=T1.C1
WHERE T1.C1=5;
-------------------------------------------------------------------------------|
DELETE FROM #T1 WHERE NOT C1 = 5;
--DML (Data Manipulation Language)  ===========================================|END|





--DCL (Data Control Language) ==================================================|START|
--/ GRANT / REVOKE /
--# GRANT [ALL, SELECT, INSERT, DELETE, UPDATE ] ON [Users] TO 'User'@'Server/SourceOfConnection';
--# GRANT [EXECUTE] ON [FUNCTION, PROCEDURE] TO 'User'@'Server/SourceOfConnection';
--# REVOKE [ALL, SELECT, INSERT, DELETE, UPDATE] ON [Users] FROM 'User'@'Server/SourceOfConnection';
--# REVOKE [EXECUTE] ON [FUNCTION, PROCEDURE] FROM 'User'@'Server/SourceOfConnection';

GRANT SELECT ON Users TO 'Amit'@'localhost;'
GRANT SELECT, INSERT, DELETE, UPDATE ON Users TO 'Amit'@'localhost';
GRANT ALL ON Users TO 'Amit'@'localhost';
GRANT EXECUTE ON FUNCTION Calculatesalary TO 'Amit'@'localhost';
GRANT EXECUTE ON PROCEDURE DBMSProcedure TO 'Amit'@'localhost'; 
SHOW GRANTS FOR  'Amit'@'localhost';
REVOKE SELECT ON Users FROM 'Amit'@'localhost;'
REVOKE SELECT, INSERT, DELETE, UPDATE ON Users FROM 'Amit'@'localhost';
REVOKE ALL ON Users FROM 'Amit'@'localhost';
REVOKE EXECUTE ON FUNCTION Calculatesalary FROM 'Amit'@'localhost';
REVOKE EXECUTE ON PROCEDURE DBMSProcedure FROM 'Amit'@'localhost';
-------------------------------------------------------------------------------|
SELECT
    dp.state_desc,
    dp.permission_name,
    dp.class_desc,
    OBJECT_NAME(major_id) AS object_name,
    USER_NAME(grantee_principal_id) AS grantee,
    USER_NAME(grantor_principal_id) AS grantor
FROM
    sys.database_permissions AS dp
WHERE
    USER_NAME(grantee_principal_id) = 'sa'
--DCL (Data Control Language) ==================================================|END|





--# Decimal/float =========================
SELECT CONVERT(decimal(5,2), 13.456789);
--# Decimal/float =========================



--# CHAR / VARCHAR ============================|START|
--# CHAR
--The CHAR is a data type with fixed length.
--The CHAR uses the entire declared length even if fewer characters are stored in the variable.
--The CHAR loads empty spaces.
--# VARCHAR
--The VARCHAR is a data type with variable length.
--The VARCHAR does not use the entire declared length.
--The VARCHAR uses only the length loaded with characters.
-----------------------------------------------|
DECLARE
@v_Char Char(10) = 'abcde',
@v_Varchar Varchar(10) = 'abcde'
SELECT
DATALENGTH(@v_Char) CharLen,
DATALENGTH(@v_Varchar) VarcharLen;
-----------------------------------------------|
--The Char and Varchar length must be a value from 1 through 8,000.
--# CHAR / VARCHAR ============================|START|

select LEN('abcd'),DATALENGTH('abcd');

--# VARCHAR / NVARCHAR ============================|START|
--# VARCHAR (Variable Character)
--stores data in a non-Unicode character set, typically using a single byte per character.
--This means it is suitable for storing characters from the ASCII character set, which includes English letters, digits, and common symbols.
--# NVARCHAR (National Variable Character)
--stores data in a Unicode character set, typically using two bytes per character.
--Unicode is a standard that can represent characters from virtually all written languages around the world, making NVARCHAR suitable for multilingual data.
-----------------------------------------------|
DECLARE 
@varVarchar AS varchar(250) = '2625😊',
@varNvarchar AS nvarchar(250) = N'2625😊';
SELECT @varVarchar as v_var, @varNVarchar as v_Nvar;
--# VARCHAR / NVARCHAR ============================|END|




--# Joins #===============================|START|
https://static.javatpoint.com/interview/images/sql-interview-questions3.png
------------------------------------------------|
DROP TABLE IF EXISTS T1,T2;
CREATE TABLE T1 (C1 VARCHAR(3),C_KEY INT);
SELECT * INTO T2 FROM T1 WHERE 1=2;
INSERT INTO T1 VALUES ('A1',1),('A2',2),('A6',6);
INSERT INTO T2 VALUES ('B1',1),('B2',2),('B9',9);
------------------------------------------------|

--INNER JOIN
SELECT T1.C1,T2.C1
FROM T1
JOIN T2 ON T1.C_KEY=T2.C_KEY;
------------------------------------------------|

--LEFT JOIN
SELECT T1.C1,T2.C1
FROM T1
LEFT JOIN T2 ON T1.C_KEY=T2.C_KEY;
------------------------------------------------|

--RIGHT JOIN
SELECT T1.C1,T2.C1
FROM T1
RIGHT JOIN T2 ON T1.C_KEY=T2.C_KEY;
------------------------------------------------|

--FULL OUTER JOIN
SELECT T1.C1,T2.C1
FROM T1
FULL JOIN T2 ON T1.C_KEY=T2.C_KEY;
------------------------------------------------|

--CROSS JOIN
SELECT T1.C1,T2.C1
FROM T1
CROSS JOIN T2;
-- OR --
SELECT T1.C1,T2.C1
FROM T1,T2;
------------------------------------------------|

--# Joins #===============================|END|


--=======================================================|Set Operators|START|
DROP TABLE IF EXISTS #T1;
CREATE TABLE #T1(EMP_NAME VARCHAR(10));
INSERT INTO #T1 VALUES ('A123'),('A456'),('A789'),('B123'),('B456'),('B789');
DROP TABLE IF EXISTS #T2;
CREATE TABLE #T2(EMP_NAME VARCHAR(10));
INSERT INTO #T2 VALUES ('A123'),('C456'),('C789'),('B123'),('C456'),('C789');
----------------------------------------------------------------------------|
SELECT * FROM #T1 UNION ALL 
SELECT * FROM #T2;
--------------------------|
SELECT * FROM #T1 UNION 
SELECT * FROM #T2;
--------------------------|
SELECT * FROM #T1 INTERSECT 
SELECT * FROM #T2;
--------------------------|
SELECT * FROM #T1 EXCEPT 
SELECT * FROM #T2;
--------------------------|
SELECT * FROM #T2 EXCEPT 
SELECT * FROM #T1;
--=======================================================|Set Operators|END|


--# MERGE #=============================================================|START|
-- At a same time use Insert, Update and Delete.
------------------------------------------------------------------------|
MERGE target_table USING source_table
ON merge_condition
WHEN MATCHED
    THEN update_statement
WHEN NOT MATCHED BY TARGET 
    THEN insert_statement
WHEN NOT MATCHED BY SOURCE
    THEN DELETE;
------------------------------------------------------------------------|
MERGE sales.category t 
USING sales.category_staging s
ON (s.category_id = t.category_id)
WHEN MATCHED
    THEN UPDATE SET 
        t.category_name = s.category_name,
        t.amount = s.amount
WHEN NOT MATCHED BY TARGET 
    THEN INSERT (category_id, category_name, amount)
         VALUES (s.category_id, s.category_name, s.amount)
WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;
------------------------------------------------------------------------|
--# MERGE #=============================================================|END|

--# Apply Operator in SQL Server - =============================|START|
-- It is use to join Table and Table Valued Function.
-- Cross Apply: Inner Join.
-- Outer Apply: Left Join. 
select id_num, name, balance, SUM(x.discount)
from listOfPeople
    cross apply dbo.calculatePersonalDiscount(listOfPeople.id_num) x
--# Cross Apply & Outer Apply - Apply Operator in SQL Server - =============================|START|

--25 = 7,3 | 1,4 | 5,3 | 8,2 | 1,6 | 7,5 | 3,2 | 
--25 = 1,7,3 |

--# Group by with CUBE, ROLLUP  and GROUPING SETS ================|START|
drop table if exists #t1;
create table #t1(City varchar(50), Gender varchar(50), Salary int)
insert into #t1 values 
('Pune','Male',5),
('Pune','Female',5),
('Pune','Male',5),
('Mumbai','Male',6),
('Mumbai','Female',6),
('Mumbai','Male',6);
select City,Gender,sum(Salary)Salary
from #t1 
group by City,Gender;
--City		Gender	Salary
--Mumbai	Female	6
--Pune		Female	5
--Mumbai	Male	12
--Pune		Male	10
---------------------------------------------------
select City,Gender,sum(Salary)Salary
from #t1 
group by CUBE(City,Gender);
--OR --
select City,Gender,sum(Salary)Salary
from #t1 
group by City,Gender with CUBE;
--City		Gender	Salary
--Mumbai	Female	6
--Pune		Female	5
--NULL		Female	11
--Mumbai	Male	12
--Pune		Male	10
--NULL		Male	22
--NULL		NULL	33
--Mumbai	NULL	18
--Pune		NULL	15
--# It also returns Grand Total of each column which is supplied to the cube aggrigate.
--# with all possible combinations.
---------------------------------------------------
select City,Gender,sum(Salary)Salary
from #t1 
group by ROLLUP(City,Gender);
--OR --
select City,Gender,sum(Salary)Salary
from #t1 
group by City,Gender with ROLLUP;
--City		Gender	Salary
--Mumbai	Female	6
--Mumbai	Male	12
--Mumbai	NULL	18
--Pune		Female	5
--Pune		Male	10
--Pune		NULL	15
--NULL		NULL	33
--# It only returns Grand total of first column.
--# But it maintain Hierarchical combinations only.
------------------------------------------------------
select City,Gender,sum(Salary)Salary
from #t1 
group by GROUPING SETS(
(City),
(Gender),
(City,Gender)
)
order by GROUPING(City),GROUPING(Gender);
--Mumbai	Female	6
--Pune		Female	5
--Mumbai	Male	12
--Pune		Male	10
--Mumbai	NULL	18
--Pune		NULL	15
--NULL		Male	22
--NULL		Female	11
--# GROUPING SETS operator allows to group together multiple combination which is supplied by user.
--# Group by with CUBE, ROLLUP  and GROUPING SETS ================|END|


--# INDEX #====================================|START|
--# Unique : By default created on unique constant on column of table.
--# Clustered : By default created on Primary Key. Have onely one Clustered Index per table.
--# NonClustered : Can create multiple.
-----------------------------------------------|
Create Index IDX_T1C11 on #T1 (C1) with fillfactor = 90
Create Clustered Index IDX_T1C12 on #T1 (C1) with fillfactor = 90
Create NonClustered Index IDX_T1C13 on #T1 (C1) with fillfactor = 90
--# INDEX #====================================|END|



-- # CONDITIONS STATEMENTS IN SQL. ===============|START|
IF 'A'<'B'
	BEGIN
		PRINT(1)
	END
ELSE IF 2<3
	BEGIN
		PRINT(2)
	END
ELSE
	BEGIN
		PRINT(3)
	END
-- # CONDITIONS STATEMENTS IN SQL. ===============|END|



-- # Loop IN SQL. ===============|START|
DECLARE @cnt INT = 1;
WHILE @cnt <= 10
BEGIN
	--=========================
	PRINT @cnt--Inside THE LOOP.
	--=========================
	SET @cnt = @cnt + 1;
END;
-- # Loop IN SQL. ===============|END|






--# =================================================| Dynamic Execution |START|
-- execute the dynamic SQL
DECLARE @COUNT INT = 1
DECLARE @sql NVARCHAR(MAX) = 'SELECT * FROM [Table_'+CONVERT(NVARCHAR,@COUNT)+'];'
SELECT @sql;
EXECUTE sp_executesql @sql;
EXEC(@sql);
--# =================================================| Dynamic Execution |END|


--# =================================================| PIVOT |START|
DROP TABLE IF EXISTS #T1;
CREATE TABLE #T1 (C1_TYPE VARCHAR(10), C2_VALUE INT);
INSERT INTO #T1 VALUES ('A',1),('B',3),('B',3),('C',4),('C',4),('C',4);
SELECT * FROM #T1;
-----------------------------------------------------|
SELECT * FROM #T1
PIVOT(
    COUNT(C2_VALUE) 
    FOR C1_TYPE IN (A, B, C)
) AS pivot_table;
-----------------------------------------------------|
SELECT * FROM #T1
PIVOT(
    COUNT(C2_VALUE) 
    FOR C1_TYPE IN (A,B)
) AS pivot_table;
-----------------------------------------------------|Dynamic PIVIOT|START|
DECLARE @columns NVARCHAR(MAX) = '';
SELECT @columns += QUOTENAME(C1_TYPE) + ',' FROM #T1 GROUP BY C1_TYPE ORDER BY C1_TYPE;
--# The QUOTENAME() function wraps the category name by the square brackets 
SET @columns = LEFT(@columns, LEN(@columns) - 1);
--# The LEFT() function removes the last comma from the @columns string.
PRINT @columns;
DECLARE @sql1 NVARCHAR(MAX) = '
SELECT * FROM #T1
PIVOT(
	COUNT(C2_VALUE) 
	FOR C1_TYPE IN ('+@columns+')
) AS pivot_table;'
PRINT @sql1;
EXECUTE sp_executesql @sql1;
-----------------------------------------------------|Dynamic PIVIOT|END|
--# =================================================| PIVOT |END|



--# CTE Common Table Expression =================================================|START|
--EX.
WITH ExpressionName (c1,c2,c3)
AS
(
Define_CTE
)
SELECT/INSERT/UPDATE/DELETE _Statement from ExpressionName; --# Outer Query
--------------------------------------------------------|
--When the outer query ends, the lifetime of cte also ends.
--------------------------------------------------------|
--EX.
WITH 
CTE1 AS
(
	select * from #t1 where c1=1
),
CTE2 AS
(
	select * from #t2 where c1=1
)
select * from CTE1 union select * from CTE2;
--====================================== Drop Duplicates |
WITH CTE AS(
   SELECT [BranchID], [DisbursementID], [First_NPA_Date], [First_NPA_POS], [user_dpd_max],
       RN = ROW_NUMBER()OVER(PARTITION BY [BranchID], [DisbursementID], [First_NPA_Date], [First_NPA_POS], [user_dpd_max]  ORDER BY [BranchID])
   FROM Tbl_FirstTime_NPA
)
DELETE FROM CTE WHERE RN > 1
--=========================================================|

--# SQL Server Recursive CTE examples =====================|START|
WITH cte_numbers(RN) 
AS (
    SELECT 0 RN
    UNION ALL
    SELECT RN + 1
    FROM cte_numbers
    WHERE RN < 6
)
SELECT RN FROM cte_numbers;
-----------------------------------------------------------/
WITH 
CTE_Emp_Manager(Emp_ID,Manager_ID,Emp_Name,Level) AS (
	SELECT Emp_ID,Manager_ID,Emp_Name,0 level
	FROM #T1 
	WHERE Manager_ID IS NULL
	UNION ALL
	SELECT Emp_ID,Manager_ID,Emp_Name,0 level
	FROM #T1 e
	JOIN CTE_Emp_Manager M ON M.Emp_ID=E.Manager_ID
)
SELECT Emp_ID,Manager_ID,Emp_Name,Level FROM CTE_Emp_Manager;
--# SQL Server Recursive CTE examples =====================|END|

--# CTE Common Table Expression =================================================|END|



-- # Exception Handling IN SQL. ===============| SQL TRY/CATCH |START|
BEGIN TRY
	SELECT 5/0
END TRY
-----------------------------------------|
BEGIN CATCH
	SELECT 
	 ERROR_NUMBER() AS ERROR_NUMBER
	,ERROR_MESSAGE() AS ERROR_MESSAGE
	,ERROR_LINE() AS ERROR_LINE
	,ERROR_PROCEDURE() AS ERROR_PROCEDURE
	,ERROR_SEVERITY() AS ERROR_SEVERITY
	,ERROR_STATE() AS ERROR_STATE
	,CONCAT('ERROR_PROCEDURE:',ERROR_PROCEDURE(),'; ','ERROR_LINE:',ERROR_LINE(),'; ','ERROR_MESSAGE:',ERROR_MESSAGE()) AS Error
END CATCH
-- # Exception Handling IN SQL. ===============| SQL TRY/CATCH |END|


-- # RaiseError IN SQL. ===============|START|
--# In SQL Server, the RAISEERROR function is used to generate an error message and return it to the caller,
--# Typically to indicate that something has gone wrong in the process.
--# RAISEERROR (message_string, severity, state);

--# severity levels include:
-- Severity 0-10: Informational messages or minor issues.
-- Severity 11-16: User-defined errors indicating logic problems, invalid operations, or data issues.
-- Severity 17-25: System errors, indicating severe issues in the SQL Server environment.

--# The state is a user-defined value between 0 and 255 that helps you identify different error conditions.
-- 16 (Severity): The severity level 16 is chosen here because it represents a user-defined error

---------------------------------------|
RaisError(N'This is an error.',10,1);
---------------------------------------|
RAISERROR (
'EmpID cannot be NULL.', -- Message text.
16, -- Severity.
1 -- State.
);
---------------------------------------|
BEGIN TRY
    -- RAISERROR with severity 11-19 will cause execution to
    -- jump to the CATCH block.
    RAISERROR ('Error raised in TRY block.', -- Message text.
               16, -- Severity.
               1 -- State.
               );
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    -- Use RAISERROR inside the CATCH block to return error
    -- information about the original error that caused
    -- execution to jump to the CATCH block.
    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );
END CATCH;
---------------------------------------|
-- # RaiseError IN SQL. ===============|END|







-- # Transactions IN SQL. =====================================|START|

--# Properties of Transaction #
--Atomicity: The outcome of a transaction can either be completely successful or completely unsuccessful. The whole transaction must be rolled back if one part of it fails.
--Consistency: Transactions maintain integrity restrictions by moving the database from one valid state to another.
--Isolation: Concurrent transactions are isolated from one another, assuring the accuracy of the data.
--Durability: Once a transaction is committed, its modifications remain in effect even in the event of a system failure.

--=======================================|START|
---------------------------------------------|
PRINT @@TRANCOUNT    
BEGIN TRAN  
    PRINT @@TRANCOUNT  
    BEGIN TRAN  
        PRINT @@TRANCOUNT   
    COMMIT  
    PRINT @@TRANCOUNT  
COMMIT  
PRINT @@TRANCOUNT  
--Results 
----------------------------------------------|
--# Save transaction example:
PRINT(@@TRANCOUNT)
IF @@TRANCOUNT = 0
	BEGIN TRANSACTION T1
		SAVE TRANSACTION SP2
		DROP TABLE IF EXISTS #T1;
		PRINT(@@TRANCOUNT)
		BEGIN TRANSACTION T2
			DROP TABLE IF EXISTS #T2;
			PRINT(@@TRANCOUNT)
		ROLLBACK TRANSACTION SP2
		COMMIT
		--After rollback a specific Save Point need to commit the transaction.
		PRINT(@@TRANCOUNT)
	COMMIT
	PRINT(@@TRANCOUNT)
--=======================================|END|


--=======================================| SQL TRY/CATCH With Transaction |START|
DROP TABLE IF EXISTS #Books;
CREATE TABLE #BooksTRAN (book_id INT,book_name VARCHAR(100));
INSERT INTO #BooksTRAN (book_id, book_name) VALUES (1, 'Book 1'),(2, 'Book 2'),(3, 'Book 3'),(4, 'Book 4'),(5, 'Book 5'),(6, 'Book 6'),(7, 'Book 7'),(8, 'Book 8');
--=======================================|
BEGIN TRY
	BEGIN TRANSACTION
		--# STATEMENT ===================|START|
		UPDATE #BooksTRAN SET book_name='Book999' WHERE book_id=1;
		PRINT(9/0)
		--# STATEMENT ===================|END|
	COMMIT TRANSACTION
	PRINT('EXEC COMMITED')
END TRY
-----------------------------------------|
BEGIN CATCH
	ROLLBACK TRANSACTION
	PRINT('EXEC FAILED')
	PRINT(ERROR_NUMBER())
	PRINT(ERROR_MESSAGE())
	PRINT(ERROR_STATE())
	PRINT(ERROR_SEVERITY())
	PRINT(ERROR_PROCEDURE())
END CATCH
--=======================================|
select * from #BooksTRAN;
--=======================================| SQL TRY/CATCH With Transaction |END|

-- # Transactions IN SQL. =====================================|END|








-- # Cursors IN SQL. =======================================|START|
-- Use to retrieve data from a result set one row at a time.
-- It is used to update records in a database table row by row.
-- @@FETCH_STATUS returns the status of last curser fetch.
-- if there is no data left in a result set it returns -1.
------------------------------------------------------------|
--# Stages of curser.
-- 1. DECLARE CURSER
-- 2. OPEN
-- 3. FETCH
-- 4. CLOSE
-- 5. DEALLOCATE
------------------------------------------------------------|
--# Fetch Data from the Cursor There is a total of 6 methods:
-- 1. FIRST is used to fetch only the first row from the cursor table. 
-- 2. LAST is used to fetch only the last row from the cursor table. 
-- 3. NEXT is used to fetch data in a forward direction from the cursor table. 
-- 4. PRIOR is used to fetch data in a backward direction from the cursor table. 
-- 5. ABSOLUTE n is used to fetch the exact nth row from the cursor table. 
-- 6. RELATIVE n is used to fetch the data in an incremental way as well as a decremental way.
--# Query:
FETCH FIRST FROM CUR_C1;
FETCH LAST FROM CUR_C1;
FETCH NEXT FROM CUR_C1;
FETCH PRIOR FROM CUR_C1;
FETCH ABSOLUTE 7 FROM CUR_C1;
FETCH RELATIVE -2 FROM CUR_C1;
--# Implementation CURSOR ==================================|
------------------------------------------------------------|
DECLARE CUR_C1 CURSOR FOR SELECT * FROM Local_DB..Table_1;
OPEN CUR_C1;
	FETCH NEXT FROM CUR_C1;
	FETCH NEXT FROM CUR_C1;
	FETCH NEXT FROM CUR_C1;
CLOSE CUR_C1;
DEALLOCATE CUR_C1;
------------------------------------------------------------|
DECLARE CUR_C2 CURSOR FOR
SELECT C1,C2 FROM Local_DB..Table_1;
--------------------------------
OPEN CUR_C2;
DECLARE @C1 INT, @C2 VARCHAR(1);
FETCH NEXT FROM CUR_C2 INTO @C1, @C2;
--------------------------------
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT CONCAT(@C1,' ',@C2);
	FETCH NEXT FROM CUR_C2 INTO @C1, @C2;
END
--------------------------------
CLOSE CUR_C2;
DEALLOCATE CUR_C2;
------------------------------------------------------------|
-- # Cursors IN SQL. =======================================|END|



--# CREATE VIEW ======================================================================|START|
CREATE VIEW [VW_SPL_SA_LeagueContest]
AS
SELECT	L.LeagueID, L.League
		,C.ContestID, C.Contest
FROM SPL_SA_LeagueTable L WITH(NOLOCK)
JOIN SPL_SA_ContestTable C WITH(NOLOCK) ON C.LeagueID=L.LeagueID
------------------------------------------------------------------------|
-- 1. In view we can perform Delete,Update,Insert.# DML Commands over there.
-- 2. If there is any function is used in any column, this column is unable to Update.
------------------------------------------------------------------------|
-- 3. We can create Read only View.
CREATE VIEW SampleView
AS
  SELECT ID, VALUE FROM TABLE
  UNION ALL
  SELECT 0, '0' WHERE 1=0 --# False condition.
  WITH CHECK OPTION;
------------------------------------------------------------------------|

--# Simple vs Complex vs Materialized Views:
-- Simple: Logical Table from single table, Does not hold Data.
-- Complex: Logical Table from Multiple table, Does not hold Data.
-- Materialized: Like a Physical Table it Holds Data.


--# CREATE VIEW ======================================================================|END|



--# CREATE Stored Procedure ======================================================================|START|
--CREATE PROCEDURE procedure_name
--AS
--sql_statement
--GO;
--EXEC procedure_name;

--# To get SP which is created. and read the entire SP.
SELECT top 10 ROUTINE_CATALOG,ROUTINE_SCHEMA,ROUTINE_NAME,ROUTINE_DEFINITION
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE';

-- # Stored Procedure IN SQL. ===============================================||
-- It is a database object which contain a set of logical T-SQL statements.
-- We can save compilation time of executing query.
USE Local_DB;
CREATE PROCEDURE SP_Test1 @VAR1 INT,@VAR2 INT
AS
BEGIN
	select * from Local_DB..Table_1 where c1 in (@VAR1,@VAR2);
END;
---------------------------------------------------------------------|
EXECUTE SP_Test1 @VAR1=1,@VAR2=2;
EXEC SP_Test1 1,2;

--============================================================================|


-- # Stored Procedure with Optional Input parameter IN SQL. =================||
USE Local_DB;
CREATE OR ALTER PROCEDURE SP_Test111_OutPut_Count @VAR1 INT = Null
AS
BEGIN
	if @VAR1 is null
		begin
			print(Null)
		end
	else 
		begin
			print(@VAR1)
		end
END;
---------------------------------------------------------------------|
EXECUTE SP_Test111_OutPut_Count;
EXECUTE SP_Test111_OutPut_Count 5;


--============================================================================|

-- # Stored Procedure with Input & OutPut parameter IN SQL. =================||
USE Local_DB;
CREATE OR ALTER PROCEDURE SP_Test1_OutPut_Count @VAR1 INT,@VAR2 INT,@TableCount INT OutPut
AS
BEGIN
	select @TableCount = COUNT(1) from Local_DB..Table_1 where c1 in (@VAR1,@VAR2);
END;
---------------------------------------------------------------------|
DECLARE @Count INT;
EXECUTE SP_Test1_OutPut_Count 1,2,@Count OutPut;
SELECT @Count AS TableCount;

-- OR --
USE Local_DB;
CREATE OR ALTER PROCEDURE SP_Test1_OutPut_Count @VAR1 INT
AS
BEGIN
	DECLARE @TableCount INT
	select @TableCount = COUNT(1) from Local_DB..Table_1;
	RETURN @TableCount
END;
---------------------------------------------------------------------|
DECLARE @Count INT;
EXECUTE @Count = SP_Test1_OutPut_Count @VAR1=5;
SELECT @Count AS TableCount;

--# To access the SP's text : use SP_helptext 'SP_Name';
EXEC SP_helptext 'SP_Name';

--# Using With Encryption: To hide the SP code.
USE Local_DB;
CREATE PROCEDURE SP_Test1
WITH ENCRYPTION
AS
BEGIN
	select * from Local_DB..Table_1;
END;

--# Using With SCHEMABINDING: To restrict DDL commands (Unable to alter table structure) operation on used tables in SP.
USE Local_DB;
CREATE PROCEDURE SP_Test2
WITH SCHEMABINDING
AS
BEGIN
	select * from Local_DB..Table_1;
END;
---------------------------------------------------------------------|


--# CREATE Stored Procedure ======================================================================|END|




-- # Stored Functions IN SQL. =======================================|START|
-- It is a database object which contain a set of logical Query.
-- It must returns a Value. Use with SELECT statement.
-- Can not use exception handling.

--# User Define Functions: ==========================================|
---------------------------------------------------------------------|
-- 1. Scalar Functions:
--    It can take no of parameters and return only single scalar value.
--    can be any data type except text, ntext, image, cursor and timestamp.
--    Sclalr functions can call other functions as well.
---------------------------------------------------------------------|
-- EX.
CREATE FUNCTION FN_ShowMSG()
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN 'Well Come Friends'
END;
SELECT dbo.FN_ShowMSG();    --# dbo Stands for DataBase Owner.
---------------------------------------------------------------------|
CREATE FUNCTION FN_WithParameter( @Par1 INT, @Par2 INT)
RETURNS INT
AS
BEGIN
	RETURN (@Par1*@Par2)
END;
SELECT dbo.FN_WithParameter(5,2);
---------------------------------------------------------------------|

-- 2. Inline Table Valued:
--    It contain T-SQL statement which returns Table set.
--    It does not contain BEGIN & END.
--    It is use like as a table.
CREATE FUNCTION FN_TableVAlued()
RETURNS TABLE
AS
RETURN (SELECT * FROM T1);
SELECT * FROM FN_TableVAlued();
---------------------------------------------------------------------|
CREATE FUNCTION FN_TableVAlued2(@Para1 INT)
RETURNS TABLE
AS
RETURN (SELECT * FROM T1 WHERE C_KEY=@Para1);
SELECT * FROM FN_TableVAlued2(1);
---------------------------------------------------------------------|
CREATE or ALTER FUNCTION FN_TableVAlued3(@Para1 INT)
RETURNS TABLE
AS
RETURN (SELECT c1, 123 [No] FROM T1 WHERE C_KEY=@Para1);
SELECT * FROM FN_TableVAlued3(1);
---------------------------------------------------------------------|

-- 3. Multi-Statement Table valued function:
--    It is a table valued function that returns a result of multiple statements.
CREATE FUNCTION FN_MultiStatementTableValuedFn()
RETURNS @R_Table TABLE (C1 INT, C2 VARCHAR(5))
AS
BEGIN
	INSERT INTO @R_Table(C1,C2)
	VALUES (1,'A'),(1,'A'),(1,'A'),(1,'A')
	RETURN
END;
SELECT * FROM FN_MultiStatementTableValuedFn();
---------------------------------------------------------------------|
--===================================================================|
-- # Stored Functions IN SQL. =======================================|END|





-- # Triggers IN SQL. =======================================|END|
-- Special kind of Procedure which is designed for a perticular event.
-- On that event, it is executed implicitly.
-- Can be planned for:
-- # DDl, DML and LogOn Triggers.
-------------------------------------------------------------|
-- # Table Level Triggers : Stored on Table folder. (In Table folder => Triggers)
-- # Database Level Triggers : Stored on Perticular DB. (In Database Folder => Database Triggers)
-- # Server Level Triggers : Stored on Master DB. (In Server Objects Folder => Triggers)
-------------------------------------------------------------|
-- # To Delete Trigger:
DROP TRIGGER TR_TriggerName; --# For DML Trigger.
DROP TRIGGER TR_TriggerName ON DATABASE; --# For DDL Trigger DB level.
DROP TRIGGER TR_TriggerName ON ALL SERVER; --# For DDL Trigger Server level.
-------------------------------------------------------------|
-- We can ENABLE or DISABLE Triggers.
DISABLE TRIGGER TR_TriggerName ON DATABASE;
ENABLE TRIGGER TR_TriggerName ON DATABASE;
EXEC SP_HelpText TR_TriggerName;
-------------------------------------------------------------|
--# Set Execution order of Triggers.
-- SP_SetTriggerOrder
-- @TriggerName,
-- @Order ('First'/'Last'/None),
-- @stmtType (Statement Type like 'Insert'/'Update'/'Delete')
EXEC SP_SetTriggerOrder @TriggerName='TR_TriggerName', @Order='First', @stmtType='Insert';
-------------------------------------------------------------|

--# Two types:
--# After Trigger : 
--	AFTER INSERT, AFTER UPDATE, AFTER DELETE.
--  It Executed after any action occurs.
--  No. of After Triggers can apply on Same table.
--# Instead Trigger : 
--	INSTEAD OF INSERT, INSTEAD OF UPDATE, INSTEAD OF DELETE.
--  It Executed before any action will perform.
--  Only one Instead Trigger can apply on each table.

-- 1. After Insert Trigger: Fires after an INSERT operation is performed on a table.
-- 2. After Update Trigger: Fires after an UPDATE operation is performed on a table.
-- 3. After Delete Trigger: Fires after a DELETE operation is performed on a table.
-- 4. After Trigger on Multiple Actions: Fires after any action (INSERT, UPDATE, DELETE) is performed on a table.
-- 5. After Trigger on Database-Level Events: Fires after database-level events such as database startup or shutdown.
-- 6. After Trigger on Server-Level Events: Fires after server-level events such as server startup or shutdown.


-----------------------------------------------------------------|
-- Magic Table : Inserted/Deleted table are same as applied table.
-----------------------------------------------------------------|
CREATE OR ALTER TRIGGER TR_T1_Insert
ON Table_1 
FOR INSERT
AS
BEGIN
    DECLARE @NEW_VAL VARCHAR(1);
    SELECT @NEW_VAL = C2 FROM INSERTED;
    
    -- Check if the inserted value meets the required condition
    IF (@NEW_VAL < 'A')
    BEGIN
        PRINT 'Inserted value must be greater than or equal to "A".';
        ROLLBACK;
    END;
END;
--SELECT * FROM Table_1
--INSERT INTO Table_1 values (10,'D');
-----------------------------------------------------------------|
CREATE OR ALTER TRIGGER TR_T1_UPDATE
ON Table_1 
FOR UPDATE
AS
BEGIN
	DECLARE @OLD_VAL VARCHAR(1);
	DECLARE @NEW_VAL VARCHAR(1);
	SELECT @OLD_VAL = C2 FROM DELETED;
	SELECT @NEW_VAL = C2 FROM INSERTED;
	IF (@OLD_VAL>@NEW_VAL)
	BEGIN
		PRINT 'New value can''t be less than Old value';
		ROLLBACK;
	END;
END;
--SELECT * FROM Table_1
--INSERT INTO Table_1 values (10,'D');
--UPDATE Table_1 SET C2='A' WHERE C1=10;
-----------------------------------------------------------------|
CREATE OR ALTER TRIGGER TR_Table1_DELETE_One
ON Table_1
FOR DELETE
AS
BEGIN
	IF (SELECT COUNT(1) FROM DELETED)>1
	BEGIN
		PRINT 'Only one record will be deleted at a time.'
		ROLLBACK;
	END;
END;
--DELETE FROM Table_1 WHERE 1=1;
-----------------------------------------------------------------|
CREATE OR ALTER TRIGGER TR_AuditLog
ON YourTable
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Insert into audit log for INSERT operations
    IF EXISTS (SELECT * FROM INSERTED)
    BEGIN
        INSERT INTO AuditLog (Action, Timestamp, UserId, TableName, Details)
        SELECT 'INSERT', GETDATE(), UserId, 'YourTable', 'Inserted: ' + CAST(Id AS VARCHAR(10)) + ', ' + Name
        FROM INSERTED;
    END;

    -- Insert into audit log for UPDATE operations
    IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        INSERT INTO AuditLog (Action, Timestamp, UserId, TableName, Details)
        SELECT 'UPDATE', GETDATE(), UserId, 'YourTable', 'Updated: ' + CAST(Id AS VARCHAR(10)) + ', ' + Name
        FROM INSERTED;
    END;

    -- Insert into audit log for DELETE operations
    IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        INSERT INTO AuditLog (Action, Timestamp, UserId, TableName, Details)
        SELECT 'DELETE', GETDATE(), UserId, 'YourTable', 'Deleted: ' + CAST(Id AS VARCHAR(10)) + ', ' + Name
        FROM DELETED;
    END;
END;

-----------------------------------------------------------------|
--# Instead Trigger
drop table if exists tbl_forInsteadOfTrigger;
create table tbl_forInsteadOfTrigger(c1 int,c2 int,c3 int)
insert into tbl_forInsteadOfTrigger values(1,10,100),(2,20,200),(3,30,300);
select * from tbl_forInsteadOfTrigger;
----------------------------------------
CREATE TRIGGER TR_INST_INSERT
ON tbl_forInsteadOfTrigger
INSTEAD OF INSERT
AS 
BEGIN
	PRINT('Unable to Insert!')
END;
--DROP TRIGGER TR_INST_INSERT;
insert into tbl_forInsteadOfTrigger values(1,10,100)
----------------------------------------
CREATE TRIGGER TR_INST_UPDATE
ON tbl_forInsteadOfTrigger
INSTEAD OF UPDATE
AS 
BEGIN
	PRINT('Unable to Update!')
END;
--DROP TRIGGER TR_INST_UPDATE;
update tbl_forInsteadOfTrigger set c1=1;
----------------------------------------
CREATE TRIGGER TR_INST_DELETE
ON tbl_forInsteadOfTrigger
INSTEAD OF DELETE
AS 
BEGIN
	PRINT('Unable to Delete!')
END;
--DROP TRIGGER TR_INST_DELETE;
DELETE from tbl_forInsteadOfTrigger; 
----------------------------------------
-----------------------------------------------------------------|
-----------------------------------------------------------------|

-- # Triggers IN SQL. =======================================|END|


--Insted of Trigger in MSSQL ==============================|START|
--Ex_____________________________________________________________|
create table Tbl_Dept (Id int identity(1,1) primary key, Name varchar(10));
create table Tbl_Emp (Id int identity(1,1) primary key, Name varchar(10), DepID int foreign key references Tbl_Dept(Id));
insert into Tbl_Dept values('Dept A'),('Dept B'),('Dept C');
insert into Tbl_Emp values('Name A',1),('Name B',1),('Name C',1),('Name D',2),('Name E',2),('Name F',3);
--select * from Tbl_Dept;
--select * from Tbl_Emp;
create view VW_EmpDept
as
	select	e.id as EmpID,
			e.Name as Employee,
			d.Name as Department
	from Tbl_Emp as e
	join Tbl_Dept as d
	on d.Id=e.DepID;
select * from VW_EmpDept;
-------------------------------------|
CREATE OR ALTER TRIGGER TR_VW_EmpDip_OnInsert
ON VW_EmpDept
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @EmpID INT, @EmpName VARCHAR(10), @DeptID INT;

	SELECT @EmpID = I.EmpID, @EmpName = I.Employee, @DeptID = D.ID
	FROM INSERTED I
	JOIN Tbl_Dept D ON D.Name=I.Department;

	IF @DeptID IS NULL
		BEGIN
			PRINT 'Invalid Department.';
			ROLLBACK;
		END;
	ELSE
		BEGIN
			SET IDENTITY_INSERT Tbl_Emp ON;
			INSERT INTO Tbl_Emp (ID,Name,DepID) values (@EmpID,@EmpName,@DeptID);
			SET IDENTITY_INSERT Tbl_Emp OFF;
		END;
END;
select * from VW_EmpDept;
insert into VW_EmpDept(EmpID,Employee,Department) values(7,'Name G','Dept Y');
insert into VW_EmpDept(EmpID,Employee,Department) values(7,'Name G','Dept A');
select * from VW_EmpDept;
select * from Tbl_Emp;
-----------------------------------------------------------------|
-----------------------------------------------------------------|
--Insted of Trigger in MSSQL ================================|END|



--# DDL Trigger in MSSQL ============================================|START|
--  Occurs on CREATE, ALTER and DROP statement.
-- Use : 
-- Prevent Modification in DB Schema (Schema is a collection of objects such as table,views,SP,functions...etc).
-- Display Message after DDL events.
-----------------------------------------------------------------|
CREATE TRIGGER TR_DDL_for_TblCreate
ON DATABASE --# DB which is only in use.
--ON ALL SERVER --# ALL DBs which is in current server.
FOR CREATE_TABLE
AS
BEGIN 
	PRINT('New table Created.')
END;
--drop trigger TR_DDL_for_TblCreate ON DATABASE;
-----------------------------------------------------------------|
CREATE TRIGGER TR_DDL_for_TblAlter
ON DATABASE --# DB which is only in use.
FOR ALTER_TABLE
AS
BEGIN 
	PRINT('New table Altered.')
END;
--drop trigger TR_DDL_for_TblAlter ON DATABASE;
-----------------------------------------------------------------|
CREATE TRIGGER TR_DDL_for_TblDrop
ON DATABASE --# DB which is only in use.
FOR DROP_TABLE
AS
BEGIN 
	PRINT('New table Droped.')
END;
--drop trigger TR_DDL_for_TblDrop ON DATABASE;
-----------------------------------------------------------------|

CREATE TRIGGER TR_DDL_for_Tbl_CreateAlterDrop
ON DATABASE --# DB which is only in use.
FOR CREATE_TABLE,ALTER_TABLE,DROP_TABLE
AS
BEGIN 
	PRINT('DDL Trigger Executed.')
END;
--drop trigger TR_DDL_for_Tbl_CreateAlterDrop ON DATABASE;
-----------------------------------------------------------------|

--# DDL Trigger in MSSQL ============================================|END|




--# Key Differences with Similar Functions =============================================================================

--* SCOPE_IDENTITY(): Returns the last identity value generated in the current session and scope.
--* @@IDENTITY: Returns the last identity value generated in the current session, regardless of the scope.
--* IDENT_CURRENT('table_name'): Returns the last identity value generated for a specific table, regardless of the session or scope.

--# EX.
SELECT SCOPE_IDENTITY();
SELECT @@IDENTITY;
SELECT IDENT_CURRENT('TBL_T1');

DROP TABLE IF EXISTS TBL_T1;
CREATE TABLE TBL_T1 (ID INT IDENTITY(1,1),C1 VARCHAR(5), C2 INT);
INSERT INTO TBL_T1 VALUES('A1',56)
SELECT * FROM TBL_T1

DECLARE @CurrentID INT;
SET @CurrentID=SCOPE_IDENTITY();
SELECT @CurrentID;

--#===================================================================================================================





--# Memory Optimised Table in SQL Server =============================|START|
-- 1. A Memory-Optimized Table in SQL Server is a type of table that is designed to improve performance by storing data in memory instead of on disk.
-- 2. For scenarios where speed is critical, such as high-performance transaction processing or data warehousing.
-- 3. Memory-optimized tables leverage the In-Memory OLTP feature of SQL Server, which uses a combination of memory-optimized data structures and compiled stored procedures to achieve significant performance gains.

--# Key features and characteristics of memory-optimized tables include:
 --1. In-Memory Storage: 
	--	Data is stored in memory rather than on disk, resulting in faster data access and retrieval.
 --2. Lock-Free Data Access: 
	--	Memory-optimized tables use optimistic concurrency control, allowing multiple transactions to access data simultaneously without blocking each other.
 --3. Native Compilation: 
	--	Stored procedures associated with memory-optimized tables are compiled into machine code for improved execution speed.
 --4. Durability Options: 
	--	Memory-optimized tables support both durable and non-durable durability options. Durable tables ensure that data is persisted to disk for durability, while non-durable tables offer faster performance but do not guarantee data persistence in case of a system failure.
 --5. Schema Restrictions: 
	--	Memory-optimized tables have certain restrictions on schema design, such as limitations on data types, indexes, and constraints. These restrictions are designed to optimize performance and minimize overhead.
--Ex.
-- Create a Memory-Optimized Table:
-- To create memory optimized tables, the database must have a MEMORY_OPTIMIZED_FILEGROUP that is online and has at least one container.

CREATE TABLE Orders_MemoryOptimized
(
    OrderID INT PRIMARY KEY NONCLUSTERED,
    CustomerID INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(18, 2)
)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);

-- Insert some sample data into the Memory-Optimized Table
INSERT INTO dbo.Orders_MemoryOptimized (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES (1, 101, '2024-04-20', 150.00),
       (2, 102, '2024-04-21', 220.50),
       (3, 103, '2024-04-22', 75.25);

-- Query the Memory-Optimized Table
SELECT * FROM dbo.Orders_MemoryOptimized;

--# Memory Optimised Table in SQL Server =============================|END|



--# Parallelism in SQL Server =========================================|START|
--# Parallelism in SQL Server refers to the ability of the database engine 
--  to execute multiple operations simultaneously by utilizing multiple threads or processors. 
--  This feature improves query performance by distributing the workload across available resources.

--# Max Degree of Parallelism (DOP): 
--  The degree of parallelism refers to the maximum number of processors that can be used to execute a single query or operation.
--  It can be controlled at different levels, such as the server level, database level, or query level.

--Hierarchy : Query, Database, Instance.
--Ex.
SELECT CustomerID, SUM(OrderAmount) AS TotalOrderAmount
FROM Orders
GROUP BY CustomerID
-- Complex Query, can take max time.
OPTION (MAXDOP 4)
--# Parallelism in SQL Server =========================================|END|



--# GENERATE_SERIES(START,STOP,STEP) ==================================|START|
--GENERATE_SERIES ( start , stop [ , step ] )
SELECT value FROM GENERATE_SERIES(1, 10);
SELECT value FROM GENERATE_SERIES(10, 1);
SELECT value FROM GENERATE_SERIES(1, 10, 2);
--# GENERATE_SERIES(START,STOP,STEP) ==================================|END|

--# String Functions ==================================================|START|

select CHARINDEX('7','123456789')
select CHARINDEX('c','abcdefgh')

select PATINDEX('%c%','abcdefgh')
select PATINDEX('%[2][0][0-9][0-9]-[0-9][0-9]-[0-9][0-9]%','Today is 2024-10-25')

select SUBSTRING('123456789',1,3)
select SUBSTRING('abcdefgh',1,3)

DECLARE @STR VARCHAR(MAX) = 'my name is Aditya.'
select CHARINDEX('name is ',@STR)
select CHARINDEX('.',@STR)
select CHARINDEX('name is ',@STR)+LEN('name is ')
select CHARINDEX('.',@STR)-(CHARINDEX('name is ',@STR)+LEN('name is '))
select SUBSTRING(@STR,11,7)

--DECLARE @STR VARCHAR(MAX) = 'my name is Aditya.'
select	@STR STRING
		,CHARINDEX('name is ',@STR)+LEN('name is ') Starting_INDEX
		,CHARINDEX('.',@STR)-(CHARINDEX('name is ',@STR)+LEN('name is ')) No_of_INDEX
		,SUBSTRING(
				@STR,
				CHARINDEX('name is ',@STR)+LEN('name is '),
				CHARINDEX('.',@STR)-(CHARINDEX('name is ',@STR)+LEN('name is '))
				) EXTRACTED

--DECLARE @STR VARCHAR(MAX) = 'my name is Aditya.'
select	@STR
	,CASE 
        WHEN CHARINDEX('name is ',@STR) > 0
        THEN SUBSTRING(
            @STR, 
            CHARINDEX('name is ',@STR)+LEN('name is '),
			CHARINDEX('.',@STR)-(CHARINDEX('name is ',@STR)+LEN('name is '))
			)
        ELSE NULL
    END AS [Name]


select REPLACE('Today is Monday', 'Monday', 'Sunday');

SELECT REPLICATE('AS',3);

--# TRANSLATE ( inputString, characters, translations )
select TRANSLATE('111 AbCdeFGhasdfIjK 123', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', REPLICATE(' ',52));

DECLARE @inputString VARCHAR(50) = '111 AbCdeFGhasdfIjK 123';
-- Replace A-Z and a-z with an empty string
SELECT TRANSLATE(@inputString, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', REPLICATE(' ', 52))
SELECT REPLACE(TRANSLATE(@inputString, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', REPLICATE(' ', 52)),' ','')




--# ParseName : ❖ PARSENAME('object_name', object_piece) --numbering works from right to left 
declare @STR varchar(max) = 'ASDF.123456.A1'; -- Splited by '.' Symbol
select
ParseName(@STR,4) Part_4,--Returns NULL
ParseName(@STR,3) Part_3,
ParseName(@STR,2) Part_2,
ParseName(@STR,1) Part_1,
ParseName(@STR,0) Part_0;--Returns NULL


--# String_Split & String_Agg ==============================================================|START|
DECLARE @string_value VARCHAR(MAX) ;
SET @string_value='Monroy,Montanez,Marolahakis';
SELECT * FROM  STRING_SPLIT (@string_value, ',');
--SELECT * FROM  STRING_SPLIT (@string_value, ',',1);
--------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMP_TBL1;
CREATE TABLE #TEMP_TBL1(Groups VARCHAR(10), Employees VARCHAR(MAX));
INSERT INTO #TEMP_TBL1 VALUES ('A','AEmp1,AEmp2,AEmp3'),('B','BEmp1,BEmp2,BEmp3'),('C','CEmp3,CEmp2,CEmp1');
select * from #TEMP_TBL1;
--------------------------------------------------------------------------------------------
drop table if exists #temp_tbl_Splited;
select Groups,v.value as Emp into #temp_tbl_Splited from #TEMP_TBL1 
cross apply STRING_SPLIT(Employees,',') v;
select * from #temp_tbl_Splited;
--------------------------------------------------------------------------------------------
select Groups,String_Agg(Emp,',') Emps from #temp_tbl_Splited group by Groups;
select Groups,String_Agg(Emp,',') WITHIN GROUP (ORDER BY Emp) Emps from #temp_tbl_Splited group by Groups;
--------------------------------------------------------------------------------------------
--# String_Split & String_Agg ==============================================================|END|





--# like Operator ========================================================================///
--# Start with a : 'a%'
--# End with a : '%a'
--# a in value : '%a%'
--# Start with 2 char a : '_a%'
--# Start with _a : '[_]a%'

select case when 'asdfgh' like 'a%' then 1 else 0 end;

select 
iif('dasdf' like '%_a_%',1,0)
,case when '_1_' like '%_1_%' then 1 else 0 end
,case when '_-1_' like '%_1_%' then 1 else 0 end;

SELECT 
    IIF('dasdf' LIKE '%[_]a[_]%', 1, 0) AS Match1,
    CASE WHEN '_1_' LIKE '%[_]1[_]%' THEN 1 ELSE 0 END AS Match2,
    CASE WHEN '_-1_' LIKE '%[_]1[_]%' THEN 1 ELSE 0 END AS Match3;

--# String Functions ==================================================|END|


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@| Functions |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--|START|
use Local_DB;
select top 50 * FROM sys.databases;
select top 50 * FROM sys.tables;
SELECT CURRENT_TIMESTAMP;
SELECT CURRENT_USER;
SELECT IIF(500<1000 AND 1=1, 'YES', 'NO');
SELECT CASE WHEN 500<1000 AND 1=1 THEN 'YES' ELSE 'NO' END;

SELECT @@VERSION;
--# sa : SA@123
SELECT SERVERPROPERTY('Edition');
--# Express Edition (64-bit)
--# Developer Edition (64-bit)

--# Sql server agent is not available in Express Edition.
-- So you need to download developer edition.


--# Variables in SQL Server ===========================|START|
--# Local Variable. (Accessible for one Session only.)
DECLARE @VAR1 INT = 10;
--# Global Variable. (Accessible for all Session.)
DECLARE @@VAR1 INT = 10;
--# Variables in SQL Server ===========================|END|

--# Temporary tables in SQL Server ===========================|START|
--# Local temporary table. (Accessible for one Session only.)
select * into #T1 from Table_1;
--# Global temporary table. (Accessible for all Session.)
select * into ##T1 from Table_1; 
--# Temporary tables in SQL Server ===========================|END|


Select Char(64);
Select Char(65);
Select Char(97);
select value from generate_series(1,26)
select char(64+value) from generate_series(1,26) --# [A-Z]
select char(96+value) from generate_series(1,26) --# [a-z]



--==# Learn New #==--
select 'Aditya''s Android'

select cast(GETDATE() as date)
select convert(date,GETDATE())

SELECT '28-06-2010',CONVERT(DATE,'28-06-2010', 103)

CREATE TABLE #SPL_SA_VideosTable (
    VID INT IDENTITY(1,1) PRIMARY KEY,
	Title VARCHAR(MAX),
    YoutubeEmbedCode VARCHAR(MAX)
);

SELECT EOMONTH(GETDATE()) as Last_Date_of_Current_Month
SELECT DAY(GETDATE()) 'DAY', MONTH(GETDATE()) 'MONTH', YEAR(GETDATE()) 'YEAR';
SELECT (GETDATE())


Select DATEADD(mm, DATEDIFF(mm, 0, dateadd(d,-1,GETDATE())), 0) 
Select DATEADD(mm, DATEDIFF(mm, 0, dateadd(d,-1,GETDATE())), 0)   -- @1_FROMDATE
Select dateadd(d,-1,GETDATE()) -- @1_TODATE

SELECT DATEDIFF(year,'1998/10/25', '2022/7/11') AS DateDiff;
SELECT DATEDIFF(d,-1,GETDATE()) 
SELECT DATEDIFF(mm, 0, dateadd(d,-1,GETDATE()))
SELECT DATEADD(mm, DATEDIFF(mm, 0, dateadd(d,-1,GETDATE())), 0) 

DECLARE @CurrentDate DATETIME = GETDATE()
DECLARE @BirthDate DATETIME = '1998-10-25'
	 
SELECT @CurrentDate 
SELECT CAST (@BirthDate AS Date ) AS BirthDateOnly
SELECT DATEADD (YEAR,0,@BirthDate) AS BirthDate 
SELECT DATEADD (YEAR,24,@BirthDate) AS After24Years 

SELECT DATEDIFF (YEAR,@CurrentDate,@BirthDate)
SELECT DATEDIFF (YEAR,@CurrentDate,@BirthDate)


select DATEPART ( year , '2024-12-01' );
select CONVERT(DATE, '20241201', 101);
select CONVERT(DATE, '01-12-2024', 103);

--# Style Formats
SELECT CONVERT(VARCHAR,GETDATE(),1)		--# mm/dd/yy
SELECT CONVERT(VARCHAR,GETDATE(),101)	--# mm/dd/yyyy
SELECT CONVERT(VARCHAR,GETDATE(),2)		--# yy.mm.dd
SELECT CONVERT(VARCHAR,GETDATE(),102)	--# yyyy.mm.dd
SELECT CONVERT(VARCHAR,GETDATE(),3)		--# dd/mm/yy
SELECT CONVERT(VARCHAR,GETDATE(),103)	--# dd/mm/yyyy
SELECT CONVERT(VARCHAR,GETDATE(),113)	--# dd mmm yyyy 00:00:00:000

SELECT DATEPART(day,GETDATE())
SELECT DATEPART(month,GETDATE())
SELECT DATEPART(year,GETDATE())
--datepart	Abbreviations
--year	yy, yyyy
--quarter	qq, q
--month	mm, m
--dayofyear	dy, y
--day	dd, d
--week	wk, ww
--weekday	dw
--hour	hh
--minute	mi, n
--second	ss, s
--millisecond	ms
--microsecond	mcs
--nanosecond	ns


select datepart(dw,getdate()) --2
select datename(dw,getdate()) --Thursday

SELECT DATENAME(weekday, getdate())
--year, yyyy, yy = Year
--quarter, qq, q = Quarter
--month, mm, m = month
--dayofyear = Day of the year
--day, dy, y = Day
--week, ww, wk = Week
--weekday, dw, w = Weekday
--hour, hh = hour
--minute, mi, n = Minute
--second, ss, s = Second
--millisecond, ms = Millisecond


select ROW_NUMBER() over (Partition by LOS_APP_ID order by DISBURSED_AMT desc) r


select ISNULL(Null,'');

SELECT NULLIF(0,0);
SELECT NULLIF(25,0);
--# SQL Server, which returns NULL if two expressions are equal, or the first expression if they are not

SELECT ISNUMERIC(4567);
SELECT IIF(ISNUMERIC(4567)=1, 4567,0);


select CONCAT('ASDF','123');
select 'ASDF'+'123';

SELECT DATEPART(WEEKDAY, GETDATE())

--SELECT   [ INSTALLMENT-AMT]
--		,(SELECT TOP 1 * FROM STRING_SPLIT(CAST(CSA.[ INSTALLMENT-AMT] AS varchar),'/')) AS Last_Payment_Amount 
--FROM Customer_Scrub_Account CSA
--where CSA.[LOS-APP-ID] = 6549935 


select ROUND(20.6543210, 0)
select ROUND(20.6543210, 3)

select CONVERT(int,20.54321)

select Dateadd(DAY,-1,GETDATE())
select Dateadd(MONTH,-1,GETDATE())
select Dateadd(YEAR,-1,GETDATE())


--# Format() ===========================================|
SELECT FORMAT(GETDATE(), N'yyyy-mm-dd hh:mm:ss')

DECLARE @Date DATETIME = '2016-09-05 00:01:02.333'
SELECT FORMAT(@Date, N'dddd, MMMM dd, yyyy hh:mm:ss tt')
Monday, September 05, 2016 12:01:02 AM

--Argument Output
--yyyy		2016
--yy		16
--MMMM		September
--MM		09
--M			9
--dddd		Monday
--ddd		Mon
--dd		05
--d			5
--HH		00
--H			0
--hh		12
--h			12
--mm		01
--m			1
--ss		02
--s			2
--tt		AM
--t			A
--fff		333
--ff		33
--f			3

SELECT FORMAT(GETDATE(), 'dddd');

DECLARE @d DATETIME = '12/01/2018';  
SELECT FORMAT (@d, 'd', 'en-US') AS 'US English Result';

--# Format() ===========================================|






--# Window Functions in MSSQL =======================================================================================|START|
--Here is a list of commonly used window functions in MSSQL:

--1. ROW_NUMBER(): Assigns a unique incremental integer value to each row within a partition of a result set.
--2. RANK(): Assigns a unique rank to each distinct row within a partition of a result set, with gaps in the ranking for duplicate values.
--3. DENSE_RANK(): Assigns a unique rank to each distinct row within a partition of a result set, without any gaps in the ranking for duplicate values.
--4. NTILE(n): Divides the result set into a specified number of roughly equal groups or "tiles".
--5. LEAD(): Accesses data from subsequent rows in the same result set without the use of a self-join.
--6. LAG(): Accesses data from previous rows in the same result set without the use of a self-join.
--7. FIRST_VALUE(): Returns the first value in an ordered set of values.
--8. LAST_VALUE(): Returns the last value in an ordered set of values.
--9. CUME_DIST(): Returns the cumulative distribution of a value within a group of values.
--10. PERCENT_RANK(): Calculates the relative rank of a value within a group of values.
--11. PERCENTILE_CONT(): Calculates a percentile value.
--12. PERCENTILE_DISC(): Calculates a percentile value based on a discrete distribution.
--13. LAG() IGNORE NULLS / LEAD() IGNORE NULLS: Similar to LAG() and LEAD(), but ignores null values.
--14. SUM(), AVG(), COUNT(), MIN(), MAX() with OVER(): Aggregates data over a window defined by the OVER() clause.

--These functions are commonly used for analytical and reporting purposes where you need to perform calculations on a subset of rows within a result set.
--==================================================================================================////////
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2)
);
INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary)
VALUES
    (1, 'John', 'Doe', 50000.00),
    (2, 'Jane', 'Smith', 60000.00),
    (3, 'Alice', 'Johnson', 55000.00),
    (4, 'Bob', 'Williams', 62000.00),
    (5, 'Eve', 'Brown', 58000.00),
    (6, 'Evene', 'Smith', 50000.00),
    (7, 'Alice', 'Doe', 45000.00);
SELECT * FROM Employees;
----------------------------------------------------------
SELECT *, ROW_NUMBER() OVER (ORDER BY LastName) AS RowNum FROM Employees;
----------------------------------------------------------
SELECT *, RANK() OVER (ORDER BY Salary DESC) AS EmpRank FROM Employees;
----------------------------------------------------------
SELECT *, DENSE_RANK() OVER (ORDER BY Salary DESC) AS EmpDenseRank FROM Employees;
----------------------------------------------------------
SELECT *, NTILE(3) OVER (ORDER BY Salary) AS Quartile FROM Employees;
----------------------------------------------------------
SELECT *, LEAD(Salary, 1) OVER (ORDER BY Salary DESC) AS NextSalary FROM Employees;
----------------------------------------------------------
SELECT *, LAG(Salary, 1) OVER (ORDER BY Salary DESC) AS PrevSalary FROM Employees;
----------------------------------------------------------
SELECT *, FIRST_VALUE(Salary) OVER (ORDER BY Salary) AS FirstSalary FROM Employees;
----------------------------------------------------------
SELECT *, LAST_VALUE(Salary) OVER (ORDER BY Salary) AS LastSalary FROM Employees;
----------------------------------------------------------
SELECT *, CUME_DIST() OVER (ORDER BY Salary) AS CumulativeDistribution FROM Employees;
----------------------------------------------------------
SELECT *, PERCENT_RANK() OVER (ORDER BY Salary) AS PercentRank FROM Employees;
----------------------------------------------------------
SELECT *, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary) OVER() AS MedianSalary FROM Employees;
----------------------------------------------------------
SELECT *, PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Salary) OVER() AS ThirdQuartileSalary FROM Employees;
----------------------------------------------------------
--==================================================================================================////////
--# Window Functions in MSSQL =======================================================================================|END|




--# Lead & Lag , Row_Number,Rank,Dense_rank function ==============================================================#[START] 
--# https://www.sqlshack.com/sql-lag-function-overview-and-examples/
--Syntax of Lag function
--LAG (scalar_expression [,offset] [,default]) OVER ( [partition_by_clause] order_by_clause ) lag
--LEAD (scalar_expression [,offset] [,default]) OVER ( [partition_by_clause] order_by_clause ) lead
--------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #Employee;
DROP TABLE IF EXISTS #Employee2;
CREATE TABLE #Employee (EmpCode INT,EmpName VARCHAR(10),JoiningDate DATE);

INSERT INTO #Employee VALUES (1, 'Rajendra', '1-Sep-2018')
							,(2, 'Manoj'	 , '1-Oct-2018')
							,(3, 'Sonu'	 , '10-Mar-2018')
							,(4, 'Kashish' , '25-Oct-2019')
							,(5, 'Tim'	 , '1-Dec-2019')
							,(6, 'Akshita' , '1-Nov-2019')

SELECT *,YEAR(JoiningDate)[Year] INTO #Employee2 FROM #Employee;

select *
,LAG(EmpCode, 1, 0) OVER(ORDER BY [Year] ASC) AS [PastSales]
,LEAD(EmpCode, 1, 0) OVER(ORDER BY [Year] ASC) AS [NextSales]
from #Employee2;

select *
,SUM(EmpCode) OVER(PARTITION BY [Year]) AS [TotalSales]
,MIN(EmpCode) OVER(PARTITION BY [Year]) AS [MinSales]
,MAX(EmpCode) OVER(PARTITION BY [Year]) AS [MaxalSales]
from #Employee2;

select *
,ROW_NUMBER () OVER(ORDER BY [Year] ASC) AS RN
,RANK() OVER(ORDER BY [Year] ASC) AS R
,DENSE_RANK() OVER(ORDER BY [Year] ASC) AS DR
from #Employee2

select *
,ROW_NUMBER () OVER(ORDER BY [Year] ASC) AS RN
,ROW_NUMBER () OVER(PARTITION BY [Year] ORDER BY [Year] ASC) AS RN2
,RANK() OVER(ORDER BY [Year] ASC) AS R
,DENSE_RANK() OVER(ORDER BY [Year] ASC) AS DR
from #Employee2

select *
,ROW_NUMBER () OVER(PARTITION BY [Year] ORDER BY [Year] ASC) AS RN
,RANK() OVER(PARTITION BY [Year] ORDER BY [Year] ASC) AS R
,DENSE_RANK() OVER(PARTITION BY [Year] ORDER BY [Year] ASC) AS DR
from #Employee2

--# Lead & Lag , Row_Number,Rank,Dense_rank function ==============================================================#[END] 




--# To Handle NULL value : ======================================|START| 
--# COALESCE accept No. of values but ISNULL accept only two values.
-----------------------------------------------------------------------|

SELECT COALESCE(NULL,10,0,50,NULL,30)

SELECT COALESCE(NULL,NULL,NULL,NULL) --# At least one of the arguments to COALESCE must be an expression that is not the NULL constant.
--# Always returns first not NULL value

--# in ISNULL & NULLIF function we can pass only two veriables.

DECLARE @V1 INT = NULL;
SELECT ISNULL(@V1,0)

DECLARE @V2 INT = 0;
SELECT NULLIF(@V2, 0)
--# To Handle NULL value : ======================================|END| 


--=============================================================|START|
--# ALL/ANY 
CREATE TABLE #t1 (C1 INT, C2 INT);
INSERT INTO #T1 VALUES (1,10),(2,20),(3,30),(4,40),(5,50);
SELECT * FROM #T1;
SELECT * FROM #T1 WHERE C1 < ANY (SELECT C1 FROM #T1 WHERE C1 IN (3,4));
SELECT * FROM #T1 WHERE C1 < ALL (SELECT C1 FROM #T1 WHERE C1 IN (3,4));
--=============================================================|END|


--============================================================================================================ [ COLLATE / Collation ] |START|
--# In SQL Server, COLLATE is a clause used to specify the collation for a specific operation. 
--  Collation refers to the set of rules that determines how data is sorted, compared, and indexed in a database.

--# The COLLATE clause can be used in various SQL operations such as column definition, variable declaration, and comparison operations. 
--  It allows you to override the default collation of the database, table, or column for a specific operation.

--# The COLLATE clause can be applied only for the char, varchar, text, nchar, nvarchar, and ntext data types.
----------------------------------------------------------------------------------------------------------------

--# To create a user database which has a case sensitive collation as follows:
CREATE DATABASE [CaseSensitiveDB]
COLLATE Latin1_General_CS_AS_KS
GO;
-------------------------------------------------------------
SELECT T1.C2,T2.C2
FROM T1
JOIN T2 ON T2.C1 = T1.C1 COLLATE Latin1_General_CI_AS;
--OR--
SELECT T1.C2,T2.C2
FROM T1
JOIN T2 ON T2.C1 = T1.C1 COLLATE database_default;
-- Error : Cannot resolve the collation conflict between "Latin1_General_CI_AI" and "SQL_Latin1_General_CP1_CI_AS" in the equal to operation.
-------------------------------------------------------------
--# For example, you can use the COLLATE clause in a SELECT statement to specify the collation to be used for sorting:
SELECT column1, column2
FROM table_name
ORDER BY column1 COLLATE Latin1_General_CI_AS;
-------------------------------------------------------------
--# You can also use the COLLATE clause in column definitions to set the collation for a column:
CREATE TABLE table_name (
    column1 VARCHAR(50) COLLATE Latin1_General_CI_AS,
    column2 VARCHAR(50)
);
------------------------------------------------------------------------------------------------------------------------------
-- # Latin1_General_CI_AS is a specific collation. CI stands for case-insensitive, and AS stands for accent-sensitive.
--   EX. 'A' == 'a' & 'é' <> 'e'.
-- # Latin1_General_CS_AS is a specific collation. CS stands for case-sensitive, and AS stands for accent-sensitive.
--   EX. 'A' <> 'a' & 'é' <> 'e'.
------------------------------------------------------------------------------------------------------------------------------
--# To get several Collation Types:
SELECT * FROM sys.fn_helpcollations();
--# Instance level Collation:
SELECT SERVERPROPERTY('Collation') as ServerCollation; --# SQL_Latin1_General_CP1_CI_AS
--# DataBase level Collation:
SELECT database_id,name,collation_name FROM sys.databases;
--# Table level Collection:
EXEC SP_help 'INFORMATION_SCHEMA.TABLES';
--# Column level Collection:
SELECT TABLE_NAME,COLUMN_NAME,DATA_TYPE,COLLATION_NAME FROM INFORMATION_SCHEMA.COLUMNS;
--============================================================================================================ [ COLLATE / Collation ] |END|



SELECT 1 C1, 2 C2, 3 C3;

SELECT 1 C1, 2 C2
UNION ALL
SELECT 10 C1, 20 C2
UNION ALL
SELECT 100 C1, 200 C2;





--======================================================================================================#



--======================================================================|START|
------------------------------------------------------------------------|
-- Create Students Table
DROP TABLE IF EXISTS #Students;
CREATE TABLE #Students (student_id INT,student_name VARCHAR(50));
INSERT INTO #Students (student_id, student_name) VALUES (1,'John Doe'),(2,'Jane Smith'),(3,'Bob Johnson');
------------------------------------------------------------------------|
-- Create Books Table
DROP TABLE IF EXISTS #Books;
CREATE TABLE #Books (book_id INT,book_name VARCHAR(100));
INSERT INTO #Books (book_id, book_name) VALUES
    (1, 'Book 1'),
    (2, 'Book 2'),
    (3, 'Book 3'),
    (4, 'Book 4'),
    (5, 'Book 5'),
    (6, 'Book 6'),
    (7, 'Book 7'),
    (8, 'Book 8');
------------------------------------------------------------------------|

--------------------------------------------------------|
DROP TABLE IF EXISTS #SA;
CREATE TABLE #SA (student_id INT,student_name VARCHAR(50),book_id INT,book_name VARCHAR(100));
--------------------------------------------------------|

Declare @BookID INT = 1
Declare @R INT = 1
Declare @MAX_r INT = (select COUNT(1) from #Students)
Declare @Allocate_No INT = (SELECT (SELECT COUNT(1) FROM #Books)/(SELECT COUNT(1) FROM #Students)+1)

WHILE @R <= @MAX_r
	BEGIN
		--======================================================|START|
		INSERT INTO #SA
		SELECT S.student_id,S.student_name,B.book_id,B.book_name
		FROM #Students S
		cross join #Books B
		WHERE S.student_id=@R
		and B.book_id between @BookID and @BookID+(@Allocate_No-1)
		--======================================================|END|
		SET @R=@R+1
		SET @BookID=@BookID+@Allocate_No
	END
SELECT * FROM #SA;
--======================================================================|END|


select '50,20,40,10,60',
CHARINDEX(',','50,20,40,10,60'),
left('50,20,40,10,60',3-1),
left('50,20,40,10,60',CHARINDEX(',','50,20,40,10,60')-1);

--======================================================================|START|
DROP TABLE IF EXISTS #T1;
CREATE TABLE #T1 (C1 VARCHAR(MAX));
INSERT INTO #T1 VALUES('5,2,4,1,6')
INSERT INTO #T1 VALUES('50,20,40,10,60')
INSERT INTO #T1 VALUES(',,,,,')
SELECT 
    C1,
    CASE WHEN LEFT(C1, CHARINDEX(',', C1 + ',') - 1)='' THEN 0 ELSE LEFT(C1, CHARINDEX(',', C1 + ',') - 1) END AS FIRSTVALUE
FROM #T1;
--======================================================================|END|



--======================================================================|start|
DROP TABLE IF EXISTS #t1;
create table #t1 (c1 varchar(3),c2 varchar(3));
insert into #t1 values ('A1','B1'),('A1','B2'),('A1','B3'),('A1','B4')
insert into #t1 values ('A2','B1'),('A2','B2')
select * from #t1;
--column1	column2
--A1	B1
--A1	B2
--A1	B3
--A1	B4
--A2	B1
--A2	B2


SELECT
    c1,
    STRING_AGG(c2, ',') AS Students
FROM #t1
GROUP BY c1;


WITH NumberedRows AS (
    SELECT
        c1,
        c2,
        ROW_NUMBER() OVER (PARTITION BY c1 ORDER BY c2) AS rn
    FROM #t1
)
SELECT
    c1,
    MAX(CASE WHEN rn = 1 THEN c2 END) AS s1,
    MAX(CASE WHEN rn = 2 THEN c2 END) AS s2,
    MAX(CASE WHEN rn = 3 THEN c2 END) AS s3,
    MAX(CASE WHEN rn = 4 THEN c2 END) AS s4
FROM NumberedRows
GROUP BY c1;

--column1	s1	s2	s3	s4
--A1	B1	B2	B3	B4
--A2	B1	B2	null	null
--======================================================================|END|





select SIGN(5)		--# 1
select SIGN(0)		--# 0
select SIGN(-5)		--# -1

select FLOOR (7.9)	--# 7
select CEILING(3.1) --# 4

--# To generate a random float value between 0 (inclusive) and 1 (exclusive).
SELECT RAND() AS RandomNumber;

--==========================|RANDOM|START|
DECLARE @RandomNumber INT
SET @RandomNumber = CEILING(RAND() * 10);
SELECT @RandomNumber AS RandomNumber;
--=====================================|
SELECT CEILING(RAND() * 10) AS Random;
SELECT CAST(RAND() * 10 AS INT) AS RandomInteger;
--==========================|RANDOM|END|

--# Rndom from 10 to 30.
SELECT CAST(RAND() * (30 - 10 + 1) + 10 AS INT) AS RandomNumber; 

SELECT CAST(RAND() * 21 AS INT)+10
SELECT 21+10


--=======================================================|
--CREATE TABLE Table_1 (C1 INT PRIMARY KEY, C2 VARCHAR(1))
--INSERT INTO Table_1 values (1,'A');
--INSERT INTO Table_1 values (2,'B');
--INSERT INTO Table_1 values (3,'C');
--INSERT INTO Table_1 values (4,'D');
--INSERT INTO Table_1 values (5,'E');
--INSERT INTO Table_1 values (6,'F');
--INSERT INTO Table_1 values (7,'G');
--INSERT INTO Table_1 values (8,'H');
--INSERT INTO Table_1 values (9,'I');
--INSERT INTO Table_1 values (10,'J');
--INSERT INTO Table_1 values (11,'K');
--INSERT INTO Table_1 values (12,'L');
--=======================================================|



--=======================================================|Self join|START|
DROP TABLE IF EXISTS #T1;
CREATE TABLE #T1(ID INT PRIMARY KEY,EMP_NAME VARCHAR(10),ReportingID INT);
INSERT INTO #T1
VALUES (1,'A',0),(2,'AA',0),(3,'B',1),(4,'BB',1),(5,'C',2),(6,'D',5);
SELECT * FROM #T1;
SELECT	A.ID M_ID,A.EMP_NAME M_Name,A.ReportingID M_ReportingID
		,B.ID,B.EMP_NAME,B.ReportingID
FROM #T1 A, #T1 B
WHERE A.ID=B.ReportingID
--=======================================================|Self join|END|



select QUOTENAME('Aditya');
SELECT * from sys.dm_cdc_log_scan_sessions where empty_scan_count <> 0


--# GUID (Globally Unique Identifier) =========================================|START|
-- A GUID is a 16 BYTE Binary data type That is Globally Unique.
-- It creates unique across Tables, Databases and Servers.
-------------------------------------------------------------------------------
SELECT NEWID();
CREATE TABLE TBL_TEMP_IDENTITY_Holder(ID INT IDENTITY(1,1) PRIMARY KEY, Names VARCHAR(50));
CREATE TABLE TBL_TEMP_GUID_Holder(ID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(), Names VARCHAR(50));
--# GUID (Globally Unique Identifier) =========================================|END|




--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@| Functions |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--|END|



--# SEQUENCE in MSSQL ==========================================================================================///
CREATE SEQUENCE sequence_name
    START WITH start_value
    INCREMENT BY increment_value
    MINVALUE minimum_value
    MAXVALUE maximum_value
    CYCLE | NO CYCLE;

--sequence_name: Name of the sequence.
--START WITH: The starting value of the sequence.
--INCREMENT BY: Specifies how much to increment each new value by (can be positive or negative).
--MINVALUE/MAXVALUE: Specifies the range for the values.
--CYCLE | NO CYCLE: If CYCLE is specified, the sequence will start over at the MINVALUE after reaching MAXVALUE. If NO CYCLE is specified, it will raise an error when the limit is reached.

DROP SEQUENCE IF EXISTS cyclic_seq;
CREATE SEQUENCE cyclic_seq
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 10
	NO CYCLE;

select next value for cyclic_seq

ALTER SEQUENCE cyclic_seq RESTART;
ALTER SEQUENCE cyclic_seq RESTART WITH 9;


INSERT INTO Employees (EmpID, EmpName)
VALUES (NEXT VALUE FOR employee_seq, 'John Doe');

--# The sequence object 'cyclic_seq' has reached its minimum or maximum value. Restart the sequence object to allow new values to be generated.

--# SEQUENCE in MSSQL ==========================================================================================///










--#============================================================================
--# Use Primary key constraint without using any constraint
CREATE TABLE Employees (
    EmpID INT NOT NULL,
    EmpName VARCHAR(50),
    -- Other columns
);
------------------------------------------------------------------------------
-- Create a unique index to ensure unique values
CREATE UNIQUE INDEX idx_empid ON Employees(EmpID);
--#============================================================================
CREATE PROCEDURE InsertEmployee
    @EmpID INT,
    @EmpName VARCHAR(50)
AS
BEGIN
    -- Check for NULL
    IF @EmpID IS NULL
    BEGIN
        RAISERROR ('EmpID cannot be NULL', 16, 1);
        RETURN;
    END

    -- Check for uniqueness
    IF EXISTS (SELECT 1 FROM Employees WHERE EmpID = @EmpID)
    BEGIN
        RAISERROR ('EmpID must be unique', 16, 1);
        RETURN;
    END

    -- Insert if all validations pass
    INSERT INTO Employees (EmpID, EmpName)
    VALUES (@EmpID, @EmpName);
END;
--#============================================================================
CREATE TRIGGER trg_InsertEmployee
ON Employees
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @EmpID INT, @EmpName VARCHAR(50)

    -- Get the inserted values from the 'INSERTED' table
    SELECT @EmpID = EmpID, @EmpName = EmpName FROM INSERTED

    -- Check for NULL
    IF @EmpID IS NULL
    BEGIN
        RAISERROR ('EmpID cannot be NULL', 16, 1);
        RETURN;
    END

    -- Check for uniqueness
    IF EXISTS (SELECT 1 FROM Employees WHERE EmpID = @EmpID)
    BEGIN
        RAISERROR ('EmpID must be unique', 16, 1);
        RETURN;
    END

    -- Insert the row if all validations pass
    INSERT INTO Employees (EmpID, EmpName)
    SELECT EmpID, EmpName FROM INSERTED;
END;
--#============================================================================


















--# Simple way to create a SQL Server Job Using T-SQL / Schedule SP ###############################################|START|
-- Steps This is a stored procedure named sp_add_job_quick that calls 4 msdb stored procedures:
-- 1. [sp_add_job] creates a new job
-- 2. [sp_add_jobstep] adds a new step in the job
-- 3. [sp_add_jobschedule] schedules a job for a specific date and time
-- 4. [sp_add_jobserver] adds the job to a specific server
-------------------------------------------------------------------------------------------|
--# S1 The sp_add_job is a procedure in the msdb database that creates a job.
USE msdb;
EXEC dbo.sp_add_job
    @job_name = @job;
-------------------------------------------------------------------------------------------|
--# S2 The sp_add_jobstep creates a job step in the job created. In this tip, the step name is process_step and the action is a TSQL command.
EXEC sp_add_jobstep
    @job_name = @job,
    @step_name = N'process step',
    @subsystem = N'TSQL',
    @command = @mycommand;
-------------------------------------------------------------------------------------------|
--# S3 The following section let's you create the schedule for the job in T-SQL.
--  The schedule name is MySchedule. 
--  The frequency type is once (1). If you need to run the job daily the frequency type is 4 and weekly 8.
--  The active start time is 16:00:00 (4PM). The start date uses the date assigned to the startdate variable '20130823'.
exec sp_add_jobschedule @job_name = @job,
@name = 'MySchedule',
@freq_type=1,
@active_start_date = @startdate,
@active_start_time = @starttime;
-------------------------------------------------------------------------------------------|
--# S4 Add the job to the SQL Server 
EXEC dbo.sp_add_jobserver
    @job_name =  @job,
    @server_name = @servername;
-------------------------------------------------------------------------------------------|
--# Simple way to create a SQL Server Job Using T-SQL / Schedule SP =======================|END|


--# Simple way to delete a SQL Server Job Using T-SQL / Scheduled SP =======================|START|
USE msdb ;  
GO
EXEC sp_delete_job @job_name = N'job_name';
GO
--# Simple way to delete a SQL Server Job Using T-SQL / Scheduled SP =======================|END|


--# Simple way to view a SQL Server Job Using T-SQL / Scheduled SP =======================|START|
-- lists all aspects of the information for the job.  
USE msdb;
EXEC sp_help_job;
SELECT * FROM msdb.dbo.sysjobs_view;
SELECT * FROM msdb.dbo.sysjobs;
------------------------------------------------------------------------------------------|
-- lists all aspects of the information for the job NightlyBackups.
EXEC dbo.sp_help_job  
    @job_name = N'NightlyBackups',  
    @job_aspect = N'ALL' ;  
GO  
------------------------------------------------------------------------------------------|
-- lists all job information for the NightlyBackups job.  
EXEC dbo.sp_help_jobhistory   
    @job_name = N'NightlyBackups' ;  
GO  
------------------------------------------------------------------------------------------|
--# Simple way to view a SQL Server Job Using T-SQL / Scheduled SP ###############################################|END|









SELECT * FROM sys.objects



--# Retrieve Basic Server Information
SELECT @@VERSION
--Returns the version of MS SQL Server running on the instance.
SELECT @@SERVERNAME
--Returns the name of the MS SQL Server instance.
SELECT @@SERVICENAME
--Returns the name of the Windows service MS SQL Server is running as.
SELECT serverproperty('ComputerNamePhysicalNetBIOS');
--Returns the physical name of the machine where SQL Server is running. Useful to identify the node in a failover cluster.
SELECT * FROM fn_virtualservernodes();
--In a failover cluster returns every node where SQL Server can run on. It returns nothing if not a cluster.





DECLARE @Date date = '2016-08-03'
--SET @Date = NULL -- Note that the '=' here is an assignment operator!
SELECT CASE  WHEN @Date = NULL THEN 1
			 WHEN @Date <> NULL THEN 2
			 WHEN @Date > NULL THEN 3
			 WHEN @Date < NULL THEN 4
			 WHEN @Date IS NULL THEN 5
			 WHEN @Date IS NOT NULL THEN 6
		END;





--###############################################################################################################################||| DBA |||

--# SQL Server provides four system databases :
-- 1. Master: stores system-level information of the SQL server instance.
-- 2. Model: served as a template for creating other databases.
-- 3. Msdb: used by SQL Server Agent for jobs & alerts.
-- 4. Tempdb: used to store temporary objects such as temporary tables, temporary stored procedures, and cursors.

--# Recovery models in SQL Server are database properties.
-- https://www.sqlshack.com/understanding-database-recovery-models/
-- That control how transactions are logged, backed up, and restored.
SELECT database_id, name, recovery_model, recovery_model_desc FROM sys.databases
-- There are three types of recovery models in SQL Server:
-- 1. Simple: 
--				This model deletes transaction logs at every checkpoint,
--				resulting in small transaction log files 
--				and no point-in-time recovery.
-- 2. Full: 
--				This model logs all transactions and retains them until a backup is performed, 
--				allowing for point-in-time recovery 
--				and complete database restoration.
-- 3. Bulk-Logged: 
--				This model is similar to Full,
--				but minimizes log space usage for bulk operations,
--				such as bulk insert, index creation, or select into.


--# DataBase Backup & Restore ##############################################################|START|

--# DataBase Backup ==============================================|START|
-- Types
-- * Full.
-- * Differential.
-- * Transaction Log.
-- * Tail Log.
-- * File and FileGroup.
-- * Partial.
-- * Split.
-- * Copy Only.
-- * Mirror.
-- * Compression.
------------------------------------------------------------------|
-- Ways to Backup
-- * T-SQL commands.
-- * SQL Server Management Studio (GUI).
-- * Creating maintanance Plan/Job.
-- * Using third party backup tools.
------------------------------------------------------------------|
-- Following are the most common types of Backup in MSSQL.
-- * Full.
-- * Differential.
-- * Transaction Log.
------------------------------------------------------------------|
-- Having most common Backup Policy.
-- * Weekly Full Backup.
-- * Daily Differential Backup.
-- * Every 4hrs or 1hr or 30mins Transaction-Log Backup.
------------------------------------------------------------------|
------------------------------------------------------------------|
SELECT * FROM sys.databases;
------------------------------------------------------------------|
USE Local_DB;  
ALTER DATABASE Local_DB 
SET RECOVERY FULL;
------------------------------------------------------------------|
ALTER DATABASE MYDB SET OFFLINE;
ALTER DATABASE MYDB SET ONLINE;
------------------------------------------------------------------|
------------------------------------------------------------------|
--# DataBase Backup ==============================================|END|

--# Full Backup ==============================================|START|
-- This is a complete copy. Which stores all the objects of the database.
-- Contains Tables, Procedures, functions, views, indexces etc.
-- It is a foundation of any kind of backup.
----------------------------------------------------------------------|
BACKUP DATABASE Local_DB
TO DISK = 'D:\DBA\Learn\SSMS\Local_DB_Full_1.bkp'
----------------------------------------------------------------------|
BACKUP DATABASE Local_DB
TO DISK = 'D:\DBA\Learn\SSMS\Local_DB_Full.bkp'
WITH INIT
,NAME = 'Local_DB FullBkp'
,STATS = 10;
----------------------------------------------------------------------|
--# INIT (OverWrite, less space) and NOINIT (append, more space) options.
-- With init : in same backup file it will remove all old backups and keeps only latest one.
-- With noinit : in same backup file it will append latest backup in backup file. (Defolt Setting)
----------------------------------------------------------------------|
--# Full Backup ==============================================|END|


--# Differential Backup ==============================================|START|
-- It contains all changes that have been made since the last full backup.
----------------------------------------------------------------------|
--		|<--------Full_Backup------>|
--		|							|<-------Diff_BKP_1---->|
--		|							|<-----------------Diff_BKP_2------------------>|
--		|							|						|						|
-- Starting Point				Full_Backup				Diff_BKP_1				Diff_BKP_2
--		|							6AM						9AM						11AM

-- If Full Backup is taken at 6AM, Differential Backup 1 is taken at 9AM and Differential Backup 2 is taken at 11AM.
-- Then Full Backup contains from starting to 6AM Data.
-- Differential Backup 1 : 6AM to 9AM.
-- Differential Backup 2 : 6AM to 11AM.
----------------------------------------------------------------------|
BACKUP DATABASE Local_DB
TO DISK = 'D:\DBA\Learn\SSMS\Local_DB_Diff_1.bkp'
WITH DIFFERENTIAL;
----------------------------------------------------------------------|
BACKUP DATABASE Local_DB
TO DISK = 'D:\DBA\Learn\SSMS\Local_DB_Diff.bkp'
WITH DIFFERENTIAL
,NAME = 'Local_DB DiffBkp'
,STATS = 10;
----------------------------------------------------------------------|
--# DCM (Differential Changed Map):
-- DCM is a bitmap pointer referenced by SQL Server to trace the modified pages since the last full backup.
-- After a full backup the DCM is reset.
--DCM page is the 6th page in the data file.
--DCM Page is the basic element of storage in SQL Server having size of 8KB.
--DCM Extent is a set/group of 8 data Pages having size of 64KB.
--While taking Differential backup SQL Server just backup only changed Extents or newly added Extents in the DCM Pages.
----------------------------------------------------------------------|
--View DCM Extents using DBCC (DataBase Console Commands)
DBCC TRACEON(3604);
-- Enables the specified trace flags.
-- Trace flag 3604 is used to redirect the output of some DBCC commands to the result window.
DBCC PAGE (database_name, file_id, page_number, print_option);
--To retrive DCM Page info use 6th Page_Number.
--To View All Pages along with their details use 3rd print_option.
DBCC PAGE (Local_DB, 1, 6, 3);
DBCC PAGE (Local_DB, 1, 6, 3) WITH TABLERESULTS;
--Field					VALUE
--(1:520) - (1:544)     CHANGED
--This above Extent is Changed having Pages from 1:520 to 1:544.
----------------------------------------------------------------------|
--# Smart Differential Backup:
SELECT * FROM sys.dm_db_file_space_usage;
----------------------------------------------------------------------
SELECT file_id,
		total_page_count,
		modified_extent_page_count,
		(modified_extent_page_count*100)/total_page_count as Change_Per
FROM sys.dm_db_file_space_usage;
----------------------------------------------------------------------
--# Differential Backup ==============================================|END|


--# Transaction Log Backup ==============================================|START|
-- It backups the transaction log of a database.
-- It stores log backup from last full backup or last transaction log backup.
-- A transaction log file stores a series of the logs (LSN - Log Sequence Number) that provide a history of every modification of data, in a database.
-- This series of modification is contained and maintained using LSN (Log Sequence Number) in the log chain.
-- A log chain always start with a full database backup, and continues until for reason it breaks the chain.
-- It can be run every hour or every half an hour.
-- It is use to recover point in recovery.
-- To recover database recovery model must be in full or bulk logged. and Require at least one full backup.
----------------------------------------------------------------------|
SELECT * FROM Local_DB..Table_1;
INSERT INTO Local_DB..Table_1 values (10,'J');
INSERT INTO Local_DB..Table_1 values (11,'K');
----------------------------------------------------------------------|
BACKUP LOG Local_DB
TO DISK = N'D:\DBA\Learn\SSMS\Local_DB_Log_1.bkp';
----------------------------------------------------------------------|
BACKUP LOG Local_DB
TO DISK = N'D:\DBA\Learn\SSMS\Local_DB_Log.bkp'
WITH
 NAME = N'Local_DB TranLogBkp'
,STATS = 10;
----------------------------------------------------------------------|
--# Transaction Log Shrink :
USE Local_DB;
ALTER DATABASE Local_DB SET RECOVERY SIMPLE WITH NO_WAIT;
DBCC SHRINKFILE (local_db_log,1);
ALTER DATABASE Local_DB SET RECOVERY FULL WITH NO_WAIT;
----------------------------------------------------------------------|
--# Transaction Log Backup ==============================================|END|


--# Tail Log Backup ==============================================|START|
-- It captures any log records that have not yet been backed up, to prevent work loss and to keep the log chain intact.
-- It captures tail of the log even if the database is offline, damaged and inaccessible, if transaction log is undamaged and accessible.
----------------------------------------------------------------------|
--# Scenario when we take tail log backup :
-- 1. IF the database is online and you plan to perform a restore operation on the database.
-- 2. Migrating database from one server to another server.
-- 3. Database is damaged or currupted, or data file is damaged or deleted.
-- 4. Database fails to start or goes offline.
----------------------------------------------------------------------|
BACKUP LOG Local_DB
TO DISK = N'D:\DBA\Learn\SSMS\Local_DB_TailLog_1.bkp'
WITH No_Truncate
, NAME = N'Local_DB TailLogBkp', STATS=10;
----------------------------------------------------------------------|
BACKUP LOG Local_DB
TO DISK = N'D:\DBA\Learn\SSMS\Local_DB_TailLog_2.bkp'
WITH NoRecovery
,Continue_After_Error;
----------------------------------------------------------------------|
-- 1. NoRecovery : It takes the database into restoring state.
-- 2. No_Truncate : Only when the database is damaged.
-- 3. Continue_After_Error : If database is damaged and unable to take tail log backup. or use CheckSUM.
----------------------------------------------------------------------|
--# Tail Log Backup ==============================================|END|


--# File Backup ==============================================|START|
-- It allows you to backup each fiile independently instead of having to backup the entire database.
-- Relevant for when you have created multiple data files for the database.
-- Useful for having very large files and need to back them up individually.
----------------------------------------------------------------------|
-- File Test_DB_File is in Test_DB_FileGroup this group of Database.
BACKUP DATABASE Local_DB FILE = 'Test_DB_File'
TO DISK = N'D:\DBA\Learn\SSMS\Local_DB_Test_DB_File_1.bkp'
WITH
NAME=N'Local_DB Test_DB_File BackUp_File'
,STATS=10;
----------------------------------------------------------------------|
--# File Backup ==============================================|END|


--# FileGroup Backup ==============================================|START|
-- It allows you to backup all files which are in a perticular FileGroup of database.
-- By default each database has own Primary FileGroup having one Data file.
----------------------------------------------------------------------|
-- File Test_DB_File is in Test_DB_FileGroup this group of Database.
BACKUP DATABASE Local_DB FileGroup = 'Test_DB_FileGroup'
TO DISK = N'D:\DBA\Learn\SSMS\Local_DB_Test_DB_FileGroup_1.bkp'
WITH
NAME=N'Local_DB Test_DB_FileGroup BackUp_FileGroup'
,STATS=10;
----------------------------------------------------------------------|
--# FileGroup Backup ==============================================|END|


--# Partial Backup ==============================================|START|
-- It processes the read-write file groups in a database.
-- It excludes all files from the backup which are in Read-Only.
-- This can't be used for Transaction log backup.
----------------------------------------------------------------------|
BACKUP DATABASE Local_DB Read_Write_FileGroups
TO DISK = N'D:\DBA\Learn\SSMS\Local_DB_Test_DB_Read_Write_FileGroups_1.bkp'
WITH
NAME=N'Local_DB Test_DB_Read_Write_FileGroups BackUp_Partial'
,STATS=10;
----------------------------------------------------------------------|
--# Partial Backup ==============================================|END|


--# Split Backup ==============================================|START|
-- It splits the backup into smaller chunks.
----------------------------------------------------------------------|
BACKUP DATABASE Local_DB
TO 
	DISK = N'D:\DBA\Learn\SSMS\Local_DB_Split_1.bkp',
	DISK = N'D:\DBA\Learn\SSMS\Local_DB_Split_2.bkp',
	DISK = N'D:\DBA\Learn\SSMS\Local_DB_Split_3.bkp'
WITH STATS=10;
----------------------------------------------------------------------|
--# Split Backup ==============================================|END|


--# Copy-Only Backup ==============================================|START|
-- It can take a backup of database without affecting the overall backup and restore procedures.
-- It supports Full, Bulk-Logged and Simple recovery model.
-- It is not available for Differential backup type.
----------------------------------------------------------------------|
BACKUP DATABASE Local_DB
TO DISK = N'D:\DBA\Learn\SSMS\Local_DB_Full_CopyOnly.bkp'
WITH Copy_Only 
,Name='Local_DB Full CopyOnly Backup'
,STATS=10;
----------------------------------------------------------------------|
--# Copy-Only Backup ==============================================|END|


--# Mirror Backup ==============================================|START|
-- It gives you another copy of Full Backup.
-- Using this we can create three mirror copies.
-- This feature is only available in Enterprise Edition and later versions.
----------------------------------------------------------------------|
BACKUP DATABASE Local_DB
TO DISK = N'D:\DBA\Learn\SSMS\Local_DB_Full_BKP.bkp'
Mirror TO DISK = N'D:\DBA\Learn\SSMS\Local_DB_Full_BKP_Mirror1.bkp'
WITH 
Name='Local_DB Full Backup with Mirror', STATS=10;
----------------------------------------------------------------------|
--# Mirror Backup ==============================================|END|


--# Compression Backup ==============================================|START|
-- Compress the Backup file.
-- Saving not only Disk Space but also Time.
-- BACKUP DATABASE WITH COMPRESSION is not supported on Express Edition.
----------------------------------------------------------------------|
BACKUP DATABASE Local_DB
TO DISK = N'D:\DBA\Learn\SSMS\Local_DB_Full_BKP_Compressed.bkp'
WITH Compression
,Name='Local_DB Full Backup with Compression', STATS=10;
----------------------------------------------------------------------|
--# Compression Backup ==============================================|END|


--# Restore Backup ==============================================|END|
-- We had to backup latest Full Backup, latest Differential Backup and then all Transaction-Log Backups after latest Diff Backup.
----------------------------------------------------------------------|
-- Ex. we have bellow Backup files.
--| FULL1 - DIFF1 - LOG1 - LOG2 - FULL2 - DIFF2 - DIFF3 - TLOG3 - TLOG4 |
--								   ✅			   ✅	   ✅      ✅
----------------------------------------------------------------------|
RESTORE DATABASE TESTDB FROM DISK = 'F:\DB_BACKUP\FULL2.BKP' WITH NORECOVERY;
RESTORE DATABASE TESTDB FROM DISK = 'F:\DB_BACKUP\DIFF3.BKP' WITH NORECOVERY;
RESTORE LOG TESTDB FROM DISK = 'F:\DB_BACKUP\TLOG3.BKP' WITH NORECOVERY;
RESTORE LOG TESTDB FROM DISK = 'F:\DB_BACKUP\TLOG4.BKP' WITH NORECOVERY;
RESTORE DATABASE TESTDB WITH RECOVERY;
----------------------------------------------------------------------|
-- WITH NORECOVERY is use to Restore first full backup and another further backups.
-- Use WITH RECOVERY to bring DB back to online which can be use.
----------------------------------------------------------------------|
--# Restore Backup file contaning Multiple Backup sets. Using Position of that Backup.
-- Ex.
RESTORE DATABASE TESTDB FROM DISK = 'F:\DB_BACKUP\FULL2.BKP' WITH NORECOVERY, FILE = 2;
----------------------------------------------------------------------|
--# Permissions need to restore SQL DataBase.
-- Need to have any Role in (Sysadmin,db_creator,db_owner) to backup the databse.
--* Sysadmin	: can perform any action.
--* db_creator	: can restore any database.
--* db_owner	: can restore in a existing database.
----------------------------------------------------------------------|
--Restore Commands: (HeaderOnly, VerifyOnly, FileListOnly)
----------------------------------------------------------------------|
RESTORE HeaderOnly FROM DISK = N'D:\DBA\Learn\SSMS\Local_DB_Full.bkp';
--# RESTORE HeaderOnly is use to read backup header information for all backup set contaning in that bkp file.
--# BackupType Name
--1 Full
--2 Transaction Log
--4 File
--5 Differential
--6 Differential File
--7 Partial
--8 Differential Partial
--# Position (It is a sequential number for each backup.)
----------------------------------------------------------------------|
RESTORE VerifyOnly FROM DISK = N'D:\DBA\Learn\SSMS\Local_DB_Full.bkp';
RESTORE VerifyOnly FROM DISK = N'D:\DBA\Learn\SSMS\Local_DB_Full.bkp' WITH File = 1;
--# It is use to check the Disk is valid or not for the restore backup.
----------------------------------------------------------------------|
RESTORE FileListOnly FROM DISK = N'D:\DBA\Learn\SSMS\Local_DB_Full.bkp';
RESTORE FileListOnly FROM DISK = N'D:\DBA\Learn\SSMS\Local_DB_Full.bkp' WITH File = 1;
--# It returns a result set contaning a list of the database and log file in it.
-- Along with location of DataBase file and Log File. In column [PhysicalName].
-- Where column [Type] contains D for Data and L for Log.
----------------------------------------------------------------------|
--# Restore Backup ==============================================|END|



--# Encrypt a Backup and Restore ================================================|START|
----------------------------------------------------------------------|
--# To encrypt during Backup, We need to specify encription algorithm, and an encryptor to secure the rncryption key.
--# Supported encryption algorithms are (AES_128, AES_192, AES_256, Triple DES)
--# Encryptor : A certificate or asymmetric key.
----------------------------------------------------------------------|
--# Steps to BackUp the Database from Source DB ----------------|START|
--* Create database master key of the master database.
--* Create a backup certificate.
--* Backup the Database with Encryption.
----------------------------------------------------------------------|
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Passwd@123';
---------------------------------------------------------
CREATE CERTIFICATE MyTestCertificate WITH SUBJECT = 'My_Subject_Line';
---------------------------------------------------------
BACKUP CERTIFICATE MyTestCertificate 
TO FILE = 'D:\DBA\Learn\SSMS\TestDB_Certificate.cert'
WITH PRIVATE KEY(
	FILE = 'D:\DBA\Learn\SSMS\TestDB_CertificateKey.key',
	ENCRYPTION BY PASSWORD = 'Passwd@123');
---------------------------------------------------------
BACKUP DATABASE TESTDB TO DISK = 'D:\DBA\Learn\SSMS\Test_Local_DB_Full.bkp'
WITH ENCRYPTION(ALGORITHM = AES_256, SERVER CERTIFICATE = MyTestCertificate);
----------------------------------------------------------------------|
--# Steps to BackUp the Database From Source DB ----------------|END|
--====================================================================|
--# Steps to Restore the Database To Target DB ----------------|START|
--* Create database master key of the master database.
--* Create a certificate from the backup certificate.
--* Restore the Database.
----------------------------------------------------------------------|
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Passwd@123';
---------------------------------------------------------
CREATE CERTIFICATE MyTestCertificate
FROM FILE = 'D:\DBA\Learn\SSMS\TestDB_Certificate.cert'
WITH PRIVATE KEY(
	FILE = 'D:\DBA\Learn\SSMS\TestDB_CertificateKey.key',
	DECRYPTION BY PASSWORD = 'Passwd@123');
---------------------------------------------------------
RESTORE DATABASE TESTDB FROM DISK = 'D:\DBA\Learn\SSMS\Test_Local_DB_Full.bkp';
----------------------------------------------------------------------|
--# Steps to Restore the Database To Target DB ----------------|END|
----------------------------------------------------------------------|
--# SQL Server Express and SQL Server Web Eddition Do not support encryption.
----------------------------------------------------------------------|
--# Encrypt a Backup and Restore ================================================|END|


--# Point-in-Time-Recovery =======================================================|START|
--# It is use to Restore a Database to a Specific Point in Time.
-- Database must be in full or bolk-logged recovery mode.
----------------------------------------------------------------------|
RESTORE LOG TESTDB FROM DISK = 'F:\DB_BACKUP\TLOG3.BKP'
WITH RECOVERY, STOPAT = '2024-03-27 16:59:00'; --# if we know the exact time.
----------------------------------------------------------------------|
--****Scripts used in this video***** https://www.youtube.com/watch?v=NEQW1RUgpJ8
use DB123
create table test (ID varchar(10), Name varchar(10))
select * from test order by id

insert into test values ('A101', 'Record 1')
insert into test values ('B102', 'Record 2')

backup database DB123 
to disk = 'F:\dbbackup\DB123_full.bak'
---------------------------------------------------------
insert into test values ('C103', 'Record 3')
insert into test values ('D104', 'Record 4')

backup database DB123 
to disk = 'F:\dbbackup\DB123_diff1.bak' with differential
----------------------------------------------------------
insert into test values ('E105', 'Record 5')
insert into test values ('F106', 'Record 6')

delete from test where name = 'Record 4'

backup log DB123 
to disk = 'F:\dbbackup\DB123_log1.trn'
-----------------------------------------------------------
insert into test values ('G107', 'Record 7')
insert into test values ('H108', 'Record 8')

backup log DB123 
to disk = 'F:\dbbackup\DB123_log2.trn'

---------------------------------------------------------------

restore database DB123_temp
from disk = 'F:\dbbackup\DB123_full.bak' with norecovery,
move 'DB123' to 'F:\dbbackup\DB123_temp_data.mdf',
move 'DB123_log' to 'F:\dbbackup\DB123_temp_log.ldf'

restore database DB123_temp
from disk = 'F:\dbbackup\DB123_diff1.bak' with norecovery
--If we know exact timestamp
restore log DB123_temp from disk = 'F:\DbBackup\DB123_log1.trn'
with recovery, STOPAT = '2022-03-03 16:59:00'

--Not sure about timestamp
Select [Current LSN], [Transaction ID], Operation, Context, AllocUnitName     
FROM fn_dblog(NULL, NULL)    
WHERE Operation = 'LOP_DELETE_ROWS'

SELECT  [Current LSN], [Transaction ID],[Operation],[Context], [AllocUnitName]
FROM fn_dblog(NULL, NULL)
WHERE [Operation] = 'LOP_DELETE_ROWS'
AND [AllocUnitName] = 'dbo.test'

--If there is only one transaction ID under which all DELETED rows are showing 
--that means this action has been performed in a single batch. 

SELECT    
[Current LSN], Operation,[Transaction ID],[Begin Time],[Transaction Name],[Transaction SID]    
FROM  fn_dblog(NULL, NULL)    
WHERE [Transaction ID] = '0000:00000379'    
AND [Operation] = 'LOP_BEGIN_XACT'  

restore log DB123_Temp
from disk = 'F:\dbbackup\DB123_log1.trn'
with stopbeforemark = 'lsn:0x0000002e:000001c0:0001', norecovery --# 'lsn:0x[Current LSN]'
--# LSN in Hexa-decimal Format  
-- Part1:Part2:Part3 
-- 0000002e:000001c0:0001  <== LSN Number in Hexa-decimal format
-- 46:448:1  --# Decimal format
-- Part1 (as it is):Part2 (10 Digits):Part3 (5 Digits)
-- 46:0000000448:00001
-- 46000000044800001 <== LSN Number in Decimal Format

restore log DB123_Temp
from disk = 'F:\dbbackup\DB123_log1.trn'
with stopbeforemark = '46000000044800001'

restore log DB123_Temp 
from disk = 'F:\dbbackup\DB123_log2.trn' with recovery

insert into DB123.dbo.test
select * from DB123_temp.dbo.test 
where name not in (select name from DB123.dbo.test)
----------------------------------------------------------------------|
--# Point-in-Time-Recovery =======================================================|END|

--# Database Snapshot ============================================================|START|
--A Database Snapshot is a read-only, static view of the source database.
--Snpashot only available when source database is online.
--The database snapshot is transactionally consistent with the source database as of the moment of the snapshot's creation.
--A database snapshot always resides on the same server instance as its source database.
--It provides read-only view of the data in the same state as when the snapshot was created,
--it means if we create a snapshot of db, then insert new records, that new records are available for source DB not for Snapshot.
--The size of the snapshot file grows as changes are made to the source database. can give low-disk-space alert.
----------------------------------------------------------------------|
EXEC SP_HELPDB Local_DB;
----------------------------------------------------------------------|
CREATE DATABASE database_snapshot_name
ON (NAME = logical_file_name,
    FILENAME = 'os_file_name'
) AS SNAPSHOT OF source_database_name
----------------------------------------------------------------------|
CREATE DATABASE Local_DB_dbss
ON (NAME = Local_DB,
    FILENAME = 'D:\DBA\Learn\SSMS\Local_DB_dbss.ss'
) AS SNAPSHOT OF Local_DB;
----------------------------------------------------------------------|
--# To view the Database Snapshot
select * from sys.databases where source_database_id is not null;
----------------------------------------------------------------------|
--# To Use the Database Snapshot
select * from Local_DB_dbss..Table_1;
INSERT INTO Local_DB..Table_1 values (13,'M');
select * from Local_DB..Table_1;
-- in above Example we create a Database Snapshot of source db,
-- and do any change in source db, then this change is never reflect on snapshot.
----------------------------------------------------------------------|
--# To Delete the Database Snapshot
DROP DATABASE Local_DB_dbss;
--# Database Snapshot ============================================================|END|

--# DataBase Backup & Restore ##############################################################|END|



--# Detach & Attach DataBase ################################################################|START|
To move a detached database to another location and re-attach it to the same or a different server instance in SQL Server.
However, we recommend that you move databases by using the ALTER DATABASE planned relocation procedure, instead of using detach and attach.
----------------------------------------------------------------------|
USE master;  
GO  
EXEC sp_detach_db @dbname = N'<database-name>';  
GO  
----------------------------------------------------------------------|
USE master;  
GO  
CREATE DATABASE <database-name>   
    ON	(FILENAME = 'C:\MySQLServer\<database-name>_Data.mdf'),  
		(FILENAME = 'C:\MySQLServer\<database-name>_Log.ldf')  
    FOR ATTACH;  
GO  
----------------------------------------------------------------------|
--# Detach & Attach DataBase ################################################################|END|


---------------------------------------------------------------------------------------------------|
--32) Which is the main third-party tool used in SQL Server?
--A list of third-party tools used in SQL Server:

--SQL CHECK - Idera: It is used to monitor server activities and memory levels.
--SQL DOC 2 - RedGate: It is used to document the databases.
--SQL Backup 5 - RedGate: It is used to automate the Backup Process.
--SQL Prompt - RedGate: It provides IntelliSense for SQL SERVER 2005/2000.
--Lite Speed 5.0 - Quest Soft: It is used for Backup and Restore.
---------------------------------------------------------------------------------------------------|

---------------------------------------------------------------------------------------------------|
--33) What are the advantages of using third-party tools?
--A list of advantages of using third-party tools:

--Third party tools provide faster backups and restore.
--They provide flexible backup and recovery options.
--They provide secure backups with encryption.
--They provide the enterprise view of your backup and recovery environment.
--Easily identify optimal backup settings.
--Visibility into the transaction log and transaction log backups.
--Timeline view of backup history and schedules.
--Recover individual database objects.
--Encapsulate a complete database restore into a single file to speed up restore time.
--When we need to improve upon the functionality that SQL Server offers natively.
--Save time, better information or notification.
--Third party tools can put the backups in a single compressed file to reduce the space and time.
---------------------------------------------------------------------------------------------------|


--# Create Maintenance Plan for Backup || Automating and scheduling backups || ============================|START|
-- We can use also SQL Server Agent Job to schedule an automated backup.
-- in Management --> Maintenance Plan.
--# Create Maintenance Plan for Backup || Automating and scheduling backups || ============================|END|




--# SQL Server DataBase Login and Database User #############################################|START|
--A "Login" grants the principal entry into the SERVER.
--A "User" grants a login entry into a single DATABASE.
--One "Login" can be associated with many users (one per database).
--Each of the above objects can have permissions granted to it at its own level.
---------------------------------------------------------------------------------------------|
--# Creating a login with a password :
CREATE LOGIN <loginname> WITH PASSWORD = '<Password>';
--# Creating a login with a password that has got to be changed :
CREATE LOGIN <loginname> WITH PASSWORD = '<Password>'
MUST_CHANGE, CHECK_EXPIRATION = ON;
--# Creating a login with multiple arguments :
CREATE LOGIN <loginname>
WITH PASSWORD = '<Password>',
DEFAULT_DATABASE = <Databasename>,
CHECK_POLICY = OFF,
CHECK_EXPIRATION = OFF ;
---------------------------------------------------------------------------------------------|
--# Creating a User for the login in perticular DataBase :
USE <database-name>;
CREATE USER <user-name> FOR LOGIN <login-name>;
--# SQL Server DataBase Login and Database User #############################################|END|


--# Assign Permissions to User in SQL Server ################################################|START|
--You can GRANT and REVOKE permissions on various database objects in SQL Server. User permissions are at the database level.
--You can grant any or a combination of the following types of permissions :
Select: Grants user the ability to perform Select operations on the table.
Insert: Grants user the ability to perform the insert operations on the table.
Update: Grants user the ability to perform the update operations on the table.
Delete: Grants user the ability to perform the delete operations on the table.
Alter: Grants user permission to alter the table definitions.
References: References permission is needed to create a Foreign key constraint on a table. It is also needed to create a Function or View WITH SCHEMABINDING clause that references that object
Control: Grants SELECT, INSERT, UPDATE, DELETE, and REFERENCES permission to the User on the table.
---------------------------------------------------------------------------------------------|
USE <database-name>;
--GRANT Permissions Syntax
GRANT <permissions> ON <db-object> TO <user-name, login-name, or group>;
--REVOKE Permissions Syntax
REVOKE <permissions> ON <db-object> FROM <user-name, login-name, or group>;
---------------------------------------------------------------------------------------------|
--Ex.
---------------------------------------------------------------------------------------------|
USE HR;
GRANT SELECT ON Employee TO Steve;
---------------------------------------------------------------------------------------------|
USE HR;
GRANT SELECT, INSERT, UPDATE, DELETE ON EmployeeAddress TO Steve;
---------------------------------------------------------------------------------------------|USE HR;
REVOKE DELETE ON EmployeeAddress FROM Steve;
---------------------------------------------------------------------------------------------|
--# Assign Permissions to User in SQL Server ################################################|END|







SELECT * FROM sys.schemas;


SELECT SESSION_ID,DEADLOCK_PRIORITY,*
FROM SYS.dm_exec_sessions;


--# DEADLOCK =======================================================================================|START|
select * from table1
select * from table2

SET DEADLOCK_PRIORITY HIGH

begin tran 
--**Statement1
update table1 set name = 'Ramos'
where id = 103
--**Statement2
update table2 set salary = 50000
where id = 101

--===============================
begin tran
--**Statement1
update table2 set salary = 50000
where id in (101,102,103)
--**Statement2
update table1 set name = 'Ramos'
where id = 103

--===============================

SET DEADLOCK_PRIORITY HIGH   ---  priority of +5.
SET DEADLOCK_PRIORITY NORMAL ---  priority of  0.
SET DEADLOCK_PRIORITY LOW    ---  priority of -5.
SET DEADLOCK_PRIORITY 10
SET DEADLOCK_PRIORITY -2

SELECT session_id, deadlock_priority FROM sys.dm_exec_sessions;

--# To get recent deadlocks from SQL Server's error log =========================|START|
-- Query to retrieve recent deadlock information from SQL Server error log
USE master;
GO
-- Enable trace flags to capture deadlock information in error log (optional but recommended)
DBCC TRACEON (1204, -1);
DBCC TRACEON (1222, -1);
-- Query to retrieve deadlock information from error log
EXEC xp_readerrorlog 0, 1, N'Deadlock';
-- Disable trace flags (optional)
DBCC TRACEOFF (1204, -1);
DBCC TRACEOFF (1222, -1);
--# To get recent deadlocks from SQL Server's error log =========================|END|

--# DEADLOCK =======================================================================================|END|

--=======================================================================================================||
--# The RETURN statement is typically used within stored procedures or functions to exit early and return a value to the caller. 
drop table if exists Tbl_Return;create table Tbl_Return(c1 int);
create procedure SP_ReturnTest
as
begin try
	--print 1
	insert into Tbl_Return values(1)
	return
	--print 2
	insert into Tbl_Return values(2)
	return
	--print 3
	insert into Tbl_Return values(3)
	select * from Tbl_Return;
end try
begin catch
	print 0
end catch;

exec SP_ReturnTest;
select * from Tbl_Return;
--=======================================================================================================||


--###############################################################################################################################|||







--###############################################################################################################################|START|
--# Each of these relational database management systems (RDBMS) has its own syntax for SQL (Structured Query Language), 
--  which includes variations in data types, functions, operators, and specific features. 
--  Here's a brief overview of the differences in syntax between MSSQL (Microsoft SQL Server), MySQL, PostgreSQL, and Oracle:

--1. Data Types:

--   - MSSQL: `INT`, `VARCHAR`, `DATETIME`
--   - MySQL: `INT`, `VARCHAR`, `DATETIME`
--   - PostgreSQL: `INTEGER`, `VARCHAR`, `TIMESTAMP`
--   - Oracle: `NUMBER`, `VARCHAR2`, `DATE`

--2. String Concatenation:

--   - MySQL/PostgreSQL: `SELECT CONCAT('Hello', ' ', 'World');`
--   - MSSQL/Oracle: `SELECT 'Hello' + ' ' + 'World';`

--3. Case Sensitivity:

--   - MySQL/PostgreSQL: `SELECT * FROM table WHERE column = 'value';`
--   - MSSQL/Oracle: `SELECT * FROM table WHERE column = 'value';`

--4. Quoting Strings:

--   - MySQL/PostgreSQL: `SELECT 'String';`
--   - MSSQL: `SELECT 'String';` or `SELECT "String";`
--   - Oracle: `SELECT 'String';`

--5. Auto-incrementing Columns:

--   - MySQL: `id INT AUTO_INCREMENT PRIMARY KEY`
--   - MSSQL: `id INT IDENTITY(1,1) PRIMARY KEY`
--   - PostgreSQL: `id SERIAL PRIMARY KEY`
--   - Oracle: `id NUMBER PRIMARY KEY`

--6. LIMIT/OFFSET:

--   - MySQL/PostgreSQL: `SELECT * FROM table LIMIT 10 OFFSET 20;`
--   - MSSQL: `SELECT * FROM table ORDER BY column OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY;`
--   - Oracle: `SELECT * FROM (SELECT * FROM table ORDER BY column) WHERE ROWNUM <= 10 AND ROWNUM > 20;`

--7. Date Functions:

--   - `SELECT CURRENT_DATE;` (MySQL/PostgreSQL)
--   - `SELECT GETDATE();` (MSSQL)
--   - `SELECT SYSDATE FROM DUAL;` (Oracle)

--8. Transaction Control:

--   - `BEGIN TRANSACTION;` `COMMIT;` `ROLLBACK;` (MSSQL)
--   - `START TRANSACTION;` `COMMIT;` `ROLLBACK;` (MySQL)
--   - `BEGIN;` `COMMIT;` `ROLLBACK;` (PostgreSQL)
--   - `BEGIN;` `COMMIT;` `ROLLBACK;` (Oracle)

--9. Comments:

--   - `-- This is a comment` (MySQL/PostgreSQL/MSSQL)
--   - `/* This is a multi-line comment */` (MySQL/PostgreSQL/MSSQL)

--10. Function Naming:

--    - MSSQL: `LEN()`, `GETDATE()`
--    - MySQL: `LENGTH()`, `NOW()`
--    - PostgreSQL: `LENGTH()`, `CURRENT_TIMESTAMP`
--    - Oracle: `LENGTH()`, `SYSTIMESTAMP`

--These examples demonstrate the syntax and usage differences between the four databases for various SQL features.
--###############################################################################################################################|END|





















EXEC sp_help 'YourTableName';


--# Data Warehouse:

--A Data Warehouse is a centralized repository or database that stores large volumes of 
--structured, semi-structured, and unstructured data from various sources within an organization. 
--It is specifically designed for query and analysis rather than transaction processing. 
--Here are some key characteristics and functions of a Data Warehouse:

--Centralized Storage: Data Warehouses consolidate data from multiple sources, such as operational databases, CRM systems, ERP systems, spreadsheets, and more, into a single repository.
--Subject-Oriented: Data Warehouses are organized around subjects or themes that are relevant to the organization's business, such as sales, marketing, finance, or human resources. This organization allows for easier analysis of specific areas of interest.
--Historical Data: Data Warehouses typically store historical data over an extended period, allowing users to analyze trends, patterns, and changes over time.
--Non-Volatile: Once data is loaded into the Data Warehouse, it is rarely or never updated or deleted. Instead, new data is added to the warehouse to maintain a comprehensive historical record.
--Integrated: Data from various sources is transformed, standardized, and integrated into a consistent format within the Data Warehouse. This integration process ensures that users can analyze data from different systems without encountering inconsistencies or discrepancies.
--Optimized for Analytics: Data Warehouses are optimized for complex queries, reporting, and data analysis. They often use specialized technologies and architectures, such as star schemas or snowflake schemas, to facilitate efficient querying and analysis.
--Supports Decision Making: Data Warehouses provide a platform for decision support and business intelligence (BI) initiatives. They enable organizations to gain insights from their data, make informed decisions, and identify opportunities for improvement.

---------------------------------------------------------------

--# ETL:
--ETL stands for Extract, Transform, and Load. 
--It refers to a process commonly used in data integration and data warehousing to collect data 
--from various sources, transform it into a consistent format, and load it into a target destination, 
--such as a data warehouse, database, or data lake. Here's a breakdown of each component:

--1. Extract: In the extraction phase, data is collected from one or more source systems, which can include databases, applications, files, APIs, and other data repositories. The goal is to extract relevant data needed for analysis or reporting from these disparate sources.
--2. Transform: Once the data is extracted, it undergoes transformation to standardize, clean, and enrich it to make it suitable for analysis. Transformations may include data cleansing (removing duplicates, correcting errors), data validation, data formatting, data aggregation, and applying business rules or calculations. The transformation process ensures that the data is consistent, accurate, and structured according to the requirements of the target system.
--3. Load: After transformation, the data is loaded into the target destination, such as a data warehouse, data mart, or operational database. The loading phase involves inserting the transformed data into the destination system while maintaining data integrity and ensuring optimal performance. Depending on the architecture and requirements, the data may be loaded incrementally (delta loads) or in batch processes.

--ETL processes are essential for organizations that need to integrate data from multiple sources, harmonize it into a consistent format, and make it available for analysis, reporting, and decision-making. ETL tools and platforms automate and streamline these processes, providing features for data extraction, transformation, and loading, as well as scheduling, monitoring, and managing ETL workflows.

---------------------------------------------------------------

--# Star Schema:
--A Star Schema is a type of data warehouse schema that consists of one or more fact tables referencing any number of dimension tables. It is called a star schema because the diagram of the schema resembles a star, with the fact table at the center and the dimension tables radiating out from it like the arms of a star.

--Key characteristics of a star schema include:
--1. Fact Table: The fact table contains numerical measures or metrics that represent the business process being analyzed or monitored. It typically contains foreign keys that reference the primary keys of associated dimension tables. Fact tables are often large and contain transactional or aggregated data.
--2. Dimension Tables: Dimension tables are auxiliary tables that provide context or descriptive information about the measures in the fact table. They contain attributes or characteristics by which the data in the fact table can be analyzed or filtered. Dimension tables are usually smaller in size compared to fact tables and provide metadata about the data.
--3. Star Structure: The relationship between the fact table and dimension tables forms a star-like structure, where the fact table sits at the center and dimension tables radiate out from it. Each dimension table is directly connected to the fact table through foreign key relationships.
--4. Denormalized Design: Star schemas are denormalized, meaning that redundant data may exist within dimension tables to optimize query performance. This denormalization simplifies querying and reporting operations by reducing the number of table joins required to retrieve data.
--5. Simplified Querying: The star schema design facilitates simplified querying and analysis of data, as users can easily navigate from the central fact table to related dimension tables to retrieve specific information. Queries typically involve joining the fact table with one or more dimension tables based on common keys.

--Star schemas are widely used in data warehousing and business intelligence environments due to their simplicity, efficiency, and ease of use for analytical purposes. They provide a structured and optimized model for organizing and querying large volumes of data to support decision-making and analysis within organizations.

---------------------------------------------------------------

--# Snowflake Schema:
--A Snowflake Schema is a type of data warehouse schema that extends the concept of a star schema by normalizing dimension tables to eliminate redundancy and improve data integrity. In a snowflake schema, dimension tables are organized into multiple related tables, resembling the shape of a snowflake when visualized, hence the name.

--Key characteristics of a snowflake schema include:
--1. Normalized Dimension Tables: Unlike in a star schema, where dimension tables are denormalized, dimension tables in a snowflake schema are normalized. This means that attributes within dimension tables are organized into multiple related tables, with each table representing a level of detail or hierarchy.
--2. Hierarchical Structure: The snowflake schema organizes dimension tables into a hierarchical structure, with each level of the hierarchy represented by a separate table. For example, a product dimension might have separate tables for product categories, subcategories, and individual products.
--3. Reduced Redundancy: By normalizing dimension tables, redundancy is reduced compared to a denormalized star schema. This can result in more efficient storage and potentially faster query performance, especially for large data sets with repetitive attributes.
--4. Normalized Relationships: Relationships between dimension tables are represented by foreign key relationships between tables at different levels of the hierarchy. For example, a foreign key in a subcategory table might reference a primary key in a category table, and so on.
--5. Complexity: Snowflake schemas can introduce additional complexity to the data model compared to star schemas, as queries may require joining multiple tables to navigate the hierarchy. However, they offer advantages in terms of data integrity, flexibility, and scalability.
--6. Maintenance: Snowflake schemas may require more maintenance effort compared to star schemas due to the need to manage multiple related tables and maintain referential integrity between them.

--Snowflake schemas are commonly used in scenarios where data integrity is paramount, and there is a need to represent complex hierarchical relationships between dimension attributes. While they may require more effort to design and maintain, snowflake schemas offer advantages in terms of data normalization, flexibility, and scalability for certain types of analytical queries and reporting requirements.

---------------------------------------------------------------

--# OLTP | Online Transaction Processing:
--Online Transaction Processing (OLTP) is a type of database processing that facilitates and manages transaction-oriented applications typically used in day-to-day operations of organizations. It is designed to efficiently handle a large number of transactions in real-time.

--Key characteristics of OLTP systems include:
--1. Transactional Nature: OLTP systems are optimized for handling individual transactions in real-time. Transactions involve operations such as inserting, updating, deleting, and retrieving small amounts of data in response to user requests.
--2. Concurrent Users: OLTP systems are designed to support multiple concurrent users performing transactions simultaneously. These transactions can range from simple data retrievals to complex updates.
--3. Low Latency: OLTP systems prioritize low latency, aiming to process transactions quickly to provide a responsive user experience. Responses to user requests are typically generated within milliseconds.
--4. Data Normalization: Data in OLTP databases is often highly normalized to reduce redundancy and ensure data integrity. Normalization helps in minimizing data duplication and maintaining consistency across the database.
--5. High Availability: OLTP systems are designed for high availability to ensure that users can access the system and perform transactions without interruption. This often involves implementing redundancy and failover mechanisms to mitigate the risk of system downtime.
--6. ACID Properties: OLTP transactions adhere to the ACID (Atomicity, Consistency, Isolation, Durability) properties to ensure data integrity and reliability. Transactions are atomic, consistent, isolated, and durable, guaranteeing that database transactions are processed reliably even in the event of system failures.
--7. Focused on Current Data: OLTP systems primarily deal with current and frequently updated data. They are optimized for handling operational tasks such as order processing, inventory management, customer transactions, and online banking.

--OLTP systems are commonly used in various industries and applications where real-time transaction processing is critical, such as retail, banking, e-commerce, healthcare, and telecommunications. They serve as the backbone of operational systems, ensuring that businesses can efficiently manage their day-to-day transactions and operations.

---------------------------------------------------------------

--# OLAP | Online Analytical Processing:
--Online Analytical Processing (OLAP) is a category of software tools and technologies used to perform complex analysis of data stored in a database. Unlike OLTP (Online Transaction Processing), which focuses on managing and processing individual transactions in real-time, OLAP is designed for querying and analyzing large volumes of historical and aggregated data to gain insights and make informed decisions.

--Key characteristics of OLAP include:
--1. Analytical Queries: OLAP systems support complex analytical queries that involve aggregating, summarizing, and comparing data across multiple dimensions and hierarchies. Users can perform drill-down, roll-up, slice-and-dice, and pivot operations to analyze data from different perspectives.
--2. Multidimensional Data Model: OLAP databases are structured using a multidimensional data model that organizes data into dimensions, measures, and hierarchies. Dimensions represent the attributes or categories by which data is analyzed, while measures are the numerical values being analyzed. Hierarchies define the relationships between different levels of granularity within dimensions.
--3. Aggregation: OLAP databases pre-calculate and store aggregated data to improve query performance. Aggregates are computed at different levels of granularity to support various levels of analysis. This allows users to retrieve summarized data quickly without having to compute aggregations on the fly.
--4. Fast Query Response Time: OLAP systems are optimized for fast query response time, allowing users to interactively explore and analyze data without significant delays. Precomputed aggregates, indexing, and caching mechanisms contribute to efficient query performance.
--5. Business Intelligence (BI) Tools Integration: OLAP systems are often integrated with Business Intelligence (BI) tools and reporting applications that provide intuitive interfaces for data visualization, dashboards, and ad-hoc querying. These tools enable business users to analyze data and generate insights without relying on IT specialists.
--6. Support for Decision-Making: OLAP facilitates decision-making by enabling users to perform trend analysis, forecasting, variance analysis, and other advanced analytical techniques. Decision-makers can gain valuable insights into business performance, customer behavior, market trends, and operational efficiency.
--7. Data Cubes: OLAP data is organized into multidimensional structures known as data cubes. Data cubes represent the intersection of multiple dimensions and contain pre-aggregated data for efficient analysis. Users can navigate through the data cube to explore different dimensions and levels of detail.

--OLAP is widely used in business intelligence, financial analysis, performance monitoring, sales forecasting, and other decision support applications. It empowers organizations to extract actionable insights from their data, identify trends and patterns, and make data-driven decisions to drive business growth and competitiveness.

---------------------------------------------------------------

--# OLTP Vs OLAP :
--1. Current Data | Historical Data.
--2. Used by frontline employs and managers. | Analyst, Executives and Decision-makers.
--3. Day to Day Transactions. | Data analysis and Decision making.
--4. Normalized (Structured) data structure. | Star and Snowflake schema.
--5. Simle Queries. | Complex Queries.
--6. Require faster response time. | Can have longer response time.
--7. Data in OLTP system is Updated in Real Time. | Data in OLAP system is periodically refreshed.
--8. MySQL, MSSQL, Oracle, DB2. | Power Bi, Tableaue and SAP.

---------------------------------------------------------------

--# Normalization in Data Transformation | Min-Max & Z-score Techniques with example:
--Normalization is a crucial step in data preprocessing, particularly in the context of machine learning and statistical analysis. 
--It involves transforming numerical data into a standard format to ensure fair comparison between different features or variables. 
--Two common normalization techniques are Min-Max scaling and Z-score normalization.

--### Min-Max Scaling:
--Min-Max scaling rescales the data to a fixed range, usually between 0 and 1, based on the minimum and maximum values of the variable.

--Formula: X scaled = (X-Xmin)/(Xmax-Xmin)
--Example:
--Consider a dataset of house prices with the following values:
--- Minimum price (X_min) = \$100,000
--- Maximum price (X_max) = \$1,000,000
--- Current price (X) = \$300,000

--Using Min-Max scaling:
--So, the scaled value of \$300,000 is 
--= (300,000-X_min)/(X_max-X_min)
--= (300,000-100,000)/(1,000,000-100,000)
--approximately 0.222.


--### Z-score Normalization:
--Z-score normalization (also known as standardization) scales the data to have a mean of 0 and a standard deviation of 1.

--Formula: X scaled = (X-μ)/σ
--where 
--	μ(mu) is the mean = (Sum of values / count of values)
--	σ(sigma) is the standard deviation of the variable. = √(  ((value1-mean)sqr + (value2-mean)sqr + ...)/count of values  ).
--Example:
--Consider a dataset of exam scores with the following values:
--- Mean (\(\mu\)) = 75
--- Standard deviation (\(\sigma\)) = 10
--- Score (X) = 85

--Using Z-score normalization:
--So, the scaled value of 85 is 
--= (85-mean)/STD
--= (85-75)/10
--1 standard deviation above the mean.

--### Comparison:
--- Min-Max scaling preserves the original distribution of the data within a fixed range, making it suitable for algorithms sensitive to the scale of the features, such as neural networks.
--- Z-score normalization centers the data around 0 and scales it according to the variability of the data, making it robust to outliers and suitable for algorithms based on distance metrics, like K-nearest neighbors (KNN) and clustering algorithms.

--Both techniques are valuable tools in data preprocessing and should be chosen based on the specific requirements of the problem and the characteristics of the dataset.


---------------------------------------------------------------

--# Creation of bins:
--Ex. Calculate the Bin Width, if you decide to have four age groups. and the age range is 18 to 70.

--No of Bins = x = 4
--Bin Widthn = bw = (max-min)/x = (70-18)/4 = 13

--Bin1 = (min) to (min+bw-1) = 18 to 30
--Bin2 = (min+bw) to (min+2bw-1) = 31 to 43
--Bin3 = (min+2bw) to (min+3bw-1) = 44 to 56
--Bin4 = (min+3bw) to (max) = 57 to 70

---------------------------------------------------------------




create table Tbl_Dept (Id int identity(1,1) primary key, Name varchar(10));
create table Tbl_Emp (Id int identity(1,1) primary key, Name varchar(10), DepID int foreign key references Tbl_Dept(Id));
insert into Tbl_Dept values('Dept A'),('Dept B'),('Dept C');
insert into Tbl_Emp values('Name A',1),('Name B',1),('Name C',1),('Name D',2),('Name E',2),('Name F',3);
select * from Tbl_Dept;
select * from Tbl_Emp;
delete from Tbl_Dept where id=1;
delete from Tbl_Emp where id=1;



select * from INFORMATION_SCHEMA.TABLES
where TABLE_NAME like 'SPL_SA_%'

select top 5 * from INFORMATION_SCHEMA.TABLES
where TABLE_NAME = 'Temp_Table_Account_ScrubData'

select top 5 * from sys.all_objects
where NAME = 'Temp_Table_Account_ScrubData'


select * from Tbl_Emp
order by ID
offset 2 rows
fetch next 1 row only;






#===================================================================================================================
import warnings
warnings.filterwarnings('ignore')
#-----------------------------------                    
import time
import pandas as pd
import numpy as np
from datetime import datetime
import logging
import os
#-----------------------------------
import sqlalchemy
from sqlalchemy import create_engine
user="sa"
password="SA@123"
server="Aditya-7369\SQLSERVER22DEV" # SELECT @@SERVERNAME;
db="Local_DB"
# ms_sql_db_Engine = create_engine(f"mssql+pyodbc://{user}:{password}@{server}/{db}?driver=ODBC+Driver+17+for+SQL+Server",fast_executemany=True)
ms_sql_db_Engine = create_engine(f"mssql://{server}/{db}?driver=ODBC+Driver+17+for+SQL+Server",fast_executemany=True)
ms_sql_db_Connection = ms_sql_db_Engine.connect()
#===================================================================================================================
df1 = pd.DataFrame({'Key': ['b', 'b', 'a', 'c', 'a', 'a', 'b'], 'data1': range(7)})
df1.to_sql()
####################################################################################################################|




--# json with MS SQL =========================================================|START|

--# Table to json ===--------------------------------------------------
CREATE TABLE #T1(ID INT, NAME VARCHAR(10), AGE INT);
INSERT INTO #T1 VALUES (1,'Name1',25),(2,'Name2',25),(3,'Name3',25);

SELECT * FROM #T1
FOR JSON PATH, ROOT('Customers');

--# Read json ===--------------------------------------------------
DECLARE @json NVARCHAR(MAX);
SET @json = N'[
  {"id": 2, "info": {"name": "John", "surname": "Smith"}, "age": 25},
  {"id": 5, "info": {"name": "Jane", "surname": "Smith"}, "dob": "2005-11-04T12:00:00"}
]';
select ISJSON(@json);

select JSON_VALUE(@json,'$[0].id') id, JSON_VALUE(@json,'$[0].info.name') name;

--# json to Table ===--------------------------------------------------
SELECT *
FROM OPENJSON(@json) WITH (
    id INT '$.id',
    firstName NVARCHAR(50) '$.info.name',
    lastName NVARCHAR(50) '$.info.surname',
    age INT,
    dateOfBirth DATETIME '$.dob'
);
--# json with MS SQL =========================================================|END|


--# ==============================================================================///
--String Functions:
ASCII
CHAR
CHARINDEX
CONCAT
Concat with +
CONCAT_WS
DATALENGTH
DIFFERENCE
FORMAT
LEFT
LEN
LOWER
LTRIM
NCHAR
PATINDEX
QUOTENAME
REPLACE
REPLICATE
REVERSE
RIGHT
RTRIM
SOUNDEX
SPACE
STR
STUFF
SUBSTRING
TRANSLATE
TRIM
UNICODE
UPPER
--Numeric Functions:
ABS
ACOS
ASIN
ATAN
ATN2
AVG
CEILING
COUNT
COS
COT
DEGREES
EXP
FLOOR
LOG
LOG10
MAX
MIN
PI
POWER
RADIANS
RAND
ROUND
SIGN
SIN
SQRT
SQUARE
SUM
TAN
--Date Functions:
CURRENT_TIMESTAMP
DATEADD
DATEDIFF
DATEFROMPARTS
DATENAME
DATEPART
DAY
GETDATE
GETUTCDATE
ISDATE
MONTH
SYSDATETIME
YEAR
--Advanced Functions
CAST
COALESCE
CONVERT
CURRENT_USER
IIF
ISNULL
ISNUMERIC
NULLIF
SESSION_USER
SESSIONPROPERTY
SYSTEM_USER
USER_NAME
--# ==============================================================================///


--# Rebuilding Indexes for [accounts_tatacallingrecords] and [BusinessCallingData] --# Done.


--The general guideline here is, rebuild SQL indexes when/if possible and reorganize when fragmentation is low. 
--We will see some recommendations from Microsoft later in the article. In addition to what’s been already said, 
--here are additional guidelines and a brief explanation of what to look after:

--Identify and remove index fragmentation – 
--	This is obviously what we have been talking until now and the biggest part of the SQL index maintenance.
--Find and remove unused indexes – 
--	Everything that is unused doesn’t do anything good. All they do is waste space and resources. It’s advisable to remove those often.
--Detect and create missing indexes – 
--	This is an obvious one.
--Rebuild/Reorganize indexes weekly – 
--	As it was mentioned previously, this will depend on the environment, situation, database size, etc.
--Categorize fragmentation percentage – 
--	Microsoft suggests that we rebuild indexes when we have greater than 30% fragmentation and reorganize when they are in between 5% and 30% fragmentation. Those are general guidelines to follow but bear in mind that this will cover a good percentage of databases in the real world but again this might not apply for each situation.
--Create jobs to automate maintenance – 
--	Create a SQL Server Agent job that will automate SQL index maintenance. Then monitor and tweak jobs in a way that is appropriate to the particular environment because the state of data fluctuate depending on many things.

--Now, creating these jobs can be a double-edged sword. 
--We should always keep an eye on how long it takes for the job to finish maintenance plan. 
--I’d recommend using maintenance plans only on small databases and using custom scripts 
--everywhere else or even all the time. Scripts are flexible and overall better solution 
--while the plans are quick and a simpler solution.


-- # rebuild : fragmentation greater than 30%.
-- # reorganize : fragmentation between 5% and 30%.




select top 5 * from sys.tables
select top 5 * from information_schema.routines
where ROUTINE_TYPE = 'PROCEDURE'

select top 5 
ROUTINE_NAME,ROUTINE_DEFINITION
from information_schema.routines
where ROUTINE_TYPE = 'PROCEDURE'
and ROUTINE_DEFINITION like '%aditya%'




--# To find the currently running queries and processes in Microsoft SQL Server #=============================================|START|

--# #ActiveSessionInfoWithSQLText #==========================|
drop table if exists #ActiveSessionInfoWithSQLText
SELECT 
    p.spid, p.status, p.hostname, p.loginame, P.program_name, p.cpu, r.start_time, r.command, t.text
into #ActiveSessionInfoWithSQLText
FROM
    sys.dm_exec_requests as r,
    master.dbo.sysprocesses as p
    CROSS APPLY sys.dm_exec_sql_text(p.sql_handle) t
WHERE
    p.status NOT IN ('sleeping', 'background','runnable')
	AND r.session_id = p.spid
order by cpu desc;
select * from #ActiveSessionInfoWithSQLText;
--# #ActiveSessionInfoWithSQLText #==========================|

--# kill spid; ex. kill 475;
--# To find the currently running queries and processes in Microsoft SQL Server #=============================================|END|










--# MSSQL # Test Code ====================================================================///

Do revise the below concepts
1. StoreProc
2. Exception Handling in StoreProc
3. cursor concept
4. Trigger
5. Sequence
6. Constraints



What is the purpose of enforcing constraints in SQL?
SQL constraints are used to specify rules for the data in a table.
Constraints are used to limit the type of data that can go into a table.
This ensures the accuracy and reliability of the data in the table.
If there is any violation between the constraint and the data action, the action is aborted.


--#-------------------------------------------------------------------------------------------
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    DepartmentID INT,
	Salary MONEY,
    CONSTRAINT FK_Department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT CHK_Salary CHECK (Salary > 0)
);
--#-------------------------------------------------------------------------------------------



--#-------------------------------------------------------------------------------------------
CREATE PROCEDURE PR_TEST1 @V1 INT,@V2 INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        SELECT TOP 5 * FROM TBL WHERE V1 = @V1 AND V2 = @V2;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
    END CATCH
END;
--#-------------------------------------------------------------------------------------------



--#-------------------------------------------------------------------------------------------
DECLARE CUR_MYCUR1 CURSOR FOR SELECT V1, V2 FROM TBL;
OPEN CUR_MYCUR1;
DECLARE @V1 INT, @V2 INT;
FETCH NEXT FROM CUR_MYCUR1 INTO @V1, @V2;
WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        PRINT (@V1 + @V2);
    END TRY
    BEGIN CATCH
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
    END CATCH;
    FETCH NEXT FROM CUR_MYCUR1 INTO @V1, @V2;
END;
CLOSE CUR_MYCUR1;
DEALLOCATE CUR_MYCUR1;
--#-------------------------------------------------------------------------------------------


--#-------------------------------------------------------------------------------------------
CREATE SEQUENCE OrderSeq
    START WITH 1       -- Initial value
    INCREMENT BY 1     -- Increment value
    MINVALUE 1         -- Minimum value
    MAXVALUE 5		   -- Maximum value
    NO CYCLE           -- Whether to cycle back to the start value
    CACHE 10;          -- Number of values to cache

-- To use the sequence
SELECT NEXT VALUE FOR OrderSeq;

SET @OrderNumber = NEXT VALUE FOR OrderSeq;

INSERT INTO my_table (id, name) VALUES (NEXT VALUE FOR seq_example, 'John Doe');

-- Restart the sequence with a new value
ALTER SEQUENCE OrderSeq RESTART WITH 10;  

DROP SEQUENCE OrderSeq;
--#-------------------------------------------------------------------------------------------


































tomorrow 2 pm








