# Транзакции и уровни изоляции

Транзакции обеспечивают атомарность, согласованность, изоляцию и долговечность (ACID).

## Уровни изоляции:
| Уровень         | Грязные чтения | Неповтор. чтения | Фантомы |
|------------------|----------------|------------------|---------|
| READ UNCOMMITTED | ✅             | ✅               | ✅      |
| READ COMMITTED   | ❌             | ✅               | ✅      |
| REPEATABLE READ  | ❌             | ❌               | ✅      |
| SERIALIZABLE     | ❌             | ❌               | ❌      |

## Пример:
```sql
BEGIN TRAN;
UPDATE Accounts SET Balance = Balance - 100 WHERE ID = 1;
UPDATE Accounts SET Balance = Balance + 100 WHERE ID = 2;
COMMIT;
```

## Связанные темы:
- [[merge-audit]]
- [[normalization-keys]]

## 🔁 Практика и повторение
- [[transactions-isolation_bloom]]
- [[transactions-isolation_quiz]]

#sql #zettelkasten