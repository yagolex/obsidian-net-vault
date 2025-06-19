# Оптимизация запросов

## Общие рекомендации:
- Не использовать `SELECT *`
- Фильтровать как можно раньше
- Использовать индексы по WHERE/JOIN
- Избегать подзапросов в SELECT

## Пример:
```sql
SELECT c.Name, o.OrderDate
FROM Customers c
JOIN Orders o ON c.ID = o.CustomerID
WHERE o.Status = 'Active';
```

## Инструменты:
- `SET STATISTICS IO, TIME ON`
- Execution Plan
- Индексы и их использование

## Связанные темы
- [[execution-plan]]
- [[batch-bulk-operations]]
- [[sql-indexes]]

## 🔁 Практика и повторение
- [[query-optimization_bloom]]
- [[query-optimization_quiz]]

#sql #zettelkasten