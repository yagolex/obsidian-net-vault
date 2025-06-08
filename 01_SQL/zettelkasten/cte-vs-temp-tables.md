# CTE (WITH expression) vs временные таблицы

## CTE (Common Table Expression):
- Временное именованное выражение, используемое в пределах одного запроса
- Не кэшируется

```sql

WITH RecentOrders AS (
  SELECT * FROM Orders WHERE OrderDate >= '2024-01-01'
)
SELECT * FROM RecentOrders WHERE Amount > 1000;

```

## Временная таблица:
- Создаётся в tempdb
- Поддерживает индексы и статистику
- Может использоваться в нескольких запросах

```sql
CREATE TABLE #RecentOrders (...);
```

## Различия:
- CTE — читаемость, временность
- Temp table — кэшируемость, статистика, многократное использование, объёмные данные

## Связанные темы:
- [[table-vars-vs-temp-tables]]
- [[recursive-queries]]
- [[execution-plan]]

## 🔁 Практика и повторение
- [[cte-vs-temp-tables_bloom]]
- [[cte-vs-temp-tables_quiz]]

#sql #zettelkasten