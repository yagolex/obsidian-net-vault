# GROUP BY, агрегатные функции и временные интервалы

`GROUP BY` используется для группировки данных по определённым значениям и агрегирования с помощью функций `COUNT`, `SUM`, `AVG` и т.д.

## 📄 Общий синтаксис:
```sql
SELECT Column1, AGG_FUNC(Column2)
FROM TableName
GROUP BY Column1;
```

Рассмотрим несколько примеров используя данные из таблицы **Orders**:

| OrderID | CustomerID | Amount | OrderDate  |
| ------- | ---------- | ------ | ---------- |
| 1       | 101        | 100    | 15-06-2023 |
| 2       | 102        | 200    | 13-05-2024 |
| 3       | 101        | 150    | 17-09-2024 |
| 4       | 103        | 300    | 18-11-2025 |

## Пример 1: Подсчет количества заказов по клиенту:


```sql
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID;
```

🔍 **Результат:**

|CustomerID|OrderCount|
|---|---|
|101|2|
|102|1|
|103|1|
🎯 Мы сгруппировали строки по `CustomerID`, и для каждой группы посчитали количество строк.
## Пример 2: Средний чек по клиенту

```sql
SELECT CustomerID, AVG(Amount) AS AverageAmount
FROM Orders
GROUP BY CustomerID;
```

🔍 **Результат:**

| CustomerID | AverageAmount |
| ---------- | ------------- |
| 101        | 125.00        |
| 102        | 200.00        |
| 103        | 300.00        |
## Пример 3: Группировка по дате (по году)
```sql
SELECT YEAR(OrderDate) AS OrderYear, SUM(Amount) AS TotalAmount
FROM Orders
GROUP BY YEAR(OrderDate);
```

🔍 Это удобно для годовых или квартальных отчетов.

## Пример 4: Группы с более чем 1 заказом (`HAVING`)
```sql
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > 1;
```

🔍 **Результат**: только те клиенты, у которых **более одного заказа**.
## Основные функции:
- `SUM`, `AVG`, `COUNT`, `MIN`, `MAX`
## 🧠Нюансы:
- Все поля в SELECT, не входящие в агрегатную функцию, должны быть в GROUP BY
- Можно группировать по выражениям (например, FORMAT или DATEPART)
- Используем `HAVING` для фильтрации после агрегации (Аналог `WHERE`, но **после** `GROUP BY`)

## Связанные темы:
- [[sql-joins]]
- [[execution-plan]]

## 🔁 Практика и повторение
- [[group-by-aggregates_bloom]]
- [[group-by-aggregates_quiz]]

#sql #zettelkasten
