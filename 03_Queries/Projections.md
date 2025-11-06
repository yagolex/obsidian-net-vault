**Кратко:** проекция — выбор не всей сущности, а нужных полей/DTO.

`var dtos = context.Orders     .Where(o => o.Status == OrderStatus.Paid)     .Select(o => new OrderDto     {         Id = o.Id,         CustomerName = o.Customer.Name,         Total = o.Items.Sum(i => i.Price * i.Quantity)     })     .ToList();`

### Зачем использовать проекции

- Сокращение объёма данных, передаваемых из БД.
    
- Меньше трекинговых объектов в DbContext.
    
- Чёткий API-модель (DTO/ViewModel) вместо утечки домена наружу.
    

### Варианты

1. **Проекция в анонимный тип**
    

`var orders = context.Orders     .Select(o => new     {         o.Id,         CustomerName = o.Customer.Name     })     .ToList();`

2. **Проекция в DTO**
    

`public record OrderSummaryDto(int Id, string CustomerName, decimal Total);  var orders = context.Orders     .Select(o => new OrderSummaryDto(         o.Id,         o.Customer.Name,         o.Items.Sum(i => i.Price * i.Quantity)))     .ToList();`

3. **Проекция в сущность без трекинга**
    

`var orders = context.Orders     .AsNoTracking()     .Select(o => new Order     {         Id = o.Id,         // ...     })     .ToList();`

### Подводные камни

- Не всё, что ты напишешь в `.Select`, переведётся в SQL.
    
    - Либо будет client evaluation (в новых EF часто запрещён),
        
    - либо исключение.
        
- Для сложных маппингов лучше использовать `Select` с чистыми expression-деревьями или AutoMapper ProjectTo.

