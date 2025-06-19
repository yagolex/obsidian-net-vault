# Получение вставленных/обновлённых данных

В Microsoft SQL Server есть **несколько способов получить идентификатор или значения строки**, которую ты **только что вставил или обновил**.
### 1. Получение ID с помощью SCOPE_IDENTITY:
```sql
INSERT INTO Users (Name) VALUES ('Alice');
SELECT SCOPE_IDENTITY();
```

### 2. Получение ID с использованием OUTPUT:
```sql
INSERT INTO Products (Name, Price)
OUTPUT inserted.ProductID
VALUES ('Phone', 399.99);
```
📌 Возвращает значения **вставленных строк** сразу после `INSERT`.
#### Обновление с возвратом старых и новых значений:
```sql
UPDATE Products
SET Price = Price * 1.10
OUTPUT deleted.Price AS OldPrice, inserted.Price AS NewPrice;
```

#### 🔁 Пример использования с `INSERT INTO ... OUTPUT INTO` (без SELECT):
```sql
DECLARE @NewIDs TABLE (ID INT);

INSERT INTO Orders (CustomerID, OrderDate)
OUTPUT inserted.OrderID INTO @NewIDs(ID)
VALUES (1, GETDATE());

SELECT * FROM @NewIDs;
```
🎯 Это позволяет сохранить результат вставки, например, для аудита или логгирования.


### 3. **`@@IDENTITY`** — менее безопасный аналог `SCOPE_IDENTITY()`:
```sql
INSERT INTO Customers (Name) VALUES ('Test');
SELECT @@IDENTITY AS LastID;
```
⚠️ Опасен, потому что может вернуть ID, вставленный **в триггере или другой таблице**.

### 4. **`IDENT_CURRENT('TableName')`** — получает последний `IDENTITY` вне зависимости от сессии:
```sql
SELECT IDENT_CURRENT('Customers') AS LastCustomerID;
```
⚠️  Может вернуть **значение из другой сессии или даже другого пользователя**, поэтому **не используется для получения ID "вставленной мной строки"**.



### ✅ Когда использовать что?

|Цель|Используй|
|---|---|
|Получить ID вставленной строки|`SCOPE_IDENTITY()` или `OUTPUT`|
|Получить все значения вставленной строки|`OUTPUT inserted.*`|
|Получить старое и новое значение при `UPDATE`|`OUTPUT deleted.*, inserted.*`|
|Получить ID из триггера (разные таблицы)|`@@IDENTITY`|
|Получить последний ID глобально|`IDENT_CURRENT('TableName')`|

## Связанные темы:
- [[merge-audit]]
- [[execution-plan]]

## 🔁 Практика и повторение
- [[returning-data_bloom]]
- [[returning-data_quiz]]
- [[keyword-output]]

#sql #zettelkasten