USE TSQL2012;
--RANK
SELECT custid, val,
		RANK() OVER(PARTITION BY custid ORDER BY val) AS rnk
FROM Sales.OrderValues

--fail
DECLARE @val AS NUMERIC(12, 2) = 1000.00
SELECT custid,
		RANK() WITHIN GROUP(ORDER BY val) AS rnk
FROM Sales.OrderValues
GROUP BY custid;


DECLARE @val AS NUMERIC(12, 2) = 1000.00
SELECT custid,
		COUNT(CASE WHEN val < @val THEN 1 END) + 1 AS rnk
FROM Sales.OrderValues
GROUP BY custid;
--DENSE_RANK
--fail
DECLARE @val AS NUMERIC(12, 2) = 1000.00
SELECT custid,
		DENSE_RANK(@val) WITHIN GROUP(ORDER BY val) AS densernk
FROM Sales.OrderValues
GROUP BY custid;

DECLARE @val AS NUMERIC(12, 2) = 1000.00
SELECT custid,
		COUNT(DISTINCT CASE WHEN val < @val THEN val END) + 1 AS densernk
FROM Sales.OrderValues
GROUP BY custid;

--PERCENT_RANK
--fali
DECLARE @score AS TINYINT = 80
SELECT testid,
		PERCENT_RANK(@score) WITHIN GROUP(ORDER BY score) AS pctrank
FROM Stats.Scores
GROUP BY testid;

DECLARE @score AS TINYINT = 80;
WITH C AS 
(
	SELECT testid,
			COUNT(CASE WHEN score < @score THEN 1 END) + 1 AS rk,
			COUNT(*) + 1 AS nr
	FROM Stats.Scores
	GROUP BY testid
)
SELECT testid, 1.0 * (rk - 1) / (nr - 1) AS pctrank
FROM C

--CUME_DIST
--fali
DECLARE @score AS TINYINT = 80
SELECT testid,
		CUME_DIST(@score) WITHIN GROUP(ORDER BY score) AS cumedist
FROM Stats.Scores
GROUP BY testid;

DECLARE @score AS TINYINT = 80;
WITH C AS 
(
	SELECT testid,
			COUNT(CASE WHEN score <= @score THEN 1 END) + 1 AS np,
			COUNT(*) + 1 AS nr
	FROM Stats.Scores
	GROUP BY testid
)
SELECT testid, 1.0 * np / nr AS cumedist
FROM C

--обобщенное решение
SELECT <partition_col>, wf AS osf
FROM <partition_table> AS P
	CROSS APPLY (SELECT <window_function>() OVER(ORDER BY <ord_col>) AS wf, return_flag
				FROM (SELECT <ord_col>, 0 AS return_flag
					  FROM <details_table> AS D
					  WHERE D.<partition_col> = P.<partition_col>
					  
					  UNION ALL

					  SELECT @input_val, 1) AS D) AS A
WHERE return_flag = 1

DECLARE @val AS NUMERIC(12, 2) = 1000.00

SELECT custid, rnk, densernk
FROM Sales.Customers AS P
	CROSS APPLY (SELECT RANK() OVER(ORDER BY val) AS rnk, 
						DENSE_RANK() OVER(ORDER BY val) AS densernk, 
						return_flag
				FROM (SELECT val, 0 AS return_flag
					  FROM Sales.OrderValues AS D
					  WHERE D.custid = P.custid
					  
					  UNION ALL

					  SELECT @val, 1) AS U) AS A
WHERE return_flag = 1

DECLARE @score AS TINYINT = 80

SELECT testid, pctrank, cumedist
FROM Stats.Tests AS P
	CROSS APPLY (SELECT PERCENT_RANK() OVER(ORDER BY score) AS pctrank, 
						CUME_DIST() OVER(ORDER BY score) AS cumedist, 
						return_flag
				FROM (SELECT score, 0 AS return_flag
					  FROM Stats.Scores AS D
					  WHERE D.testid = P.testid
					  
					  UNION ALL

					  SELECT @score, 1) AS U) AS A
WHERE return_flag = 1


DECLARE @val AS NUMERIC(12, 2) = 1000.00

SELECT custid, rnk, densernk
FROM Sales.Customers AS P
	CROSS APPLY (SELECT RANK() OVER(ORDER BY val) AS rnk, 
						DENSE_RANK() OVER(ORDER BY val) AS densernk, 
						return_flag
				FROM (SELECT val, 0 AS return_flag
					  FROM Sales.OrderValues AS D
					  WHERE D.custid = P.custid
					  
					  UNION ALL

					  SELECT @val, 1) AS U) AS A
WHERE return_flag = 1
	AND EXISTS (SELECT * FROM Sales.OrderValues AS D
				WHERE D.custid = P.custid)