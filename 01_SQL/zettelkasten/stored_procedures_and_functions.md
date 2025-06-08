# Хранимые процедуры и пользовательские функции

## 📦 Хранимые процедуры (Stored Procedures):

Хранимая процедура — это **набор SQL-команд**, сохранённый в базе данных под именем, который можно вызвать в любое время. Обычно используется для **бизнес-логики**, **обновлений данных**, **модификаций**, или выполнения **целой цепочки действий**.
### Создание SP:
```sql
CREATE PROCEDURE GetStudentCourses
    @StudentID INT
AS
BEGIN
    SELECT c.Title
    FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE e.StudentID = @StudentID;
END;
```
### Вызов SP:
```sql

EXEC GetStudentCourses @StudentID = 1;

```


## Пользовательские функции (User-Defined Functions / UDF):

Пользовательская функция — это SQL-функция, возвращающая **значение или таблицу**, которую можно использовать **внутри запроса**, как любую встроенную функцию (`LEN()`, `GETDATE()`, и т. п.).

### 📌 Пример скалярной функции (возвращает одно значение):
```sql
CREATE FUNCTION dbo.GetCourseCount(@StudentID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;
    SELECT @Count = COUNT(*) FROM Enrollments WHERE StudentID = @StudentID;
    RETURN @Count;
END;

```

### Использование:
```sql
SELECT Name, dbo.GetCourseCount(StudentID) AS CourseCount
FROM Students;
```

### 📌 Пример табличной функции (возвращает таблицу):
```sql
CREATE FUNCTION dbo.GetStudentCourses(@StudentID INT)
RETURNS TABLE
AS
RETURN
    SELECT c.Title
    FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE e.StudentID = @StudentID;

```

### 🛠 Использование:
```sql
SELECT * FROM dbo.GetStudentCourses(1);
```


## 🆚 Основные отличия

| Критерий                  | Хранимая процедура                                                             | Пользовательская функция                 |
| ------------------------- | ------------------------------------------------------------------------------ | ---------------------------------------- |
| **Возвращаемое значение** | Может возвращать 0 или более значений через OUT, таблицу, SELECT, но не RETURN | Всегда возвращает значение или таблицу   |
| **Вызов из SELECT**       | ❌ Нельзя вызвать из SELECT                                                     | ✅ Можно вызвать внутри SELECT            |
| **Побочные эффекты**      | ✅ Может менять данные (INSERT, UPDATE, DELETE)                                 | ❌ Не может менять данные (только чтение) |
| **Использование в JOIN**  | ❌ Нельзя                                                                       | ✅ Табличные функции можно                |
| **Транзакции внутри**     | ✅ Да                                                                           | ❌ Нет (ограничено)                       |

## 🎯 Когда использовать?

| Сценарий                                                              | Используй                        |
| --------------------------------------------------------------------- | -------------------------------- |
| Нужно выполнить сложную логику с модификацией данных                  | 🔹 Хранимая процедура            |
| Нужно вернуть результат для использования в `SELECT`, `WHERE`, `JOIN` | 🔹 Пользовательская функция      |
| Нужно инкапсулировать бизнес-логику для переиспользования             | Оба (в зависимости от контекста) |

## Related topics:
- [[table-vars-vs-temp-tables]]
- [[cte-vs-temp-tables]]
- [[user-variables]]


#sql #zettelkasten
