# Постраничный вывод (pagination)

## Классический пример с `OFFSET-FETCH` (SQL Server 2012+):

Предположим, у нас есть таблица `Products`:

|ProductID|Name|Price|
|---|---|---|
|1|Keyboard|50|
|2|Mouse|30|
|3|Monitor|200|
|...|...|...|

### 📄 Запрос: постраничный вывод (по 10 штук на страницу):
```sql
DECLARE @PageNumber INT = 2;
DECLARE @PageSize INT = 10;

SELECT ProductID, Name, Price
FROM Products
ORDER BY ProductID
OFFSET (@PageNumber - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;

```

#### 🔍 Как это работает:

- `@PageNumber = 2` — значит, вторая страница    
- `@PageSize = 10` — значит, по 10 строк на страницу    
- `OFFSET` — пропускаем `(2 - 1) * 10 = 10` строк    
- `FETCH NEXT` — берём **следующие 10 строк**

#### 🧠 Обязательно: `ORDER BY` нужно всегда!

Без `ORDER BY` **нельзя использовать `OFFSET-FETCH`**, потому что SQL Server не может гарантировать порядок строк.
#### ✅ Советы:

- Для стабильного результата желательно сортировать по уникальному столбцу (`ProductID`, `CreatedAt`, `ROW_NUMBER() OVER(...)`)    
- Можно использовать вместе с `WHERE` для фильтрации


## 🚀 Альтернатива: через `ROW_NUMBER()` (для SQL Server 2005+):

### 📄 Если ты используешь **старую версию SQL Server** (до 2012), можно сделать так:
```sql

WITH OrderedProducts AS (
    SELECT 
        ProductID, Name, Price,
        ROW_NUMBER() OVER (ORDER BY ProductID) AS RowNum
    FROM Products
)
SELECT ProductID, Name, Price
FROM OrderedProducts
WHERE RowNum BETWEEN 11 AND 20;  -- Строки для 2-й страницы (10 на странице)


```

## Related topics:
- [[sql-joins]]
- [[group-by-aggregates]]


#sql #zettelkasten
