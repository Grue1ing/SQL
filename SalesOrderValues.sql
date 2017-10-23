SELECT	orderid,
		orderdate,
		val,
		RANK() OVER(ORDER BY val DESC) AS rnk
FROM Sales.OrderValues
--ORDER BY rnk


SELECT	orderid,
		custid,
		val,
		CAST(100. * val / SUM(val) OVER (PARTITION BY custid) AS NUMERIC(5, 2)) AS pctcust,
		val - AVG(val) OVER (PARTITION BY custid) AS diffcust,
		CAST(100. * val / SUM(val) OVER () AS NUMERIC(5, 2)) AS pctcust,
		val - AVG(val) OVER () AS diffcust
FROM	Sales.OrderValues
WHERE	orderdate >= '20070101'
  AND	orderdate < '20080101'


SELECT	custid,
		orderid,
		val,
		RANK() OVER (ORDER BY val DESC) AS rnk_all,
		RANK() OVER (PARTITION BY custid ORDER BY val DESC) AS rnk_cust 
FROM	Sales.OrderValues