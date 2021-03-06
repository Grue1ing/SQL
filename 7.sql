/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT	[custid],
--		[orderid],
--		[qty],
--		RANK() OVER(PARTITION BY custid ORDER BY qty) AS rnk,
--		DENSE_RANK() OVER(PARTITION BY custid ORDER BY qty) AS rnk
--  FROM [TSQL2012].[dbo].[Orders]


SELECT	[custid],
		[orderid],
		[qty],
		qty - MIN(qty) OVER(PARTITION BY custid ORDER BY orderdate, qty ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS diffprev1,
		qty - MIN(qty) OVER(PARTITION BY custid ORDER BY orderdate, qty ROWS BETWEEN 1 FOLLOWING AND 1 FOLLOWING) AS diffnext1,
		qty - LAG(qty) OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS diffprev2,
		qty - LEAD(qty) OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS diffnext2
FROM [TSQL2012].[dbo].[Orders]

SELECT	empid, 
		[2007] AS cnt2007, 
		[2008] AS cnt2008, 
		[2009] AS cnt2009
FROM (
	  SELECT empid, 
			 YEAR(orderdate) AS orderyear
      FROM dbo.Orders
	  ) AS D
PIVOT(COUNT(orderyear)
	FOR orderyear IN([2007], [2008], [2009])) AS P

SELECT	empid, 
		CAST(RIGHT(orderyear, 4) AS INT) AS orderyear, 
		numorders
FROM dbo.EmpYearOrders
  UNPIVOT(numorders FOR orderyear IN(cnt2007, cnt2008, cnt2009)) AS U
WHERE numorders != 0


SELECT	GROUPING_ID(empid, custid, YEAR(Orderdate)) AS groupingset,
		empid, 
		custid, 
		YEAR(Orderdate) AS orderyear, 
		SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY
  GROUPING SETS
  (
    (empid, custid, YEAR(orderdate)),
    (empid, YEAR(orderdate)),
    (custid, YEAR(orderdate))
  )