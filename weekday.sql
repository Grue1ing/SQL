IF DATENAME(weekday, GETDATE()) IN (N'суббота', N'воскресенье')
       SELECT N'Выходной';
ELSE 
       SELECT N'Будний';
