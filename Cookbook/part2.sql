--Возвращение результатов запроса в заданном порядке
SELECT ename,
       job,
       sal
FROM emp
WHERE deptno = 10
ORDER BY sal ASC

SELECT ename,
       job,
       sal
FROM emp
WHERE deptno = 10
ORDER BY 3 DESC

--Сортировка по нескольким полям
SELECT empno,
       deptno,
       sal,
       ename,
       job
FROM emp
ORDER BY deptno,
         sal DESC

--сортировка по подстрокам
SELECT ename,
       job
FROM emp
ORDER BY substring(job, len(job)-2,2)

--сортировка смешанных буквенно-цифровых данных
CREATE VIEW V
AS
SELECT ename + ' ' + CAST(deptno AS nvarchar(2)) AS data
FROM emp
SELECT * FROM V

--Обработка значений NULL при сортировке
SELECT ename,
       sal,
       comm 
FROM
  (
	  SELECT ename,
			  sal, 
			  comm, 
			  CASE
					WHEN comm IS NULL THEN 0
					ELSE 1
			  END AS is_null
	   FROM emp
   ) AS x
ORDER BY is_null DESC,
         comm DESC

--Сортировка по зависящему от данных ключу
SELECT ename,
       sal,
       job,
       comm
FROM emp
ORDER BY CASE
             WHEN job = 'SALESMAN' THEN comm
             ELSE sal
         END

SELECT ename,
       sal,
       job,
       comm,
	   CASE
             WHEN job = 'SALESMAN' THEN comm
             ELSE sal
         END
FROM emp
ORDER BY 5
