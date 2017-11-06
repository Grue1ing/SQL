USE TSQL2012;

IF OBJECT_ID('dbo.EmpYearOrders', 'U') IS NOT NULL DROP TABLE dbo.EmpYearOrders;

CREATE TABLE dbo.EmpYearOrders
(
  empid INT NOT NULL CONSTRAINT PK_EmpYearOrders PRIMARY KEY,
  cnt2007 INT NULL,
  cnt2008 INT NULL,
  cnt2009 INT NULL
);

INSERT INTO dbo.EmpYearOrders(empid, cnt2007, cnt2008, cnt2009)
  SELECT empid, 
		[2007] AS cnt2007, 
		[2008] AS cnt2008, 
		[2009] AS cnt2009
  FROM (
	    SELECT empid, 
			   YEAR(orderdate) AS orderyear
        FROM dbo.Orders
		) AS D
  PIVOT(COUNT(orderyear)
	FOR orderyear IN([2007], [2008], [2009])) AS P;

SELECT * FROM dbo.EmpYearOrders;