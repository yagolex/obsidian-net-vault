# 🔤 Collation

## 🎭 COLLATION — правила сравнения строк:

**COLLATE** задаёт правила:
- Сортировки (по алфавиту)    
- Регистр (Case-Sensitive `CS` или Case-Insensitive `CI`)    
- Акценты (Accent-Sensitive `AS` / `AI`)
## Пример:
```sql
SELECT * FROM Users WHERE Name = 'oleg' COLLATE Latin1_General_CS_AS
```

- `'Oleg' ≠ 'oleg'` — если `CS`    
- `'é' ≠ 'e'` — если `AS`    

Можно задать COLLATION на уровне базы, таблицы или отдельной колонки.
## Related topics:
- [[table-definition-and-behavior]]

## 🔁 Practice and Review

- [[topic-bloom]]
- [[topic-quiz]]

#sql #zettelkasten
