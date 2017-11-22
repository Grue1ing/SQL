CREATE TABLE emp
( 
	EMPNO int NOT NULL,
	ENAME nvarchar(10) NOT NULL,
	JOB nvarchar(10) NOT NULL,
	MGR int,
	HIREDATE date NOT NULL,
	SAL int NOT NULL,
	COMM int,
	DEPTNO int NOT NULL
	PRIMARY KEY (EMPNO)
	)

INSERT INTO emp
VALUES (7369, 'SMITH', 'CLERK', 7902, '17-12-1980', 800, NULL, 20),
		(7499, 'ALLEN', 'SALESMAN', 7698, '20-02-1981', 1600, 300, 30),
		(7521, 'WARD', 'SALESMAN', 7698, '22-02-1981', 1250, 500, 30),
		(7566, 'JONES', 'MANAGER', 7839, '02-04-1981', 2975, NULL, 20),
		(7654, 'MARTIN', 'SALESMAN', 7698, '28-09-1981', 1250, 1400, 30),
		(7698, 'BLAKE', 'MANAGER', 7839, '01-05-1981', 2850, NULL, 30),
		(7782, 'CLARK', 'MANAGER', 7839, '09-06-1981', 2450, NULL, 10),
		(7788, 'SCOTT', 'ANALYST', 7566, '09-12-1982', 3000, NULL, 20),
		(7839, 'KING', 'PRESIDENT', NULL, '17-11-1981', 5000, NULL, 10),
		(7844, 'TURNER', 'SALESMAN', 7698, '08-09-1981', 1500, 0, 30),
		(7876, 'ADAMS', 'CLERK', 7788, '12-01-1983', 1100, NULL, 20),
		(7900, 'JAMES', 'CLERK', 7698, '03-12-1981', 950, NULL, 30),
		(7902, 'FORD', 'ANALYST', 7566, '03-12-1981', 3000, NULL, 20),
		(7934, 'MILLER', 'CLERK', 7782, '23-01-1982', 1300, NULL, 10)

CREATE TABLE dept
(
	DEPTNO int NOT NULL,
	DNAME nvarchar(20) NOT NULL,
	LOC nvarchar(20) NOT NULL
	PRIMARY KEY (DEPTNO)
)

INSERT INTO dept
VALUES (10, 'ACCOUNTING', 'NEW YORK'),
		(20, 'RESEARCH', 'DALLAS'),
		(30, 'SALES', 'CHICAGO'),
		(40, 'OPERATIONS', 'BOSTON')

CREATE TABLE t1
( 
	ID int NOT NULL
)
CREATE TABLE t10
( 
	ID int NOT NULL
)
CREATE TABLE t100
( 
	ID int NOT NULL
)
CREATE TABLE t500
( 
	ID int NOT NULL
)
