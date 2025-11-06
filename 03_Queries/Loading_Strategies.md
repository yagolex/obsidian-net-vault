**Кратко:** три стратегии:

- **Eager** – заранее через `Include`.
    
- **Lazy** – «по требованию» при обращении к навигации.
    
- **Explicit** – вручную через `Entry(...).Collection(...).Load()`.
    

### Eager loading

`var orders = context.Orders     .Include(o => o.Customer)     .Include(o => o.Items)     .ToList();`

- Плюсы:
    
    - Один (или несколько контролируемых) запросов.
        
    - Нет N+1.
        
- Минусы:
    
    - Легко «перетащить» лишние данные.
        
    - Сложно контролировать, если `Include`-ов становится слишком много.
        

### Lazy loading

Подключение (пример):

`services.AddDbContext<AppDbContext>(options =>     options.UseSqlServer(connString)            .UseLazyLoadingProxies());  public class Order {     public int Id { get; set; }     public virtual Customer Customer { get; set; } // virtual! }`

- Плюсы:
    
    - Используешь как обычные свойства, EF подгружает сам.
        
    - Удобно при сложной навигации.
        
- Минусы:
    
    - Риск **N+1**.
        
    - Не всегда очевидно, когда идёт запрос в БД.
        
    - Веб-API: легко подгрузить кучу навигации при сериализации.
        

### Explicit loading

`var order = context.Orders.Find(id);  context.Entry(order)     .Collection(o => o.Items)     .Load();  // или context.Entry(order)     .Reference(o => o.Customer)     .Load();`

- Плюсы:
    
    - Полный контроль, когда и что грузить.
        
- Минусы:
    
    - Больше кода, нужно помнить вызвать Load().