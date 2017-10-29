SELECT	orderid, val,
		ROW_NUMBER() OVER(ORDER BY orderid) AS rownum
FROM Sales.OrderValues

SELECT	orderid, val,
		ROW_NUMBER() OVER(ORDER BY orderid) AS rownum
FROM Sales.OrderValues
ORDER BY rownum

SELECT	orderid, val,
		ROW_NUMBER() OVER(ORDER BY orderid) AS rownum
FROM Sales.OrderValues
ORDER BY val DESC

SELECT	orderid, val,
		COUNT(*) OVER(ORDER BY orderid ROWS UNBOUNDED PRECEDING) AS rownum
FROM Sales.OrderValues

SELECT	orderid, val,
		(SELECT	COUNT(*)
		FROM Sales.OrderValues AS O2
		WHERE O2.orderid <= O1.orderid) AS rownum
FROM Sales.OrderValues AS O1

SELECT	orderid, orderdate, val,
		ROW_NUMBER() OVER(ORDER BY orderdate DESC) AS rownum
FROM Sales.OrderValues


SELECT	orderid, orderdate, val,
		ROW_NUMBER() OVER(ORDER BY orderdate DESC, orderid DESC) AS rownum
FROM Sales.OrderValues


SELECT	orderdate, orderid, val,
		(SELECT	COUNT(*)
		FROM Sales.OrderValues AS O2
		WHERE O2.orderdate >= O1.orderdate
		AND ( O2.orderdate > O1.orderdate
			OR O2.orderid >= O1.orderid)) AS rownum
FROM Sales.OrderValues AS O1
--fail
SELECT	orderid, orderdate, val,
		ROW_NUMBER() OVER() AS rownum
FROM Sales.OrderValues
--fail
SELECT	orderid, orderdate, val,
		ROW_NUMBER() OVER(ORDER BY NULL) AS rownum
FROM Sales.OrderValues

SELECT	orderid, orderdate, val,
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
FROM Sales.OrderValues

SELECT	orderid, val,
		ROW_NUMBER() OVER(ORDER BY val) AS rownum,
		NTILE(10) OVER(ORDER BY val) AS tile
FROM Sales.OrderValues

SELECT	orderid, val,
		ROW_NUMBER() OVER(ORDER BY val, orderid) AS rownum,
		NTILE(10) OVER(ORDER BY val, orderid) AS tile
FROM Sales.OrderValues

SELECT	orderid, val,
		ROW_NUMBER() OVER(ORDER BY val, orderid) AS rownum,
		NTILE(100) OVER(ORDER BY val, orderid) AS tile
FROM Sales.OrderValues

DECLARE @cnt AS INT = 830, @numtiles AS INT = 100, @rownum AS INT = 42;

WITH C1 AS
(
	SELECT
		@cnt / @numtiles AS basetilesize,
		@cnt / @numtiles + 1 AS extendedtilesize,
		@cnt % @numtiles AS remainder
),
C2 AS
(
	SELECT *, extendedtilesize * remainder AS cutoffrow
	FROM C1
)
SELECT 
	CASE WHEN @rownum <= cutoffrow
		THEN (@rownum - 1) / extendedtilesize + 1
		ELSE remainder + ((@rownum - cutoffrow) - 1) / basetilesize + 1
	END AS tile
FROM C2;

DECLARE @numtiles AS INT = 100;

WITH C1 AS
(
	SELECT
		COUNT(*) / @numtiles AS basetilesize,
		COUNT(*) / @numtiles + 1 AS extendedtilesize,
		COUNT(*) % @numtiles AS remainder
),
C2 AS
(
	SELECT *, extendedtilesize * remainder AS cutoffrow
	FROM C1
),
C3 AS 
(
	SELECT O1.orderid, O1.val,
			(SELECT COUNT(*)
			FROM Sales.OrderValues AS O2
			WHERE O2.val <= O1.val
			AND (O2.val < O1.val
				OR O2.orderid <= O1.orderid)) AS rownum
	FROM Sales.OrderValues AS O1
)
SELECT C3.*,
	CASE WHEN C3.rownum <= C2.cutoffrow
		THEN (C3.rownum - 1) / C2.extendedtilesize + 1
		ELSE C2.remainder + ((C3.rownum - C2.cutoffrow) - 1) / C2.basetilesize + 1
	END AS tile
FROM C3 CROSS JOIN C2;

SELECT orderid, orderdate, val,
		ROW_NUMBER() OVER(ORDER BY orderdate DESC) AS rownum,
		RANK() OVER(ORDER BY orderdate DESC) AS rnk,
		DENSE_RANK() OVER(ORDER BY orderdate DESC) AS drnk
FROM Sales.OrderValues

SELECT orderid, orderdate, val,
		(SELECT COUNT(*)
		FROM Sales.OrderValues AS O2
		WHERE O2.orderdate > O1.orderdate) + 1 AS rnk,
		(SELECT COUNT(DISTINCT orderdate)
		FROM Sales.OrderValues AS O2
		WHERE O2.orderdate > O1.orderdate) + 1 AS drnk
FROM Sales.OrderValues AS O1




