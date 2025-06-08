# MERGE и аудит (OUTPUT)

`MERGE` — мощная команда для объединения `INSERT`, `UPDATE` и `DELETE` в одном выражении.

## Сценарий:
- Сопоставление данных между таблицами
- Обновление существующих, вставка новых, удаление старых

## Пример:
```sql
MERGE Target t
USING Source s ON t.ID = s.ID
WHEN MATCHED THEN UPDATE SET t.Value = s.Value
WHEN NOT MATCHED THEN INSERT (ID, Value) VALUES (s.ID, s.Value)
OUTPUT $action, inserted.*, deleted.*;
```

## Аудит (OUTPUT):

- Позволяет логировать изменения
- `$action` показывает тип действия: `INSERT`, `UPDATE`, `DELETE`
- `OUTPUT`: фиксирует изменения

## Использование:
- Синхронизация данных
- Логирование в таблицу аудита
- Массовые обновления

## Связанные темы:
- [[returning-data]]
- [[transactions-isolation]]

## 🔁 Практика и повторение
- [[merge-audit_bloom]]
- [[merge-audit_quiz]]

#sql #zettelkasten