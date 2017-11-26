-- ������� ����� ������
INSERT INTO dept (DEPTNO, DNAME, LOC)
VALUES (50, 'PROGRAMMING', 'BALTIMORE')

-- ������� �������� �� ���������
CREATE TABLE D (ID integer DEFAULT 0)
INSERT INTO D VALUES (DEFAULT)
INSERT INTO D (ID) VALUES (DEFAULT)
INSERT INTO D DEFAULT VALUES

DROP TABLE D
CREATE TABLE D (ID integer DEFAULT 0, foo varchar(10)) 
INSERT INTO D (foo) VALUES ('Bar')

-- ��������������� �������� �� ��������� ��������� NULL
INSERT INTO D (ID, foo) VALUES (NULL, 'Brighten')
SELECT * FROM D

-- ����������� ����� �� ����� ������� � ������
INSERT INTO dept_east (DEPTNO, DNAME, LOC)
SELECT DEPTNO, DNAME, LOC
FROM dept
WHERE LOC IN ('NEW YORK', 'BOSTON')

-- ����������� �������� �������
SELECT *
INTO dept_2
FROM dept
WHERE 1 = 0

--������� � ��������� ������ ������������
TRUNCATE TABLE dept_east
SELECT *
INTO dept_mid
FROM dept_east
WHERE 1 = 0
/* �� ������ ��������� ����� �� �������������� ������� � ��������� ������ � ������ ������ �������*/

-- ���������� ������� � ������������ �������
CREATE VIEW new_emps AS
SELECT EMPNO, ENAME, JOB
FROM emp
INSERT INTO new_emps (EMPNO, ENAME, JOB)
VALUES (1, 'Jonathan', 'Editor')

-- ��������� ������� � �������
SELECT *
INTO emp1
FROM emp
UPDATE emp1
SET SAL = SAL * 1.1
WHERE deptno = 20

-- ���������� � ������ ������������� ��������������� ����� � ������ �������
INSERT INTO emp_bonus3
VALUES(7369, 'SMITH'), (7900, 'JAMES'), (7934, 'MILLER')
SELECT *
INTO emp2
FROM emp

UPDATE emp2
SET SAL = SAL * 1.2
WHERE EMPNO IN (SELECT EMPNO FROM emp_bonus3)

-- ���������� ���������� �� ������ �������
INSERT INTO new_sal VALUES (10, 4000)

SELECT *
INTO emp3
FROM emp

UPDATE e
SET e.SAL = ns.SAL,
	e.COMM = ns.SAL/2
FROM	emp3 AS e,
		new_sal AS ns
WHERE ns.DEPTNO = e.DEPTNO

-- ������� �������
SELECT DEPTNO, EMPNO, ENAME, COMM
INTO emp_commission
FROM emp
WHERE DEPTNO = 10

SELECT * INTO emp4 FROM emp

MERGE INTO [Cookbook].[dbo].[emp_commission] AS ec
USING emp
	ON (ec.EMPNO = emp.EMPNO)
WHEN MATCHED AND SAL < 2000
    THEN DELETE
WHEN MATCHED THEN
	UPDATE SET COMM = 1000
WHEN NOT MATCHED THEN
	INSERT (DEPTNO, EMPNO, ENAME, COMM) 
	VALUES (emp.DEPTNO, emp.EMPNO, emp.ENAME, emp.COMM)
OUTPUT  $action;

-- �������� ���� ������� �� �������
DELETE FROM emp4

-- �������� ������������ �������
DELETE FROM emp4 WHERE DEPTNO = 10

-- �������� ����� ������
DELETE FROM emp4 WHERE empno = 7782

-- �������� �������, ������� �������� ��������� �����������
DELETE FROM emp4 
WHERE NOT EXISTS (
	SELECT * FROM dept
	WHERE dept.DEPTNO = emp4.DEPTNO
	)
DELETE FROM emp4
WHERE DEPTNO NOT IN (SELECT DEPTNO FROM dept)

-- ����������� ������������� �������
CREATE TABLE dupes (ID integer, NAME varchar(10))
INSERT INTO dupes 
VALUES (1, 'NAPOLEON'), (2, 'DYNAMITE'), (3, 'DYNAMITE'), (4, 'SHE SELLS'),
		(5,'SEA SHELLS'), (6,'SEA SHELLS'), (7,'SEA SHELLS')

DELETE FROM dupes 
WHERE id NOT IN (SELECT MIN(id) FROM dupes GROUP BY NAME)

-- �������� �������, �� ������� ���� ������ � ������ �������
CREATE TABLE dept_accidents
(DEPTNO int,
ACCIDENT_NAME nvarchar(20))
INSERT INTO dept_accidents 
VALUES (10, 'BROKEN FOOT'), (10, 'FLESH WOUND'), (20, 'FIRE'), (20, 'FIRE'),
		(20, 'FLOOD'), (30, 'BRUISED GLUTE')

DELETE FROM emp4 
WHERE DEPTNO IN (SELECT DEPTNO FROM dept_accidents
				GROUP BY DEPTNO HAVING COUNT(*) >= 3)


