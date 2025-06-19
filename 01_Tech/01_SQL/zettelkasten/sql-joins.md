# JOIN-операции в SQL

JOIN-операции позволяют объединять строки из двух или более таблиц на основе логического условия соответствия.

## Типы JOIN:
- **INNER JOIN** — возвращает только совпадающие строки
- **LEFT JOIN** — все строки из левой таблицы + совпадающие из правой
- **RIGHT JOIN** — все строки из правой таблицы + совпадающие из левой
- **FULL JOIN** — объединяет строки из обеих таблиц
- **CROSS JOIN** — декартово произведение

## Пример:
```sql
SELECT e.Name, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.ID;
```

## Нюансы:
- Используйте `ON`, а не `WHERE` при INNER JOIN
- `LEFT JOIN` часто используется для поиска «отсутствующих» связей (При отсутствии соответствий LEFT/RIGHT вернёт NULL)
- CROSS JOIN может создавать огромное количество строк
- `INNER JOIN` может фильтровать строки
- `FULL OUTER JOIN` полезен при анализе отсутствующих связей


## Связанные темы:
- [[sql-many-to-many-joins]]
- [[join-vs-union]]
- [[group-by-aggregates]]
- [[execution-plan]]

## 🔁 Практика и повторение
- [[sql-joins_bloom]]
- [[sql-joins_quiz]]

#sql #zettelkasten
