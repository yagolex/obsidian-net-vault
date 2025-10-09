
# Pessimistic Concurrency in EF Core
tags:: #efcore #concurrency #pessimistic #locking

## 💡 Concept

**Pessimistic Concurrency** — стратегия, при которой данные **блокируются при чтении**, чтобы никто другой не мог их изменить, пока текущая транзакция не завершится.

Используется в сценариях, где конфликт недопустим (финансовые операции, учёт остатков, биллинг).

EF Core не умеет это делать сам с помощью LINQ. Поэтому используйте:
- **Транзакцию + сырой SQL / хинты**
- Выполняйте через `FromSqlRaw`/`ExecuteSql` или `DbConnection`/`DbCommand` внутри `BeginTransaction()`.

Смотри ниже на примеры кода для SQL Server и PostgreSQL:

---

## ⚙️ Пример (SQL Server):

```csharp
await using var tx = await context.Database.BeginTransactionAsync();

var order = await context.Orders
    .FromSqlRaw("SELECT * FROM Orders WITH (UPDLOCK, ROWLOCK) WHERE Id = {0}", orderId)
    .SingleAsync();

order.Total += 10;
await context.SaveChangesAsync();

await tx.CommitAsync();
```

### 🔍 Что делает `WITH (UPDLOCK, ROWLOCK)`
- **UPDLOCK** — берёт **блокировку обновления**: другие транзакции могут читать данные, но не могут обновлять или брать собственные UPDLOCK до конца транзакции.  
  Гарантирует, что никто не «влезет» и не изменит ту же строку до коммита.
- **ROWLOCK** — заставляет использовать **строчные (row-level)** блокировки вместо страниц или таблиц.  
  Это снижает область блокировки, повышая параллельность.

Комбинация `UPDLOCK, ROWLOCK` означает: «заблокируй только нужную строку для обновления».

---

## ⚙️ Пример (PostgreSQL):

```csharp
await using var tx = await context.Database.BeginTransactionAsync();

var orderPg = await context.Orders
    .FromSqlRaw("SELECT * FROM "Orders" WHERE "Id" = {0} FOR UPDATE", orderId)
    .SingleAsync();

orderPg.Total += 10;
await context.SaveChangesAsync();
await tx.CommitAsync();
```

### 🔍 Что делает `FOR UPDATE`
- Берёт эксклюзивную блокировку строки.
- Любая другая транзакция, пытающаяся прочитать ту же строку с `FOR UPDATE`, будет ждать завершения текущей.
- При обычном SELECT (без FOR UPDATE) данные можно читать, но при попытке UPDATE произойдёт ожидание/дедлок.

---

## ⚠️ Особенности
- Блокировки живут до конца транзакции.
- При долгих транзакциях повышается риск **deadlock**.
- Поддержка блокировок зависит от провайдера (в SQLite — фиктивно).

---

## 🧠 Вывод
- **Optimistic Concurrency** лучше для большинства CRUD API, Blazor, Web API.
- **Pessimistic Concurrency** применяют для критичных операций с высокой вероятностью конфликта.
- В EF Core пессимистичные блокировки задаются через `FromSqlRaw` и управляются транзакцией вручную.

## 🃏 Связанные темы
- [[Transaction_Isolation]]