DECLARE @pct AS FLOAT = 0.5;

SELECT testid, score,
		PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentiledisc,
		PERCENTILE_CONT(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentilecont
FROM Stats.Scores

DECLARE @pct AS FLOAT = 0.5;

SELECT testid,
		PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentiledisc,
		PERCENTILE_CONT(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentilecont
FROM Stats.Scores
GROUP BY testid

DECLARE @pct AS FLOAT = 0.5;

SELECT DISTINCT testid,
		PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentiledisc,
		PERCENTILE_CONT(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentilecont
FROM Stats.Scores

DECLARE @pct AS FLOAT = 0.5;
WITH C AS 
(
	SELECT DISTINCT testid,
		PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentiledisc,
		PERCENTILE_CONT(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentilecont,
		ROW_NUMBER() OVER(PARTITION BY testid ORDER BY (SELECT NULL)) AS rownum
	FROM Stats.Scores
)
SELECT testid, percentiledisc, percentilecont
FROM C
WHERE rownum = 1


DECLARE @pct AS FLOAT = 0.5;

SELECT TOP (1) WITH TIES testid,
		PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentiledisc,
		PERCENTILE_CONT(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testid) AS percentilecont
FROM Stats.Scores
ORDER BY ROW_NUMBER() OVER(PARTITION BY testid ORDER BY (SELECT NULL))


DECLARE @pct AS FLOAT = 0.5;
WITH C AS 
(
	SELECT testid, score,
		ROW_NUMBER() OVER(PARTITION BY testid ORDER BY score) AS np,
		COUNT(*) OVER(PARTITION BY testid) AS nr		
	FROM Stats.Scores
)
SELECT testid, MIN(score) AS percentiledisc
FROM C
WHERE 1.0 * np / nr >= @pct
GROUP BY testid



DECLARE @pct AS FLOAT = 0.5;
WITH C1 AS 
(
	SELECT testid, score,
		ROW_NUMBER() OVER(PARTITION BY testid ORDER BY score) - 1 AS rownum,
		@pct * (COUNT(*) OVER(PARTITION BY testid)- 1) AS a	
	FROM Stats.Scores
),
C2 AS
(
	SELECT testid, score, a-FLOOR(a) AS factor
	FROM C1
	WHERE rownum IN (FLOOR(a), CEILING(a))
)
SELECT testid, MIN(score) + factor * (MAX(score) - MIN(score)) AS percentilecont
FROM C2
GROUP BY testid, factor