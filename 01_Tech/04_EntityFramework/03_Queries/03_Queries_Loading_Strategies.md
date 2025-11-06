---
tags: [ef-core, loading, lazy, eager, explicit]
aliases: [Eager Loading, Lazy Loading, Explicit Loading]
---
# EF Core – Loading Strategies

## Обзор
Entity Framework Core поддерживает три стратегии загрузки связанных данных:
- **Eager Loading** — заранее через `Include` / `ThenInclude`  
- **Lazy Loading** — по требованию при первом обращении к свойству  
- **Explicit Loading** — вручную через `.Load()`

## Примеры
### Eager Loading
```csharp
var orders = context.Orders
    .Include(o => o.Customer)
    .Include(o => o.Items)
    .ToList();
```

### Lazy Loading
```csharp
services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(conn).UseLazyLoadingProxies());

public class Order {
    public virtual Customer Customer { get; set; }
}
```

### Explicit Loading
```csharp
var order = context.Orders.Find(id);
context.Entry(order).Collection(o => o.Items).Load();
```

## Плюсы и минусы
- **Eager:** меньше запросов, но может тянуть лишние данные.  
- **Lazy:** удобен, но вызывает риск N+1.  
- **Explicit:** полный контроль, но требует больше кода.

## Связанные темы
- [[03_Queries/AsSplitQuery]]
- [[03_Queries/Projections]]
