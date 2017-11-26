-- Запросы на получение метаданных

-- Как получить список таблиц схемы
SELECT table_name
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'

-- Как получить список столбцов таблицы
SELECT COLUMN_NAME, DATA_TYPE, ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
	AND TABLE_NAME = 'emp'

-- Как получить список индексированных столбцов таблицы
SELECT	a.name AS table_name,
		b.name AS index_name,
		d.name AS column_name,
		c.index_column_id
FROM sys.tables AS a,
	 sys.indexes AS b,
	 sys.index_columns AS c,
	 sys.columns AS d
WHERE	a.object_id = b.object_id
	AND b.object_id = c.object_id
	AND b.index_id = c.index_id
	AND c.object_id = d.object_id
	AND c.column_id = d.column_id
	AND a.name = 'emp'

-- Как получить список ограничений, наложенных на таблицу
SELECT	a.TABLE_NAME,
		a.CONSTRAINT_NAME,
		b.COLUMN_NAME,
		a.CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS a,
	 INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS b
WHERE a.TABLE_NAME = 'emp'
  AND a.TABLE_SCHEMA = 'dbo'
  AND a.TABLE_NAME = b.TABLE_NAME
  AND a.TABLE_SCHEMA = b.TABLE_SCHEMA
  AND a.CONSTRAINT_NAME = b.CONSTRAINT_NAME

-- Как получить список внешних ключей без соответствующих индексов
SELECT fkeys.table_name,
       fkeys.constraint_name,
       fkeys.column_name,
       ind_cols.index_name
FROM
  (SELECT a.object_id,
          d.column_id,
          a.name TABLE_NAME,
          b.name CONSTRAINT_NAME,
          d.name COLUMN_NAME
   FROM sys.tables a
	INNER JOIN sys.foreign_keys AS b 
		ON a.name = 'EMP'
		AND a.object_id = b.parent_object_id
   INNER JOIN sys.foreign_key_columns AS c 
		ON b.object_id = c.constraint_object_id
   INNER JOIN sys.columns AS d 
		ON c.constraint_column_id = d.column_id
		AND a.object_id = d.object_id) fkeys
LEFT OUTER JOIN
  (
	  SELECT a.name index_name,
			  b.object_id,
			  b.column_id
	   FROM sys.indexes a,
			sys.index_columns b
	   WHERE a.index_id = b.index_id 
   ) AS ind_cols 
   ON fkeys.object_id = ind_cols.object_id
   AND fkeys.column_id = ind_cols.column_id
WHERE ind_cols.index_name IS NULL

-- Использование SQL для генерирования SQL
SELECT 'SELECT COUNT(*) FROM ' + TABLE_NAME + ';' AS CNTS
FROM INFORMATION_SCHEMA.TABLES

SELECT 'ALTER TABLE ' + TABLE_NAME + ' DISABLE CONSTRAINT ' + CONSTRAINT_NAME + ';' AS CONS,
	CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
--WHERE CONSTRAINT_TYPE = 'R'

SELECT 'INSERT INTO emp(EMPNO, ENAME, HIREDATE) ' + CHAR(10) + 
		'VALUES( ' + CAST(EMPNO AS nvarchar) + ', ''' + CAST(ENAME AS nvarchar) + 
		''', ''' + CAST(HIREDATE AS nvarchar) + ''' );' AS INSERTS
FROM emp
WHERE DEPTNO = 10

-- Описание представлений словаря данных в БД
CREATE VIEW dictonary
AS
SELECT 'emp' AS TABLE_NAME, 'Таблица с описанием работников' AS COMMENTS
UNION ALL
SELECT 'dept' AS TABLE_NAME, 'Таблица с описанием департаментов'AS COMMENTS

CREATE VIEW dict_columns 
AS
SELECT 'emp' AS TABLE_NAME, 'EMPNO' AS COLUMN_NAME, 'Номер работника' AS COMMENTS
UNION ALL
SELECT 'emp' AS TABLE_NAME, 'ENAME' AS COLUMN_NAME, 'Имя работника' AS COMMENTS
UNION ALL
SELECT 'emp' AS TABLE_NAME, 'JOB' AS COLUMN_NAME, 'Должность' AS COMMENTS
UNION ALL
SELECT 'emp' AS TABLE_NAME, 'MGR' AS COLUMN_NAME, 'Менеджер' AS COMMENTS
UNION ALL
SELECT 'emp' AS TABLE_NAME, 'HIREDATE' AS COLUMN_NAME, 'Дата приема на работу' AS COMMENTS
UNION ALL
SELECT 'emp' AS TABLE_NAME, 'SAL' AS COLUMN_NAME, 'Зарплата' AS COMMENTS
UNION ALL
SELECT 'emp' AS TABLE_NAME, 'COMM' AS COLUMN_NAME, 'Коммисионные' AS COMMENTS
UNION ALL
SELECT 'emp' AS TABLE_NAME, 'DEPTNO' AS COLUMN_NAME, 'Номер департамента' AS COMMENTS
