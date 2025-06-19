# Рекурсивные запросы

Рекурсивные CTE позволяют выполнять иерархические запросы.

## Пример:
```sql
WITH Subordinates AS (
  SELECT EmployeeID, ManagerID FROM Employees WHERE ManagerID IS NULL
  UNION ALL
  SELECT e.EmployeeID, e.ManagerID
  FROM Employees e
  JOIN Subordinates s ON e.ManagerID = s.EmployeeID
)
SELECT * FROM Subordinates;
```

## Ограничения:
- Требует `UNION ALL`
- Используется `OPTION (MAXRECURSION ...)` при глубокой вложенности

## Связанные темы:
- [[cte-vs-temp-tables]]
- [[subqueries]]

## 🔁 Практика и повторение
- [[recursive-queries_bloom]]
- [[recursive-queries_quiz]]

#sql #zettelkasten