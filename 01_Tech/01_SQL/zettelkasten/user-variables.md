# Пользовательские переменные

Это переменные, объявленные и используемые **внутри тела хранимой процедуры или пользовательской функции**. Они **начинаются с `@`** и имеют **определённый тип данных**. Возможен даже табличный тип данных, см: [[table-vars-vs-temp-tables]].

## 🛠 Синтаксис объявления переменной:
```sql
DECLARE @VariableName DataType;
```

## 🛠 📌 Пример:
```sql
DECLARE @Counter INT;
DECLARE @Name NVARCHAR(100);
DECLARE @Today DATE;

```

## 🔄 Присваивание значений:

Ты можешь присваивать значения переменным непосредственно:
```sql
SET @Counter = 1;
SET @Name = 'Alice';
SET @Today = GETDATE();
```

Или опосредованно, через `SELECT`:
```sql
SELECT @Name = Name
FROM Students
WHERE StudentID = 1;

```


## 🛠 🧮 Использование в арифметике и логике:
```sql
SET @Counter = @Counter + 1;

IF @Counter > 10
BEGIN
    PRINT 'Done';
END

```


## 🛠 📦 Использование переменных в хранимой процедуре:
```sql
CREATE PROCEDURE CheckStudentEnrollment
    @StudentID INT
AS
BEGIN
    DECLARE @CourseCount INT;

    SELECT @CourseCount = COUNT(*)
    FROM Enrollments
    WHERE StudentID = @StudentID;

    IF @CourseCount = 0
        PRINT 'Student is not enrolled in any courses.';
    ELSE
        PRINT 'Student is enrolled in ' + CAST(@CourseCount AS VARCHAR) + ' course(s).';
END;

```

🔄 Вызов:
```sql

EXEC CheckStudentEnrollment @StudentID = 1;

```


## 🧮 🛠 Использование переменных в пользовательской функции (UDF):

Функции — более ограничены: только **локальные переменные**, и они **не могут менять данные**.

```sql
CREATE FUNCTION dbo.IsEnrolled(@StudentID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT;

    IF EXISTS (
        SELECT 1 FROM Enrollments WHERE StudentID = @StudentID
    )
        SET @Result = 1;
    ELSE
        SET @Result = 0;

    RETURN @Result;
END;
```

## ⚠️ Важно знать:

| Особенность                                                                    | Поведение                                           |
| ------------------------------------------------------------------------------ | --------------------------------------------------- |
| Внутренние переменные видны только внутри функции/процедуры                    | 🔒 Изолированная область                            |
| Инициализация не обязательна при объявлении                                    | Но желательно присваивать значение до использования |
| В функциях нельзя использовать `PRINT`, `RAISERROR` и другие побочные действия | Только вычисления и возврат результата              |

## Related topics:
- [[stored_procedures_and_functions]]
- [[table-vars-vs-temp-tables]] (**Таблицы-переменные** и временные таблицы)


#sql #zettelkasten
