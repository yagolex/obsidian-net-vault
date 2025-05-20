# Получение вставленных/обновлённых данных

В SQL можно вернуть значения, вставленные или обновлённые в таблицу, с помощью `OUTPUT` и `SCOPE_IDENTITY()`.

## Примеры:

### Получение ID:
```sql
INSERT INTO Users (Name) VALUES ('Alice');
SELECT SCOPE_IDENTITY();
```

### С использованием OUTPUT:
```sql
INSERT INTO Products (Name, Price)
OUTPUT inserted.ProductID
VALUES ('Phone', 399.99);
```

## Обновление с возвратом старых и новых значений:
```sql
UPDATE Products
SET Price = Price * 1.10
OUTPUT deleted.Price AS OldPrice, inserted.Price AS NewPrice;
```

## Связанные темы:
- [[merge-audit]]
- [[execution-plan-indexes]]

## 🔁 Практика и повторение
- [[returning-data_bloom]]
- [[returning-data_quiz]]

#sql #zettelkasten