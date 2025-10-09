# TransactionScope in EF Core
tags:: #efcore #transactions #TransactionScope

## 💡 Concept
`TransactionScope` — это способ оборачивать несколько операций (в EF Core, ADO.NET, Dapper, и даже сторонние API) в одну логическую транзакцию.  
При выходе из блока `using`, если не было ошибок — вызывается `Complete()`, и транзакция коммитится.

---

## ⚙️ Пример использования
```csharp
using var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);

await dbContext1.SaveChangesAsync();
await dbContext2.SaveChangesAsync(); // можно другой контекст

scope.Complete(); // фиксирует транзакцию
```

Если `Complete()` не вызван, либо выброшено исключение — выполняется **rollback**.

---

## 🧩 Особенности
- В .NET Core `TransactionScope` поддерживается с версии 2.1+.
- Для асинхронных операций обязательно `TransactionScopeAsyncFlowOption.Enabled`.
- Все соединения должны использовать **один и тот же connection string** и провайдер.
- При работе с несколькими БД или разными серверами может использоваться **Distributed Transaction Coordinator (MSDTC)**.

---

## ⚠️ Важно
- В EF Core предпочтительно использовать `BeginTransaction()` для локальных транзакций.
- `TransactionScope` хорош для оборачивания нескольких контекстов или разнородных API.
- Для больших распределённых систем лучше использовать паттерны Outbox / Saga.

## 🃏 Связанные темы
- [[BeginTransaction]]