SELECT custid, orderid, val,
		FIRST_VALUE(val) OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS val_firstorder,
		LAST_VALUE(val) OVER(PARTITION BY custid ORDER BY orderdate, orderid ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS val_lasorder
FROM Sales.OrderValues

WITH C AS 
(
	SELECT custid, orderid, val,
		FIRST_VALUE(val) OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS val_firstorder,
		LAST_VALUE(val) OVER(PARTITION BY custid ORDER BY orderdate, orderid ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS val_lastorder,
		ROW_NUMBER() OVER(PARTITION BY custid ORDER BY (SELECT NULL)) AS rownum
	FROM Sales.OrderValues
)
SELECT custid, val_firstorder, val_lastorder
FROM C
WHERE rownum = 1

WITH OrdersRN AS 
(
	SELECT custid, val,
		ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rna,
		ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate DESC, orderid DESC) AS rnd
	FROM Sales.OrderValues
)
SELECT custid,
		MAX(CASE WHEN rna = 1 THEN val END) AS firstorerval,
		MAX(CASE WHEN rna = 1 THEN val END) AS lastorerval,
		MAX(CASE WHEN rna = 3 THEN val END) AS thirdorerval
FROM OrdersRN
GROUP BY custid


SELECT custid,
		CONVERT(CHAR(8), orderdate, 112) + STR(orderid, 10) + STR(val, 14, 2) 
		COLLATE Latin1_General_BIN2 AS s
FROM Sales.OrderValues

WITH C AS 
(
	SELECT custid,
		CONVERT(CHAR(8), orderdate, 112) + STR(orderid, 10) + STR(val, 14, 2) 
		COLLATE Latin1_General_BIN2 AS s
	FROM Sales.OrderValues
)
SELECT custid,
		CAST(SUBSTRING(MIN(s), 19, 14) AS NUMERIC(12, 2)) AS firstorderval,
		CAST(SUBSTRING(MAX(s), 19, 14) AS NUMERIC(12, 2)) AS lastorderval
FROM C
GROUP BY custid


WITH C AS 
(
	SELECT custid,
		CONVERT(CHAR(8), orderdate, 112) 
		+ CASE SIGN(orderid) WHEN -1 THEN '0' ELSE '1' END
		--отрицательные величины сортируются до неотрицательных
		+ STR(CASE SIGN(orderid) 
				WHEN -1 THEN 2147383648 
				--к отриицательным величинам добавляем ABS(minnegative)
				ELSE 0 END + orderid, 10)
		+ STR(val, 14, 2)
		COLLATE Latin1_General_BIN2 AS s
	FROM Sales.OrderValues
)
SELECT custid,
		CAST(SUBSTRING(MIN(s), 19, 14) AS NUMERIC(12, 2)) AS firstorderval,
		CAST(SUBSTRING(MAX(s), 19, 14) AS NUMERIC(12, 2)) AS lastorderval
FROM C
GROUP BY custid