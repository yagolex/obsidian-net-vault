# N+1 Query Problem in EF Core
tags:: #efcore #performance #pitfalls #nplus1

## 💡 Concept
N+1 проблема возникает, когда приложение делает 1 запрос для основной коллекции и N дополнительных запросов — для каждой записи, чтобы подгрузить навигационные данные.

---

## ⚠️ Пример плохого кода
```csharp
var users = await context.Users.ToListAsync();

foreach (var user in users)
{
    var orders = await context.Orders.Where(o => o.UserId == user.Id).ToListAsync(); // ← N дополнительных запросов
}
```

Результат: 1 (users) + N (orders) запросов → низкая производительность.

---

## ✅ Решение — Eager Loading
```csharp
var users = await context.Users
    .Include(u => u.Orders)
    .ToListAsync();
```

EF Core выполнит **один SQL‑запрос с JOIN**, подгрузив пользователей и их заказы.

---

## ⚙️ Альтернативы
- **Explicit Loading:** `await context.Entry(user).Collection(u => u.Orders).LoadAsync();`
- **Projection:** сразу выбрать DTO с нужными данными:
  ```csharp
  var users = await context.Users
      .Select(u => new { u.Id, u.Name, Orders = u.Orders.Count })
      .ToListAsync();
  ```

---

## 🧠 Советы
- Используйте `.Include()` только при необходимости — он делает JOIN и может раздувать результат.
- При сложных сценариях подумайте о **Select DTO** или **Split Query**:
  ```csharp
  context.Users.Include(u => u.Orders).AsSplitQuery();
  ```