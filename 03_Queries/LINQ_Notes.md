**Кратко:** в EF Core LINQ-запрос – это выражение, которое переводится в SQL. Не весь LINQ поддержан одинаково хорошо.

### Общие принципы

- Всё, что до `ToList`/`First`/`Single`/`Count` — строит выражение.
    
- EF пытается перевести это выражение в SQL.
    
- Если не может:
    
    - либо часть выполнилась на клиенте;
        
    - либо выбрасывается исключение (зависит от версии/настроек).
        

### Часто используемые конструкции

`// Where / OrderBy / ThenBy / Take / Skip var page = context.Orders     .Where(o => o.Status == OrderStatus.Paid)     .OrderByDescending(o => o.CreatedAt)     .Skip(pageIndex * pageSize)     .Take(pageSize)     .ToList();`

`// GroupBy (в EF Core работает не как в памяти) var stats = context.Orders     .GroupBy(o => o.Status)     .Select(g => new     {         Status = g.Key,         Count = g.Count(),         Total = g.Sum(o => o.TotalAmount)     })     .ToList();`

`// Any / All / Contains bool hasOverdue = context.Orders     .Any(o => o.DueDate < DateTime.UtcNow);`

### Что важно помнить

- **Side-effects в Where/Select** (логирование, изменение внешних переменных) в БД не выполнятся.
    
- Методы .NET, которые EF не знает, нельзя использовать напрямую в запросе; их надо вытащить **после** materialize (`ToList()`), либо оформить как **функции БД**/`HasDbFunction`.
    
- Ловушка: `ToList()` посередине цепочки:
    
    - Всё после него – LINQ-to-Objects, а не LINQ-to-Entities.
        

### Пример «плохого» и «хорошего» кода

❌ _Плохой (ранняя материализация, лишние данные):_

`var allOrders = context.Orders     .Include(o => o.Items)     .ToList();              // всё в память  var filtered = allOrders     .Where(o => o.Status == OrderStatus.Paid)     .ToList();`

✅ _Хороший:_

`var filtered = context.Orders     .Where(o => o.Status == OrderStatus.Paid)     .Select(o => new     {         o.Id,         Total = o.Items.Sum(i => i.Price * i.Quantity)     })     .ToList();`