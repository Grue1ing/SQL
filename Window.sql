SELECT	empid,
		ordermonth,
		qty,
		SUM(qty) OVER W1 AS run_sum_qty,
		AVG(qty) OVER W1 AS run_sum_qty,
		MIN(qty) OVER W1 AS run_sum_qty,
		MAX(qty) OVER W1 AS run_sum_qty,
FROM Sales.EmpOrders
WINDOW W1 AS (PARTITION BY empid ORDER BY ordermonth ROWS BETWEEN UNBOUNDED PRECEDING AND CURREN ROW);