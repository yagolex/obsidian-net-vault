# Complex many to many joins

Рассмотрим **более сложный пример**, где участвует **связь "многие ко многим"**, которая обычно реализуется через **связующую (промежуточную) таблицу**.
## 📚 Сценарий: Курсы и студенты:

**Таблица `Students`:**

| StudentID | Name    |
| --------- | ------- |
| 1         | Alice   |
| 2         | Bob     |
| 3         | Charlie |

**Таблица `Courses`:**

|CourseID|Title|
|---|---|
|101|Math|
|102|History|
|103|Computer Science|

**Таблица `Enrollments` (связующая):**

|StudentID|CourseID|
|---|---|
|1|101|
|1|103|
|2|101|
|3|999|

## INNER JOIN:
**Задача:** Получить имена студентов и названия курсов, на которые они записаны.
```sql
SELECT s.Name, c.Title
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

```

**Результат:**

| Name  | Title            |
| ----- | ---------------- |
| Alice | Math             |
| Alice | Computer Science |
| Bob   | Math             |

> 🎯 `Charlie` не попал в результат, потому что `CourseID = 999` не существует в таблице `Courses`. Только полные совпадения.

## `LEFT JOIN` (Студенты и их курсы, даже если курса нет):
```sql
SELECT s.Name, c.Title
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;
```

**Результат:**

|Name|Title|
|---|---|
|Alice|Math|
|Alice|Computer Science|
|Bob|Math|
|Charlie|NULL|

> 🎯 Все студенты возвращаются. У Charlie нет валидного курса — `Title = NULL`.

## `RIGHT JOIN` (Все курсы и студенты, если записаны):

```sql
SELECT s.Name, c.Title
FROM Courses c
RIGHT JOIN Enrollments e ON c.CourseID = e.CourseID
RIGHT JOIN Students s ON e.StudentID = s.StudentID;
```

**Результат:**

| Name    | Title            |
| ------- | ---------------- |
| Alice   | Math             |
| Alice   | Computer Science |
| Bob     | Math             |
| Charlie | NULL             |

> 🎯 Похожий результат, но здесь акцент на записи в `Enrollments`, даже если курс не найден (`Title = NULL`).

## Вариант с `FULL OUTER JOIN` (если поддерживается):
Если твоя СУБД поддерживает `FULL OUTER JOIN` (например, PostgreSQL):

```sql
SELECT s.Name, c.Title
FROM Students s
FULL OUTER JOIN Enrollments e ON s.StudentID = e.StudentID
FULL OUTER JOIN Courses c ON e.CourseID = c.CourseID;

```

> Получим **всё-всё**: студентов без курсов, курсы без студентов, даже записи из `Enrollments`, не привязанные ни туда, ни сюда.
## Related topics:
- [[sql-joins]]



#sql #zettelkasten
