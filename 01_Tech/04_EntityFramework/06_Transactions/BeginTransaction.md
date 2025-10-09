# BeginTransaction in EF Core
tags:: #efcore #transactions #BeginTransaction

## 💡 Concept
EF Core автоматически создаёт короткие транзакции при каждом `SaveChanges()`,  
но иногда нужно управлять транзакцией вручную — например, при нескольких операциях, которые должны быть атомарны.

---

## ⚙️ Пример
```csharp
await using var tx = await context.Database.BeginTransactionAsync();

var user = new User { Name = "Alex" };
context.Users.Add(user);
await context.SaveChangesAsync();

var order = new Order { UserId = user.Id, Total = 100 };
context.Orders.Add(order);
await context.SaveChangesAsync();

await tx.CommitAsync();
```

Если произойдёт исключение, EF вызовет `Rollback()` автоматически при `Dispose()`.

---

## 🧠 Замечания
- Можно откатить вручную: `await tx.RollbackAsync();`
- Можно вложить несколько транзакций — EF Core поддерживает **savepoints**.
- Транзакция блокирует ресурсы на уровне БД — не держите её дольше, чем нужно.
- При работе с `TransactionScope` **не используйте BeginTransaction** одновременно.

---

## ⚡ Пример с уровнем изоляции
```csharp
await using var tx = await context.Database.BeginTransactionAsync(IsolationLevel.RepeatableRead);
// ... операции ...
await tx.CommitAsync();
```

## 🃏 Связанные темы
- [[TransactionScope]]
- [[Transaction_Isolation]]