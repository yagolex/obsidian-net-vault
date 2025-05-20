# Нормализация и ключи

Нормализация — процесс организации данных для устранения избыточности и обеспечения целостности.

## Нормальные формы:
- **1NF** — атомарность: отсутствие повторяющихся групп
- **2NF** — нет частичных зависимостей от части составного ключа
- **3NF** — нет транзитивных зависимостей

## Ключи:
- **Primary Key** — уникальный идентификатор строки
- **Foreign Key** — ссылка на строку в другой таблице
- **Composite Key** — составной ключ из нескольких столбцов

## Пример:
```sql
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
```

## Связанные темы:
- [[merge-audit]]
- [[transactions-isolation]]

## 🔁 Практика и повторение
- [[normalization-keys_bloom]]
- [[normalization-keys_quiz]]

#sql #zettelkasten