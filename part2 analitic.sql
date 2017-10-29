SELECT * FROM Stats.Scores

SELECT testid, studentid, score,
		PERCENT_RANK() OVER(PARTITION BY testid ORDER BY score) AS percentrank,
		CUME_DIST() OVER(PARTITION BY testid ORDER BY score) AS cumedist
FROM Stats.Scores

WITH C AS 
(
	SELECT testid, studentid, score,
		RANK() OVER(PARTITION BY testid ORDER BY score) AS rk,
		COUNT(*) OVER(PARTITION BY testid) AS nr
	FROM Stats.Scores
)
SELECT testid, studentid, score,
	1.0 * (rk - 1) / (nr - 1) AS percentrank,
	1.0 * (SELECT COALESCE(MIN(C2.rk) - 1, C1.nr)
			FROM C AS C2
			WHERE C2.rk > C1.rk) / nr AS cumedist
FROM C AS C1

SELECT empid, COUNT(*) AS numorders,
		PERCENT_RANK() OVER(ORDER BY COUNT(*)) AS percentrank,
		CUME_DIST() OVER(ORDER BY COUNT(*)) AS cumedist
FROM Sales.Orders
GROUP BY empid

SELECT groupcol, PERCENTILE_FUNCTION(0.5) WITHIN GROUP(ORDER BY ordcol) AS median
FROM T1
GROUP BY groupcol

DECLARE @pct AS FLOAT = 0.5
SELECT testid, score, 
		PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentiledisc,
		PERCENTILE_CONT(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentilecont
FROM Stats.Scores

