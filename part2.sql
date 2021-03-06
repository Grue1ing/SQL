SELECT	orderid,
		custid,
		val,
		SUM(val) OVER() AS sumall,
		SUM(val) OVER(PARTITION BY custid) AS sumcust
FROM	Sales.OrderValues

SELECT	orderid,
		custid,
		val,
		CAST(100. * val / SUM(val) OVER() AS NUMERIC(5, 2)) AS pctall,
		CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5, 2)) AS pctcust
FROM	Sales.OrderValues 

SELECT	empid,
		ordermonth,
		qty,
		SUM(qty) OVER(PARTITION BY empid 
					  ORDER BY ordermonth 
					  ROWS BETWEEN UNBOUNDED PRECEDING 
							   AND CURRENT ROW) AS runqty
FROM	Sales.EmpOrders


SELECT	empid,
		ordermonth,
		qty,
		SUM(qty) OVER(PARTITION BY empid 
					  ORDER BY ordermonth 
					  ROWS UNBOUNDED PRECEDING) AS runqty
FROM	Sales.EmpOrders


SELECT	empid,
		ordermonth,
		MAX(qty) OVER(PARTITION BY empid
					  ORDER BY ordermonth
					  ROWS BETWEEN 1 PRECEDING
							   AND 1 PRECEDING) AS prvqty,
		qty AS curqty,
		MAX(qty) OVER(PARTITION BY empid
					  ORDER BY ordermonth
					  ROWS BETWEEN 1 FOLLOWING
							   AND 1 FOLLOWING) AS nxtqty,
		AVG(qty) OVER(PARTITION BY empid
					  ORDER BY ordermonth
					  ROWS BETWEEN 1 PRECEDING
							   AND 1 FOLLOWING) AS avgqty
FROM	Sales.EmpOrders

--fail
SELECT	empid,
		ordermonth,
		qty,
		SUM(qty) OVER(PARTITION BY empid
					  ORDER BY ordermonth
					  ROWS BETWEEN INTERVAL '2' MONTH PRECEDING
							   AND CURRENT ROW) AS sum3month
FROM	Sales.EmpOrders

SELECT empid, ordermonth, qty,
		(SELECT SUM(qty)
		FROM Sales.EmpOrders AS O2
		WHERE O2.empid = O1.empid
		AND O2.ordermonth BETWEEN DATEADD(month, -2, O1.ordermonth)
							AND O1.ordermonth) AS sum3month
FROM Sales.EmpOrders AS O1

SELECT empid, ordermonth, qty,
		SUM(qty) OVER(PARTITION BY empid ORDER BY ordermonth RANGE BETWEEN UNBOUNDED PRECEDING
							AND CURRENT ROW) AS runqty
FROM Sales.EmpOrders

SELECT empid, ordermonth, qty,
		SUM(qty) OVER(PARTITION BY empid ORDER BY ordermonth RANGE UNBOUNDED PRECEDING) AS runqty
FROM Sales.EmpOrders

SELECT empid, ordermonth, qty,
		SUM(qty) OVER(PARTITION BY empid ORDER BY ordermonth) AS runqty
FROM Sales.EmpOrders

SELECT keycol, col1,
		COUNT(*) OVER(ORDER BY col1 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cnt
FROM dbo.T1
SELECT keycol, col1,
		COUNT(*) OVER(ORDER BY col1 RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cnt
FROM dbo.T1

--EXCLUDE NO OTHERS
SELECT keycol, col1,
		COUNT(*) OVER(ORDER BY col1 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW EXCLUDE NO OTHERS) AS cnt
FROM dbo.T1

--EXCLUDE CURRENT ROW
SELECT keycol, col1,
		COUNT(*) OVER(ORDER BY col1 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW EXCLUDE CURRENT ROW) AS cnt
FROM dbo.T1

--EXCLUDE GROUP
SELECT keycol, col1,
		COUNT(*) OVER(ORDER BY col1 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW EXCLUDE GROUP) AS cnt
FROM dbo.T1

--EXCLUDE TIES
SELECT keycol, col1,
		COUNT(*) OVER(ORDER BY col1 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW EXCLUDE TIES) AS cnt
FROM dbo.T1

SELECT empid, ordermonth, qty,
		qty - AVG(qty) FILTER (WHERE ordermonth <= DATEADD(month, -3, CURRENT_TIMESTAMP)) OVER(PARTITION BY empid) AS diff
FROM Sales.EmpOrders

SELECT empid, ordermonth, qty,
		qty - AVG(CASE WHEN ordermonth <= DATEADD(month, -3, CURRENT_TIMESTAMP) THEN qty END) OVER(PARTITION BY empid) AS diff
FROM Sales.EmpOrders

SELECT orderid, orderdate, empid, custid, val,
		val - AVG(val)
		FILTER (WHERE custid <> $current_row.custid)
		OVER(PARTITION BY empid) AS diff
FROM Sales.OrderValues

SELECT orderid, orderdate, empid, custid, val,
		val - AVG(CASE WHEN custid <> $current_row.custid THEN val END)
		OVER(PARTITION BY empid) AS diff
FROM Sales.OrderValues

SELECT  empid, orderdate, orderid, val,
		COUNT(DISTINCT custid) OVER(PARTITION BY empid ORDER BY orderdate) AS numcusts
FROM Sales.OrderValues

SELECT  empid, orderdate, orderid, custid, val,
		CASE 
			WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid ORDER BY orderdate) = 1
			THEN custid
		END AS distict_custid
FROM Sales.OrderValues

WITH C AS 
(
	SELECT empid, orderdate, orderid, custid, val,
		CASE 
			WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid ORDER BY orderdate) = 1
			THEN custid
		END AS distinct_custid
	FROM Sales.OrderValues
)
SELECT empid, orderdate, orderid, val,
		COUNT(distinct_custid) OVER(PARTITION BY empid ORDER BY orderdate) AS numcusts
FROM C;

SELECT empid,
		SUM(val) AS emptotal,
		SUM(val) / SUM(SUM(val)) OVER() * 100. AS pct
FROM Sales.OrderValues
GROUP BY empid

WITH C AS 
(
	SELECT empid,
		SUM(val) AS emptotal
	FROM Sales.OrderValues
	GROUP BY empid
)
SELECT empid, emptotal,
		emptotal / SUM(emptotal) OVER() * 100. AS pct
FROM C

--fail
WITH C AS 
(
	SELECT empid, orderdate, 
		CASE 
			WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid ORDER BY orderdate) = 1
			THEN custid
		END AS distinct_custid
	FROM Sales.Orders
)
SELECT empid, orderdate,
		COUNT(distinct_custid) OVER(PARTITION BY empid ORDER BY orderdate) AS numcusts
FROM C
GROUP BY empid, orderdate;

WITH C AS 
(
	SELECT empid, orderdate, 
		CASE 
			WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid ORDER BY orderdate) = 1
			THEN custid
		END AS distinct_custid
	FROM Sales.Orders
)
SELECT empid, orderdate,
		SUM(COUNT(distinct_custid)) OVER(PARTITION BY empid ORDER BY orderdate) AS numcusts
FROM C
GROUP BY empid, orderdate;










