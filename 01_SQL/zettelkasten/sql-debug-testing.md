# Тестирование и отладка SQL

## Методы:
- `PRINT`, `RAISERROR`, `TRY/CATCH`
- Временные таблицы для сохранения промежуточных результатов
- `SET STATISTICS IO/TIME ON` — для анализа производительности
- Сравнение планов выполнения

## Пример отладки:
```sql
BEGIN TRY
  -- Код
END TRY
BEGIN CATCH
  SELECT ERROR_MESSAGE();
END CATCH;
```

## Связанные темы
- [[sql-joins]]
- [[join-vs-union]]
- [[group-by-aggregates]]
- [[subqueries]]
- [[merge-audit]]
- [[transactions-isolation]]
- [[normalization-keys]]
- [[constraints-check-default]]
- [[cte-vs-temp-tables]]
- [[recursive-queries]]
- [[execution-plan]]
- [[query-optimization]]
- [[partitioned-indexed]]
- [[batch-bulk-operations]]
- [[read-write-split]]

## 🔁 Практика и повторение
- [[sql-debug-testing_bloom]]
- [[sql-debug-testing_quiz]]

#sql #zettelkasten