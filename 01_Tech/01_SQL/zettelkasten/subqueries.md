# Подзапросы (Subqueries)

Подзапрос — это SELECT внутри другого запроса. Бывает:
## Типы:
- Скалярные (`SELECT COUNT(*)`)
- В списке (`WHERE x IN (SELECT ...)`)
- Табличные (`FROM (SELECT ...) AS T`)


## Примеры:

### Скалярный:
```sql
SELECT Name, (SELECT MAX(Salary) FROM Salaries) AS MaxSalary
FROM Employees;
```

### В WHERE (В списке):
```sql
SELECT * FROM Products
WHERE CategoryID IN (SELECT ID FROM Categories WHERE Name = 'Books');
```

## Минусы:
- Может быть менее производительным, чем JOIN
- Может использоваться вместо CTE

## Когда использовать:
- Когда нельзя использовать JOIN
- Для изоляции логики выборки

## Связанные темы:
- [[cte-vs-temp-tables]]
- [[sql-joins]]

## 🔁 Практика и повторение
- [[subqueries_bloom]]
- [[subqueries_quiz]]

#sql #zettelkasten