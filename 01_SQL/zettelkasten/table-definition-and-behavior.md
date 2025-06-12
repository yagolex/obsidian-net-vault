# Создание таблиц, ограничения, триггеры и IDENTITY

## Описание
Эта тема охватывает создание таблиц в SQL, использование автоинкрементных полей, ограничений (constraints), значений по умолчанию, а также использование триггеров.

## Пример таблицы
```sql
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(100) NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) UNIQUE,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETDATE()б
    Age INT CHECK (Age >= 0),
    FullName as (FirstName + ' ' + LastName) PERSISTED,
    Comment NVARCHAR(100) SPARSE
);
```

## Основные элементы

- `IDENTITY(seed, increment)` — автоинкремент чисел
- `PERSISTED` - вычисляемая колонка (Computed Columns)
	- может улучшать производительность при частом чтении
	- появляется возможность создавать индекс для этой колонки, при условии, что такая колонка:
		- помечена как PERSISTED
		- создаётся с помощью детерминированной функции (это функция, которая **всегда возвращает один и тот же результат** при одинаковом вводе)
- `SPARSE` - специальный аттрибут, оптимизирующий хранение `NULL`
	- Снижает расход места для колонок, где часто `NULL`.    
	- Но: чуть выше накладные расходы на чтение/запись.    
	- **Нельзя** применять к `ROWGUID`, `timestamp`, `FILESTREAM`.
- Ограничения (Constraints):
	- `PRIMARY KEY`, `FOREIGN KEY`
	- `UNIQUE`, `NOT NULL`, `CHECK`
	- `DEFAULT` — значение по умолчанию
- `TRIGGER` — автоматическая логика при `INSERT/UPDATE/DELETE`
	- Могут быть `AFTER` или `INSTEAD OF`
	- Используются для:
		- Валидации сложной логики    
		- Аудита (`INSERT INTO AuditTable ...`)    
		- Поддержки денормализованных данных
## Пример триггера
```sql
CREATE TRIGGER trg_AuditUsers
ON Users
AFTER INSERT
AS
BEGIN
    INSERT INTO AuditLog (TableName, Action, Timestamp)
    SELECT 'Users', 'INSERT', GETDATE()
END
```

## Связанные темы:
- [[primary-and-foreign-keys]]
- [[constraints-check-default]]
- [[sql-indexes]]
- [[collation]]
- [[temporal-tables]]



#sql #zettelkasten
