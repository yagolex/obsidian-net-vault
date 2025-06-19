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
📌 Удаляет по 1000 строк за раз, пока не останется подходящих.

### 🔧 Рекомендации по batch-операциям

|Что делать|Почему|
|---|---|
|Использовать `TOP` или `OFFSET`|Для контроля размера пакета|
|Оборачивать в `TRANSACTION`|Если нужно атомарное поведение|
|Проверять `@@ROWCOUNT` или `@@FETCH_STATUS`|Чтобы понимать, когда остановиться|
|Ставить паузы (`WAITFOR DELAY`)|Если не хочешь перегружать сервер|
|Использовать `SET NOCOUNT ON`|Чтобы не засорять вывод служебной инфой|
## Bulk:
Используется для массовой загрузки данных.
```sql
BULK INSERT Products
FROM 'C:\data\products.csv'
WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');
```
📌 Это вставит строки из `products.csv` в таблицу `Products`.
### 🔧 Варианты BULK операций в **SQL Server**

|Операция|Что делает|
|---|---|
|`BULK INSERT`|Загружает данные из файла (`.csv`, `.txt`)|
|`INSERT ... FROM OPENROWSET(BULK...)`|Импортирует данные из файла как таблицу|
|`bcp` (Bulk Copy Program)|Утилита командной строки для импорта/экспорта|
|`SqlBulkCopy` (в C#)|API для быстрой загрузки из .NET|
|`FORMATFILE`|Пользовательский шаблон разбора данных при импорте|
### ⚠️ Важно помнить:

|Что учитывать|Почему это важно|
|---|---|
|Нет валидации, триггеров|Данные должны быть чистыми|
|Ограниченный контроль ошибок|Лучше указывать `ERRORFILE`|
|Может обойти ограничения (`CHECK`, `FK`)|Использовать с осторожностью|
|Не поддерживает `ID INSERT SELECT`|Это чистый импорт из файла|
### ✅ Советы по оптимизации:

- Используй `TABLOCK` при загрузке в пустую таблицу    
- Отключи `NONCLUSTERED` индексы на время загрузки    
- Импортируй сначала во **временную таблицу**, потом очищай/проверяй/переноси    
- Отключи **триггеры**, **констрейнты** и логику, если уверенность в данных есть

## Связанные темы
- [[sql-joins]]
- [[join-vs-union]]
- [[group-by-aggregates]]
- [[subqueries]]
- [[merge-audit]]
- [[transactions-isolation]]
- [[normalization]]
- [[constraints-check-default]]
- [[cte-vs-temp-tables]]
- [[recursive-queries]]
- [[execution-plan]]
- [[query-optimization]]
- [[partitioned-indexed]]
- [[read-write-db-split]]
- [[sql-debug-testing]]

## 🔁 Практика и повторение
- [[batch-bulk-operations_bloom]]
- [[batch-bulk-operations_quiz]]

#sql #zettelkasten