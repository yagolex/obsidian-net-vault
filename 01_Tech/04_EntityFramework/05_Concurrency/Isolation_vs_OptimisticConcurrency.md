
# Isolation Level vs Optimistic Concurrency in EF Core
tags:: #efcore #transactions #concurrency #isolation #database

## 💡 Concept Overview
**Isolation Levels** — механизм СУБД, управляющий видимостью данных между параллельными транзакциями.  
**Optimistic Concurrency** — механизм EF Core, предотвращающий логические конфликты изменений одной и той же строки без блокировок.

Они **работают независимо**, но могут сочетаться.  
Изоляция — про то, *что видят запросы друг друга*,  
а оптимистичная конкуренция — про то, *чтобы не потерять чужие изменения при обновлении*.

---

## ⚙️ Auto-commit Transactions (неявные транзакции)

Даже если вы не создавали `BeginTransaction()`, СУБД выполняет каждый `UPDATE/INSERT/DELETE` в короткой неявной транзакции.

```sql
UPDATE Orders SET Total = 100 WHERE Id = 1;

-- фактически СУБД делает:
BEGIN TRANSACTION;
UPDATE Orders SET Total = 100 WHERE Id = 1;
COMMIT;
```

Поэтому уровень изоляции **всегда действует**, даже если транзакция “не объявлена”.

---

## 📊 Сравнение механизмов

| Параметр | Isolation Level | Optimistic Concurrency |
|-----------|----------------|------------------------|
| Что контролирует | Видимость данных между транзакциями | Конфликты логических изменений одной записи |
| Где работает | В СУБД | В EF Core + SQL (`WHERE RowVersion=@old`) |
| Использует блокировки | ✅ Да (в зависимости от уровня) | ❌ Нет |
| Когда активен | При чтении и записи | При `UPDATE` / `DELETE` |
| Зависит от транзакций | ✅ Да (включая auto-commit) | ⚙️ Нет напрямую, но работает внутри транзакции EF |
| Типичная цель | Избежать dirty/non-repeatable/phantom reads | Избежать потери чужих изменений |
| Производительность | Потенциально блокирует других | Высокая, без блокировок |

---

## 🧠 Isolation Levels Summary

| Level | Поведение | Блокировки | Применение |
|-------|------------|-------------|-------------|
| **Read Uncommitted** | Может читать незакоммиченные данные | Нет | Диагностика, редко используется |
| **Read Committed** *(default)* | Читает только коммиченные строки | Кратковременные | Баланс производительности и согласованности |
| **Repeatable Read** | Гарантирует неизменность ранее прочитанных строк | До конца транзакции | Финансовые операции |
| **Serializable** | Полная изоляция, блокировка диапазонов | Максимальные | Критичные сценарии |
| **Snapshot / MVCC** | Работает с копией данных (версионность) | Без блокировок чтения | PostgreSQL, SQL Server SNAPSHOT |

---

## 🔍 Optimistic Concurrency Workflow

1️⃣ Клиент читает сущность (EF запоминает `RowVersion` как `OriginalValues`).  
2️⃣ Клиент меняет данные.  
3️⃣ EF генерирует SQL:

```sql
UPDATE Orders
SET Total = @Total, RowVersion = @NewRowVersion
WHERE Id = @Id AND RowVersion = @OriginalRowVersion;
```

4️⃣ Если `UPDATE` затронул 0 строк — кто-то изменил запись, EF выбрасывает `DbUpdateConcurrencyException`.

---

## ⚙️ Пример: Isolation + Optimistic Concurrency

```csharp
using var tx = await context.Database.BeginTransactionAsync(IsolationLevel.ReadCommitted);

var order = await context.Orders.FirstAsync(o => o.Id == 1);
order.Total += 10;

try
{
    await context.SaveChangesAsync(); // EF проверяет RowVersion
    await tx.CommitAsync();
}
catch (DbUpdateConcurrencyException)
{
    Console.WriteLine("Conflict detected: RowVersion mismatch!");
}
```

---

## 🧩 Сводка

| Вопрос | Ответ |
|--------|--------|
| Работает ли изоляция без транзакции? | Да, через авто-коммитные транзакции. |
| Влияет ли уровень изоляции на Optimistic Concurrency? | Нет, это независимый механизм. |
| Использует ли EF транзакции при SaveChanges()? | Да, создаёт краткоживущую внутреннюю транзакцию. |
| Можно ли совмещать оба подхода? | Да, и часто именно так достигается высокая надёжность при высокой нагрузке. |

---

## 🧠 Ключевая идея
> Изоляция — про “что ты видишь”.  
> Конкуренция — про “что ты изменяешь”.  
> EF Core применяет оба механизма: база данных защищает целостность чтения, а EF — целостность изменений.


## 🃏 Связанные темы
- [[Optimistic_Concurrency]]
- [[Transaction_Isolation]]