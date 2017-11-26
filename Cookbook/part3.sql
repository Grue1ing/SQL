--Размещение одного набора строк под другим
SELECT ename AS ename_and_dname,
       deptno
FROM emp
WHERE deptno = 10
UNION ALL
SELECT '----------',
       NULL
FROM t1
UNION ALL
SELECT dname,
       deptno
FROM dept

--Объединение взаимосвязанных строк
SELECT e.ename,
       d.loc
FROM emp AS e,
     dept AS d
WHERE e.deptno = d.deptno
  AND e.deptno = 10

SELECT e.ename, d.loc
FROM emp AS e
	INNER JOIN dept AS d
		ON e.DEPTNO = d.DEPTNO
WHERE e.DEPTNO = 10

--Поиск одинаковых строк в двух таблицах
CREATE VIEW V1
AS 
SELECT ename, job, sal
FROM emp
WHERE job = 'CLERK'

SELECT * FROM V1

SELECT e.EMPNO, e.ENAME, e.JOB, e.SAL, e.DEPTNO
FROM emp AS e
	INNER JOIN V1
		ON e.ENAME = V1.ENAME
		AND e.JOB = V1.JOB
		AND e.SAL = V1.SAL
--SELECT empno, ename, job, sal, deptno
--FROM emp
--WHERE (ename, job, sal) IN (
--	SELECT ename, job, sal 
--	FROM emp
--	INTERSECT
--	SELECT ename, job, sal
--	FROM V1
--	)

--Извлечение из одной таблицы значений, которых нет в другой таблице
SELECT deptno
FROM dept
WHERE deptno NOT IN (SELECT deptno FROM emp)

SELECT deptno FROM dept
EXCEPT
SELECT deptno FROM emp

--Извлечение из таблицы строк, для которых нет соответствия в другой таблице

SELECT d.*
FROM dept AS d
	LEFT OUTER JOIN emp AS e
		ON d.DEPTNO = e.DEPTNO
WHERE e.DEPTNO IS NULL

--Независимое добавление объединений в запрос

CREATE TABLE emp_bonus
(
	EMPNO int,
	RECEIVED date NOT NULL,
	TYPE int NOT NULL
	PRIMARY KEY (EMPNO)
)
INSERT INTO emp_bonus
VALUES (7369, '14-03-2005', 1), (7900, '14-03-2005', 2), (7788, '14-03-2005', 3)

SELECT e.ENAME, d.LOC, eb.RECEIVED
FROM emp AS e
	INNER JOIN dept AS d
		ON e.DEPTNO = d.DEPTNO
	LEFT OUTER JOIN emp_bonus AS eb
		ON e.EMPNO = eb.EMPNO
ORDER BY d.LOC

--Выявление одинаковых данных в двух таблицах
CREATE VIEW V2
AS 
SELECT * FROM emp WHERE DEPTNO != 10
UNION ALL
SELECT * FROM emp WHERE ENAME = 'WARD'

SELECT * FROM V2

(SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO, COUNT(*) AS cnt
FROM V2 
GROUP BY EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
EXCEPT 
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO, COUNT(*) AS cnt
FROM emp
GROUP BY EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
)
UNION ALL
(SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO, COUNT(*) AS cnt
FROM emp
GROUP BY EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
EXCEPT 
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO, COUNT(*) AS cnt
FROM V2 
GROUP BY EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
)

-- Идентификация и устранение некорректного использования декартова произведения
SELECT e.ENAME, d.LOC
FROM emp AS e, dept AS d
WHERE e.DEPTNO = 10
	AND d.DEPTNO = e.DEPTNO

-- Осуществление объединений при использовании агрегатных функций
CREATE TABLE emp_bonus1
(
	EMPNO int NOT NULL,
	RECEIVED date NOT NULL,
	TYPE int NOT NULL
)
INSERT INTO emp_bonus1
VALUES (7934, '17-03-2005', 1), (7934, '15-02-2005', 2), (7839, '15-02-2005', 3), (7782, '15-02-2005', 1)

SELECT	deptno,
		SUM(DISTINCT sal) AS total_sal,
		SUM(bonus) AS total_bonus
FROM (
		SELECT	e.EMPNO,
				e.ENAME,
				e.SAL,
				e.DEPTNO,
				e.SAL * CASE 
							WHEN eb.TYPE = 1 THEN .1
							WHEN eb.TYPE = 2 THEN .2
							ELSE .3
						END AS bonus
		FROM emp AS e, emp_bonus1 AS eb
		WHERE e.EMPNO = eb.EMPNO
			AND e.DEPTNO = 10
		) AS x
GROUP BY DEPTNO
-- не работает distinct с оконными функциями
SELECT DISTINCT DEPTNO, total_sal, total_bonus
FROM
	(
		SELECT	e.EMPNO,
				e.ENAME,
				SUM(DISTINCT e.SAL) OVER (PARTITION BY e.DEPTNO) AS total_sal,
				e.DEPTNO,
				SUM(e.SAL * CASE 
								WHEN eb.TYPE = 1 THEN .1
								WHEN eb.TYPE = 2 THEN .2
								ELSE .3
							END) OVER(PARTITION BY DEPTNO) AS total_bonus
		FROM emp AS e, emp_bonus1 AS eb
		WHERE e.EMPNO = eb.EMPNO
			AND e.DEPTNO = 10
	) AS x

-- Внешнее объединение при использовании агрегатных функций
CREATE TABLE emp_bonus2
(
	EMPNO int NOT NULL,
	RECEIVED date NOT NULL,
	TYPE int NOT NULL
)
INSERT INTO emp_bonus2
VALUES (7934, '17-03-2005', 1), (7934, '15-02-2005', 2)

SELECT	DEPTNO,
		SUM(DISTINCT SAL) AS total_sal,
		SUM(bonus) AS total_bonus
FROM
	(
		SELECT	e.EMPNO,
				e.ENAME,
				e.SAL,
				e.DEPTNO,
				e.SAL * CASE
							WHEN eb.TYPE IS NULL THEN 0
							WHEN eb.TYPE = 1 THEN .1
							WHEN eb.TYPE = 2 THEN .2
							ELSE .3
						END AS bonus
		FROM emp AS e
			LEFT OUTER JOIN emp_bonus2 AS eb
				ON e.EMPNO = eb.EMPNO
		WHERE e.DEPTNO = 10
	) AS X
GROUP BY DEPTNO

-- Возвращение отсутствующих данных из нескольких таблиц
INSERT INTO emp
SELECT 1111, 'YODA', 'JEDI', NULL, HIREDATE, SAL, COMM, NULL
FROM emp
WHERE ENAME = 'KING'

SELECT d.DEPTNO, d.DNAME, e.ENAME
FROM dept AS d
	FULL OUTER JOIN emp AS e
		ON d.DEPTNO = e.DEPTNO

-- Значения NULL в операциях и сравнениях
SELECT	ENAME, COMM
FROM emp
WHERE COALESCE(COMM, 0) < (SELECT COMM 
							FROM emp
							WHERE ENAME = 'WARD')