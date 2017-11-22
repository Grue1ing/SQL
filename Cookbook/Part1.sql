--Извлечение всех строк и столбцов из таблицы
SELECT * 
FROM emp

SELECT empno, ename, job, sal, mgr, hiredate, comm, deptno
FROM emp
--Извлечение подмножества строк из таблицы
SELECT * 
FROM emp
WHERE deptno = 10
--Выбор строк по нескольким условиям
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
--Извлечение подмножества столбцов из таблицы
SELECT ename,deptno,sal
FROM emp
--Как задать столбцам значимые имена
SELECT sal as salary, comm as commission
FROM emp
--Обращение к столбцу в предикате WHERE по псевдониму
SELECT *
FROM
  ( SELECT sal AS salary,
           comm AS commission
   FROM emp ) AS x
WHERE salary < 5000

--Конкатенация значений столбцов
SELECT ename + ' WORKS AS A ' + job AS msg
FROM emp
WHERE deptno=10
--Использование условной логики в выражении SELECT
SELECT ename,
       sal,
       CASE
           WHEN sal <= 2000 THEN 'UNDERPAID'
           WHEN sal >= 4000 THEN 'OVERPAID'
           ELSE 'OK'
       END AS status
FROM emp
--Ограничение числа возвращаемых строк
SELECT TOP 5 *
FROM emp
--Возвращение n случайных записей таблицы
SELECT TOP 5 ename,
           job
FROM emp
ORDER BY newid()
--Поиск значений NULL
SELECT *
FROM emp
WHERE comm IS NULL
--Преобразование значений NULL в неNULL значения
SELECT COALESCE(comm,0)
FROM emp

SELECT CASE
           WHEN comm IS NULL THEN 0
           ELSE comm
       END
FROM emp
--Поиск по шаблону
SELECT ename,
       job
FROM emp
WHERE deptno IN (10, 20)
  AND (ename LIKE '%I%' OR job LIKE '%ER')