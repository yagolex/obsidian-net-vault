`OUTPUT` — это мощный инструмент в SQL Server, который позволяет **получить результат изменения данных** (`INSERT`, `UPDATE`, `DELETE`, `MERGE`) **прямо в момент выполнения запроса**.

## 🔹 Что делает `OUTPUT`?

Позволяет:
- Получать значения **вставленных**, **удалённых** или **обновлённых** строк    
- Возвращать их сразу в **результат запроса** (`SELECT`)    
- Или сохранять во **временную таблицу**, **таблицу-переменную**, **реальную таблицу**

## 🔑 Зарезервированные "псевдотаблицы"

|Ключевое слово|Что содержит|
|---|---|
|`inserted`|Новые значения (используется в `INSERT` и `UPDATE`)|
|`deleted`|Старые значения (используется в `DELETE` и `UPDATE`)|
### 📌 Как это работает:

- При **`INSERT`** — доступен только `inserted`    
- При **`DELETE`** — только `deleted`    
- При **`UPDATE`** — доступны **обе**: `inserted` и `deleted`    
- При **`MERGE`** — можно использовать `OUTPUT` для всех операций сразу

## 🛠 Примеры использования `OUTPUT`

###  1. ✅ `INSERT ... OUTPUT` — возврат ID и новых значений:
```sql
INSERT INTO Products (Name, Price)
OUTPUT inserted.ProductID, inserted.Name
VALUES ('Tablet', 499.99);
```
➡ Возвращает ID и имя вставленного товара.

### 2. ✅ `UPDATE ... OUTPUT` — старые и новые значения:
```sql
UPDATE Products
SET Price = Price * 1.10
OUTPUT 
    deleted.Price AS OldPrice,
    inserted.Price AS NewPrice
WHERE Name = 'Monitor';
```
➡ Получим, как изменилась цена.

###  3. ✅ `DELETE ... OUTPUT` — удалённые строки:
```sql
DELETE FROM Products
OUTPUT deleted.ProductID, deleted.Name
WHERE Price < 10;
```
➡ Можно использовать как **аудит удаления**.

###  4. ✅ Сохраняем результат в таблицу:
```sql
DECLARE @DeletedProducts TABLE (
    ProductID INT,
    Name NVARCHAR(100)
);

DELETE FROM Products
OUTPUT deleted.ProductID, deleted.Name
INTO @DeletedProducts;
```

###  5. 🔄 Пример с UPDATE + JOIN + OUTPUT:
```sql
UPDATE p
SET p.Price = p.Price * 1.2
OUTPUT 
    deleted.ProductID,
    deleted.Price AS OldPrice,
    inserted.Price AS NewPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.Name = 'Electronics';
```







## 💡 Когда `OUTPUT` особенно полезен:

- Возврат ID при массовых вставках    
- Логирование изменений (`UPDATE`/`DELETE`) в отдельную таблицу    
- Аудит: "что было" и "что стало"    
- Отладка сложных `MERGE`-операций    

## ⚠ Особенности:

|Особенность|Комментарий|
|---|---|
|Можно использовать только один `OUTPUT` за запрос|Нельзя писать два `OUTPUT` подряд|
|Нельзя использовать `OUTPUT` с `SELECT`|Только с `INSERT/UPDATE/DELETE/MERGE`|
|`inserted` / `deleted` — не настоящие таблицы|Это псевдотаблицы внутри триггера или `OUTPUT`|

## Related topics:
- [[merge-audit]]
- [[identity-audit]]
- [[sql-joins]]