# **Табличные переменные** и **Переменные курсоров**

**табличные переменные**, и **переменные курсоров**. Они — мощные инструменты в SQL для сложной обработки данных внутри **процедур** и иногда — **функций** (табличные переменные, не курсоры).

## 📑 Часть 1: Таблицы-переменные (`@TableVar`):

Это как обычная переменная табличного типа или как временная таблица, но живет **только в рамках текущего блока кода** (например, внутри процедуры).

🧠 Полезно:
- Удобна для **фильтрации**, **агрегации**, **сортировки** промежуточных результатов.    
- Работает быстрее, чем временные таблицы (`#temp`) при небольших объёмах данных.
### 📌 Пример: таблица-переменная для хранения промежуточных данных:
```sql
DECLARE @TopStudents TABLE (
    StudentID INT,
    Name NVARCHAR(100),
    CourseCount INT
);

INSERT INTO @TopStudents (StudentID, Name, CourseCount)
SELECT s.StudentID, s.Name, COUNT(e.CourseID)
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.Name
HAVING COUNT(e.CourseID) >= 2;

-- Используем таблицу
SELECT * FROM @TopStudents;

```

## 📑 Часть 2: Курсоры и переменные курсоров:

Курсоры позволяют **пошагово обрабатывать строки**, как цикл в императивном языке.

> ⚠️ Курсоры следует использовать **только тогда**, когда не получается выразить логику через обычные `SELECT`, `JOIN`, `UPDATE`..

### 📌 Пример: курсор по списку студентов:
```sql
DECLARE @StudentID INT;
DECLARE @Name NVARCHAR(100);

DECLARE student_cursor CURSOR FOR
SELECT StudentID, Name
FROM Students;

OPEN student_cursor;

FETCH NEXT FROM student_cursor INTO @StudentID, @Name;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Student: ' + @Name + ' (ID: ' + CAST(@StudentID AS NVARCHAR) + ')';

    -- можно здесь выполнять вложенные запросы, вставки и т.д.

    FETCH NEXT FROM student_cursor INTO @StudentID, @Name;
END;

CLOSE student_cursor;
DEALLOCATE student_cursor;

```

### 📌Возможности:

| Команда          | Описание                                   |
| ---------------- | ------------------------------------------ |
| `DECLARE cursor` | Объявление курсора                         |
| `OPEN`           | Открывает курсор для чтения                |
| `FETCH NEXT`     | Получает следующую строку                  |
| `CLOSE`          | Закрывает курсор                           |
| `DEALLOCATE`     | Освобождает память                         |
| `@@FETCH_STATUS` | Возвращает статус последней операции FETCH |


## 📑 Часть 3: Таблица против курсора: что выбрать?

|Задача|Рекомендуемый инструмент|
|---|---|
|Массовая обработка и фильтрация данных|✅ Табличная переменная|
|Обработка строки за строкой (сложная логика, динамика)|✅ Курсор (с осторожностью)|
|Работа с большими объемами данных|❌ Курсоры могут тормозить|
|Использование в UDF-функциях|✅ Только табличные переменные|


## Related topics:
- [[user-variables]]
- [[table-vars-vs-temp-tables]]


#sql #zettelkasten
