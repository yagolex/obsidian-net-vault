# GROUP BY, агрегатные функции и временные интервалы

`GROUP BY` используется для группировки данных по определённым значениям и агрегирования с помощью функций `COUNT`, `SUM`, `AVG` и т.д.

## Примеры:
```sql
SELECT DepartmentID, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;
```

```sql
SELECT FORMAT(OrderDate, 'yyyy-MM') AS Month, SUM(Amount) AS Revenue
FROM Orders
GROUP BY FORMAT(OrderDate, 'yyyy-MM');
```

## Нюансы:
- Все поля в SELECT, не входящие в агрегатную функцию, должны быть в GROUP BY
- Можно группировать по выражениям (например, FORMAT или DATEPART)

## Связанные темы:
- [[sql-joins]]
- [[execution-plan-indexes]]
- [[cte-vs-temp-tables]]

## 🔁 Практика и повторение
- [[group-by-aggregates_bloom]]
- [[group-by-aggregates_quiz]]

#sql #zettelkasten
