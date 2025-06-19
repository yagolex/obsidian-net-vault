# Partitioned Tables и Indexed Views

## Partitioned Tables:
- Разделяют таблицу на секции по диапазону
- Используется для масштабирования и управления данными

```sql
CREATE PARTITION FUNCTION pf (int) AS RANGE LEFT FOR VALUES (1000, 10000);
```

## Indexed Views:
- Представление с индексом, сохраняемое физически
- Ограничения на состав (например, нет COUNT(*))

```sql
CREATE VIEW v AS SELECT CategoryID, COUNT_BIG(*) AS Count FROM Products GROUP BY CategoryID
WITH SCHEMABINDING;
CREATE UNIQUE CLUSTERED INDEX ix_v ON v(CategoryID);
```

## Связанные темы
- [[sql-joins]]
- [[join-vs-union]]
- [[group-by-aggregates]]
- [[subqueries]]
- [[merge-audit]]
- [[transactions-isolation]]
- [[normalization]]
- [[constraints-check-default]]
- [[cte-vs-temp-tables]]
- [[recursive-queries]]
- [[execution-plan]]
- [[query-optimization]]
- [[batch-bulk-operations]]
- [[read-write-db-split]]
- [[sql-debug-testing]]

## 🔁 Практика и повторение
- [[partitioned-indexed_bloom]]
- [[partitioned-indexed_quiz]]

#sql #zettelkasten