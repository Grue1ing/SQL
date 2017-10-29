SET NOCOUNT ON;
USE TSQL2012;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO
CREATE TABLE dbo.T1
(
	keycol INT NOT NULL CONSTRAINT PK_T1 PRIMARY KEY,
	col1 VARCHAR(10) NOT NULL
);

INSERT INTO dbo.T1 VALUES
	(2, 'A'), (3, 'A'),
	(5, 'B'), (7, 'B'), (11, 'B'),
	(13, 'C'), (17, 'C'), (19, 'C'), (23, 'C');

SELECT keycol, col1,
		COUNT(*) OVER(ORDER BY col1 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cnt
FROM dbo.T1 

CREATE UNIQUE INDEX idx_col1D_keycol ON dbo.T1(col1 DESC, keycol);


SELECT keycol, col1,
		COUNT(*) OVER(ORDER BY col1 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cnt
FROM dbo.T1 


SELECT keycol, col1,
		COUNT(*) OVER(ORDER BY col1, keycol ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cnt
FROM dbo.T1 