IF DATENAME(weekday, GETDATE()) IN (N'�������', N'�����������')
       SELECT N'��������';
ELSE 
       SELECT N'������';
