# CHECK, DEFAULT, CONSTRAINTS

Ограничения обеспечивают целостность данных.

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

## PRIMARY KEY / FOREIGN KEY:
- Задают уникальность и связи
- PRIMARY KEY = уникальность
- FOREIGN KEY = связь с другой таблицей

## Связанные темы:
- [[normalization]]
- [[merge-audit]]

## 🔁 Практика и повторение
- [[constraints-check-default_bloom]]
- [[constraints-check-default_quiz]]

#sql #zettelkasten