
# Transaction Isolation Levels in EF Core
tags:: #efcore #transactions #isolation

## 💡 Overview
**Isolation level** — это механизм контроля параллелизма в СУБД, который определяет, какие изменения одной транзакции видны другим и какие блокировки при этом удерживаются.  
Чем выше уровень изоляции — тем меньше аномалий (dirty / non-repeatable / phantom reads), но тем выше риск дедлоков и меньше параллельность.

---

## 📊 SQL Standard Levels

| Level | Description | Prevents | Typical Use |
|-------|--------------|-----------|--------------|
| **Read Uncommitted** | Чтение незакоммиченных данных (грязное чтение) | — | Мониторинг, диагностические запросы |
| **Read Committed** *(default)* | Видны только коммиченные изменения | Dirty reads | Большинство OLTP систем |
| **Repeatable Read** | Гарантирует, что ранее прочитанные строки не изменятся | Dirty, Non-repeatable | Денежные операции, отчёты |
| **Serializable** | Полная изоляция (эмулирует последовательные транзакции) | Все три | Критичные расчёты, редкие случаи |
| **Snapshot / MVCC** | Каждый видит свой снимок данных на момент начала транзакции | Dirty, Non-repeatable, Phantom | PostgreSQL (MVCC), SQL Server SNAPSHOT |

---

## ⚙️ Установка уровня изоляции в EF Core

```csharp
using var tx = await context.Database.BeginTransactionAsync(IsolationLevel.RepeatableRead);
// операции...
await tx.CommitAsync();
```

**Глобально для SQL Server:**
```sql
ALTER DATABASE MyDb SET ALLOW_SNAPSHOT_ISOLATION ON;
ALTER DATABASE MyDb SET READ_COMMITTED_SNAPSHOT ON;
```

---

## 🧠 Notes
- EF Core использует уровень изоляции базы по умолчанию (`ReadCommitted`).
- Для сложных сценариев используйте ручное управление транзакциями.
- Optimistic Concurrency работает поверх обычных транзакций, добавляя проверку `RowVersion`.

## 🃏 Связанные темы
- [[BeginTransaction]]
- [[Isolation_vs_OptimisticConcurrency]]
