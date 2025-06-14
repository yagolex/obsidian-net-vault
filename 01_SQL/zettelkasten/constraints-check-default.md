# CHECK, DEFAULT, CONSTRAINTS

Ограничения (Constraints) обеспечивают целостность данных:
	- `PRIMARY KEY`, `FOREIGN KEY`
	- `UNIQUE`, `NOT NULL`, `CHECK`
	- `DEFAULT` — значение по умолчанию
## CHECK:
- Контроль значений в колонке
```sql
ALTER TABLE Products
ADD CONSTRAINT CK_Price CHECK (Price > 0);
```

## DEFAULT:
- Значения по умолчанию
```sql
ALTER TABLE Users
ADD CONSTRAINT DF_Created DEFAULT GETDATE() FOR CreatedDate;
ADD CONSTRAINT DF_Active DEFAULT 1 FOR IsActive;
```

## PRIMARY KEY / FOREIGN KEY :
- Задают уникальность и связи
- PRIMARY KEY = уникальность
- FOREIGN KEY = связь с другой таблицей
- Подробнее смотри [[primary-and-foreign-keys]]
### `UNIQUE` vs Primary Key

#### 📋 Пример для создания таблицы:
```sql
CREATE TABLE Users (
    ID INT PRIMARY KEY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    UNIQUE (FirstName, LastName), -- Unique value for fields combination
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Code NVARCHAR(20) UNIQUE -- NULL Allowed
);
```

#### 📋 Пример для добавления в существующую таблицу:
```sql
-- Создание таблицы без ограничений
CREATE TABLE Users (
    ID INT,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email NVARCHAR(100) NOT NULL,
    Code NVARCHAR(20)
);

-- Добавление PRIMARY KEY
ALTER TABLE Users
ADD CONSTRAINT PK_Users_ID PRIMARY KEY (ID);

-- Уникальность FirstName + LastName
ALTER TABLE Users
ADD CONSTRAINT UQ_Users_FirstLast UNIQUE (FirstName, LastName);

-- Уникальность Email (не допускает дубликатов)
ALTER TABLE Users
ADD CONSTRAINT UQ_Users_Email UNIQUE (Email);

-- Уникальность Code (NULL допустим)
ALTER TABLE Users
ADD CONSTRAINT UQ_Users_Code UNIQUE (Code);
```


#### 📊 Сравнение `PRIMARY KEY` vs `UNIQUE`:

|Характеристика|`PRIMARY KEY`|`UNIQUE`|
|---|---|---|
|Назначение|Основной идентификатор строки|Дополнительное ограничение уникальности|
|Количество на таблицу|❗ Только один|✅ Можно несколько|
|NULL значения|❌ Не допускаются|✅ Допускаются (зависит от СУБД)|
|Индекс|✅ Кластерный по умолчанию|✅ Некластерный по умолчанию|
|Неявное имя|Да (`PK_Users_ID`)|Да (`UQ_Users_Email`)|
|Использование как FK|✅ Часто|✅ Можно|
|Часто комбинируется с|`IDENTITY`, `FOREIGN KEY`|`CHECK`, альтернативные ключи|


## Связанные темы:
- [[table-definition-and-behavior]]
- [[primary-and-foreign-keys]]

## 🔁 Практика и повторение
- [[constraints-check-default_bloom]]
- [[constraints-check-default_quiz]]

#sql #zettelkasten