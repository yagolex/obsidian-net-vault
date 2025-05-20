# Разделение баз на чтение и запись

## Зачем:
- Снижение нагрузки
- Повышение отказоустойчивости
- Повышение производительности

## Методы:
- Репликация
- AlwaysOn Availability Groups
- Read-only реплики

## Пример архитектуры:
- Основная база — запись
- Реплика — только SELECT

## Связанные темы:
- [[batch-bulk-operations]]
- [[execution-plan-indexes]]

## 🔁 Практика и повторение
- [[read-write-split_bloom]]
- [[read-write-split_quiz]]

#sql #zettelkasten