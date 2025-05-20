# CHECK, DEFAULT, CONSTRAINTS

Ограничения обеспечивают целостность данных.

## CHECK:
```sql
ALTER TABLE Products
ADD CONSTRAINT CK_Price CHECK (Price > 0);
```

## DEFAULT:
```sql
ALTER TABLE Users
ADD CONSTRAINT DF_Created DEFAULT GETDATE() FOR CreatedDate;
```

## PRIMARY KEY / FOREIGN KEY:
- Задают уникальность и связи

## Связанные темы:
- [[normalization-keys]]

## 🔁 Практика и повторение
- [[constraints-check-default_bloom]]
- [[constraints-check-default_quiz]]

#sql #zettelkasten