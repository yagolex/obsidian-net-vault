# Batch и Bulk операции

## Batch:
Позволяет выполнять обработку по частям.
```sql
WHILE 1 = 1
BEGIN
  DELETE TOP (1000) FROM Logs WHERE Date < '2020-01-01';
  IF @@ROWCOUNT = 0 BREAK;
END
```

## Bulk:
Используется для массовой загрузки данных.
```sql
BULK INSERT Products
FROM 'C:\data\products.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');
```

## Связанные темы:
- [[execution-plan-indexes]]
- [[read-write-split]]

## 🔁 Практика и повторение
- [[batch-bulk-operations_bloom]]
- [[batch-bulk-operations_quiz]]

#sql #zettelkasten