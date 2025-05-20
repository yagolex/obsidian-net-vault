# Подзапросы (Subqueries)

Подзапрос — это SELECT внутри другого запроса. Бывает:
- В SELECT: скалярный
- В WHERE: фильтрация
- В FROM: табличный

## Примеры:

### Скалярный:
```sql
SELECT Name, (SELECT MAX(Salary) FROM Salaries) AS MaxSalary
FROM Employees;
```

### В WHERE:
```sql
SELECT * FROM Products
WHERE CategoryID IN (SELECT ID FROM Categories WHERE Name = 'Books');
```

## Минусы:
- Может быть менее производительным, чем JOIN
- Может использоваться вместо CTE

## Связанные темы:
- [[cte-vs-temp-tables]]
- [[sql-joins]]

## 🔁 Практика и повторение
- [[subqueries_bloom]]
- [[subqueries_quiz]]

#sql #zettelkasten