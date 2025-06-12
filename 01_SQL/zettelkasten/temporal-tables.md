# 🕰 Что такое Temporal Tables (System-Versioned) 

**Temporal Table** = таблица с автоматическим ведением истории изменений.
### Сценарии:
- Аудит без триггеров    
- Аналитика изменений
- Восстановление данных
## 📌 Структура:

```sql
CREATE TABLE Employees (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Department NVARCHAR(100),
    ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START,
    ValidTo   DATETIME2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeesHistory));
```
### В структуре есть **две связанные таблицы**:
1. **Основная таблица** — `Employees`    
2. **Историческая таблица** — `EmployeesHistory` (создаётся и управляется SQL Server автоматически)
3. История изменений сохраняется в `EmployeesHistory`, но SQL Server сам управляет её заполнением.
	1.  `EmployeesHistory` — **нельзя напрямую изменять** (`INSERT`, `UPDATE`, `DELETE` запрещены)   
	2. **Автоматически заполняется** при `UPDATE`, `DELETE` в основной таблице 
	3. Доступна для **чтения и запросов**
	4.  Хранится в **той же базе данных**
## 🕵 Запрос с историей:
```sql
SELECT * FROM Employees FOR SYSTEM_TIME ALL WHERE ID = 1;
```

💡Доступны операторы:
- `FOR SYSTEM_TIME` 
	- `AS OF`
	- `FROM TO` 
	- `BETWEEN` 
	- `CONTAINED IN`
### 🔍 Пример результата выполнения такого запроса:

| ID  | Name       | Department | ValidFrom           | ValidTo             |
| --- | ---------- | ---------- | ------------------- | ------------------- |
| 1   | John Smith | Sales      | 2020-01-01 10:00:00 | 2021-01-01 09:00:00 |
| 1   | John Smith | Marketing  | 2021-01-01 09:00:00 | 2023-06-01 14:00:00 |
| 1   | John Smith | IT         | 2023-06-01 14:00:00 | 9999-12-31 23:59:59 |
- Первая и вторая строки — из `EmployeesHistory`    
- Последняя строка — из `Employees`

То есть, при запросе с историей SQL Server автоматически объединяет:
- Текущую запись из `Employees`    
- Исторические записи из `EmployeesHistory`

## 🔎 Примеры других запросов
###  1. Все версии за период::
```sql
SELECT * 
FROM Employees 
FOR SYSTEM_TIME 
FROM '2021-01-01' TO '2023-01-01' 
WHERE ID = 1;
```

###  2. Состояние на момент времени:
```sql
SELECT * 
FROM Employees 
FOR SYSTEM_TIME AS OF '2022-05-15T12:00:00'
WHERE ID = 1;
```

###  3. Только удалённые записи:
```sql
SELECT * 
FROM EmployeesHistory
EXCEPT
SELECT * 
FROM Employees;
```

### 🔧 Реальные сценарии использования

|Сценарий|Пример|
|---|---|
|🧾 **Аудит**|Кто изменил зарплату, когда и на что|
|⏳ **Историческая аналитика**|Отчёты по отделам в прошлом|
|🔄 **Откат изменений (rollback)**|Восстановить состояние до удаления|
|🧠 **Трассировка ошибок**|Найти источник некорректных данных|
|📊 **Версионный BI/аналитика**|Вычисление KPI с учётом изменений во времени|

##  Подводный камень: `TEXT`, `IMAGE`, `FILESTREAM` ❌ **нельзя использовать** в Temporal Tables

| Тип данных      | Назначение                                                         | Почему запрещён в Temporal Tables                                   |
| --------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------- |
| `TEXT`, `NTEXT` | Устаревшие типы для хранения длинных строк                         | Устарели, нестабильны, заменены на `VARCHAR(MAX)` и `NVARCHAR(MAX)` |
| `IMAGE`         | Для хранения бинарных данных (фото, видео и т.д.)                  | Плохо управляется системой версий                                   |
| `FILESTREAM`    | Для хранения больших файлов **вне базы данных**, но с SQL-доступом | Хранение вне обычной таблицы, не поддаётся версионированию          |

## Related topics:
- [[table-definition-and-behavior]]


#sql #zettelkasten
