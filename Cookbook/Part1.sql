--���������� ���� ����� � �������� �� �������
SELECT * 
FROM emp

SELECT empno, ename, job, sal, mgr, hiredate, comm, deptno
FROM emp
--���������� ������������ ����� �� �������
SELECT * 
FROM emp
WHERE deptno = 10
--����� ����� �� ���������� ��������
SELECT *
FROM emp
WHERE deptno = 10
   OR comm is not null
   OR sal <=2000 AND deptno = 20


SELECT *
FROM emp
WHERE (
   deptno = 10
   OR comm is not null
   OR sal <=2000
	)
    AND deptno = 20
--���������� ������������ �������� �� �������
SELECT ename,deptno,sal
FROM emp
--��� ������ �������� �������� �����
SELECT sal as salary, comm as commission
FROM emp
--��������� � ������� � ��������� WHERE �� ����������
SELECT *
FROM
  ( SELECT sal AS salary,
           comm AS commission
   FROM emp ) AS x
WHERE salary < 5000

--������������ �������� ��������
SELECT ename + ' WORKS AS A ' + job AS msg
FROM emp
WHERE deptno=10
--������������� �������� ������ � ��������� SELECT
SELECT ename,
       sal,
       CASE
           WHEN sal <= 2000 THEN 'UNDERPAID'
           WHEN sal >= 4000 THEN 'OVERPAID'
           ELSE 'OK'
       END AS status
FROM emp
--����������� ����� ������������ �����
SELECT TOP 5 *
FROM emp
--����������� n ��������� ������� �������
SELECT TOP 5 ename,
           job
FROM emp
ORDER BY newid()
--����� �������� NULL
SELECT *
FROM emp
WHERE comm IS NULL
--�������������� �������� NULL � ��NULL ��������
SELECT COALESCE(comm,0)
FROM emp

SELECT CASE
           WHEN comm IS NULL THEN 0
           ELSE comm
       END
FROM emp
--����� �� �������
SELECT ename,
       job
FROM emp
WHERE deptno IN (10, 20)
  AND (ename LIKE '%I%' OR job LIKE '%ER')