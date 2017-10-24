SET NOCOUNT ON;
USE TSQL2012;

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO

CREATE TABLE dbo.T1
(
	col1 INT NULL,
	col2 VARCHAR(10) NOT NULL
);

INSERT INTO dbo.T1(col2)
	VALUES('C'), ('A'), ('B'), ('A'), ('C'), ('B');
GO

WITH C AS
(
	SELECT	col1,
			col2,
			ROW_NUMBER() OVER(ORDER BY col2) AS rownum
	FROM dbo.T1
)
UPDATE C
	SET col1 = rownum

SELECT	col1,
		col2
FROM dbo.T1