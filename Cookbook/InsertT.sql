DECLARE @I int = 1

WHILE (@I) <= 500
BEGIN
   INSERT INTO t500
		VALUES (@I)
   IF (SELECT MAX(ID) FROM t500) >= 500
      BREAK
   ELSE
		SET @I = @I + 1
      CONTINUE
END