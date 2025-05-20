# Execution Plan и индексы

## Execution Plan:
Показывает, как SQL Server будет выполнять запрос. Используется для оптимизации.

### Важные элементы:
- Index Seek — эффективно
- Table Scan — отсутствие индекса
- Key Lookup — может быть оптимизирован INCLUDE

## Индексы:
- Clustered — один на таблицу
- Non-Clustered — можно создать несколько
- INCLUDE и Filtered — дополнительные опции

## Пример:
```sql
CREATE NONCLUSTERED INDEX IX_CustomerName
ON Customers(LastName)
INCLUDE (FirstName);
```

## Связанные темы:
- [[sql-joins]]
- [[group-by-aggregates]]
- [[batch-bulk-operations]]

## 🔁 Практика и повторение
- [[execution-plan-indexes_bloom]]
- [[execution-plan-indexes_quiz]]

#sql #zettelkasten