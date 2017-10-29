SELECT custid, orderdate, orderid, val,
		LAG(val) OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS prevval,
		LEAD(val) OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS nextval
FROM Sales.OrderValues

SELECT custid, orderdate, orderid,
		LAG(val, 3) OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS prev3val
FROM Sales.OrderValues

WITH OrdersRN AS 
(
	SELECT custid, orderdate, orderid, val,
		ROW_NUMBER() OVER(ORDER BY custid, orderdate, orderid) AS rn
	FROM Sales.OrderValues
)
SELECT C.custid, C.orderdate, C.orderid, C.val,
		P.val AS prevval,
		N.val AS nextval
FROM OrdersRN AS C
	LEFT OUTER JOIN OrdersRn AS P
		ON C.custid = P.custid
		AND C.rn = P.rn + 1
	LEFT OUTER JOIN OrdersRn AS N
		ON C.custid = N.custid
		AND C.rn = N.rn - 1

SELECT custid, orderdate, orderid, val,
		FIRST_VALUE(val) OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS val_firstorder,
		LAST_VALUE(val) OVER(PARTITION BY custid ORDER BY orderdate, orderid
							ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS val_lastorder
FROM Sales.OrderValues

SELECT custid, orderdate, orderid, val,
		val - FIRST_VALUE(val) OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS difffirst,
		val - LAST_VALUE(val) OVER(PARTITION BY custid ORDER BY orderdate, orderid
							ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS difflast
FROM Sales.OrderValues

WITH OrdersRN AS 
(
	SELECT custid, val,
		ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rna,
		ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate DESC, orderid DESC) AS rnd
	FROM Sales.OrderValues
),
Agg AS
(
	SELECT custid,
			MAX(CASE WHEN rna = 1 THEN val END) AS firstorderval,
			MAX(CASE WHEN rnd = 1 THEN val END) AS lastorderval,
			MAX(CASE WHEN rna = 3 THEN val END) AS thirdorderval
	FROM OrdersRN
	GROUP BY custid
)
SELECT O.custid, O.orderdate, O.orderid, O.val,
		A.firstorderval, A.lastorderval, A.thirdorderval
FROM Sales.OrderValues AS O
	INNER JOIN Agg AS A
		ON O.custid = A.custid
ORDER BY custid, orderdate, orderid