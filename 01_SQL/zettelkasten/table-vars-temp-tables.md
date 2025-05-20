# Таблицы-переменные и временные таблицы

## Таблица-переменная (@Table):
- Объявляется внутри процедуры
- Не имеет статистики
- Лучше для небольших наборов данных

## Временная таблица (#Temp):
- Создаётся в tempdb
- Поддерживает индексы и статистику
- Удобна при больших объёмах и множественных запросах

## Пример:
```sql
DECLARE @MyTable TABLE (ID INT, Name NVARCHAR(50));
INSERT INTO @MyTable VALUES (1, 'Test');
```

```sql
CREATE TABLE #Temp (ID INT, Name NVARCHAR(50));
INSERT INTO #Temp VALUES (1, 'Temp');
```

## Связанные темы:
- [[cte-vs-temp-tables]]
- [[execution-plan-indexes]]

## 🔁 Практика и повторение
- [[table-vars-temp-tables_bloom]]
- [[table-vars-temp-tables_quiz]]

#sql #zettelkasten