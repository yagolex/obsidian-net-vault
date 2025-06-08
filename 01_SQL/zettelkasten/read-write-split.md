# Разделение баз на чтение и запись

## Зачем:
- Снижение нагрузки
- Повышение отказоустойчивости
- Повышение производительности

## Методы:
- Репликация
- AlwaysOn Availability Groups
- Read-only реплики

## Пример архитектуры:
- Основная база — запись
- Реплика — только SELECT

## Связанные темы:
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
- [[sql-debug-testing]]

## 🔁 Практика и повторение
- [[read-write-split_bloom]]
- [[read-write-split_quiz]]

#sql #zettelkasten