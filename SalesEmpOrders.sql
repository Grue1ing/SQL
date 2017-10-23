SELECT	empid,
		ordermonth,
		qty,
		SUM(qty) OVER (PARTITION BY empid ORDER BY ordermonth ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runqty
FROM	Sales.EmpOrders