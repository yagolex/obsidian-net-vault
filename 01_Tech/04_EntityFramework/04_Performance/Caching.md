
# Caching в Entity Framework Core

## 🧩 1. Виды кэширования в EF Core

| Уровень | Что кэшируется | Где живёт | Управляется вами? |
|----------|----------------|------------|--------------------|
| **Model Cache** | Модель (IModel) — метаданные сущностей, связей, типов и т.п. | Глобально (per `DbContext` тип + опции) | ❌ Нет |
| **Query Compilation Cache** | Скомпилированные LINQ-выражения в SQL-дерево | Глобально (внутри EF Core) | ⚙️ Частично (через Compiled Queries) |
| **Change Tracker / First-level cache** | Отслеживаемые объекты в рамках текущего контекста | Внутри одного `DbContext` | ✅ Да |
| **Second-level cache (внешний)** | Повторное использование данных между контекстами | Внешний (через сторонние библиотеки) | ✅ Полностью |

---

## 🧠 2. Model Cache
EF Core строит внутреннюю модель (`IModel`) при первом создании `DbContext` и потом **переиспользует** её для всех следующих экземпляров.

- Ключ кэша: тип контекста + `DbContextOptions`.
- Можно переопределить через `IModelCacheKeyFactory`.
- Содержимое: имена таблиц, свойства, связи, конфигурация и т.д.

---

## ⚡ 3. Query Compilation Cache
EF кэширует готовые планы запросов. Например:

```csharp
db.Users.Where(u => u.Id == 5);
db.Users.Where(u => u.Id == 6); // использует тот же план
```

Для ручного контроля можно использовать **Compiled Queries**:

```csharp
private static readonly Func<AppDbContext, int, Task<User?>> _getUserById =
    EF.CompileAsyncQuery((AppDbContext db, int id) =>
        db.Users.AsNoTracking().FirstOrDefault(u => u.Id == id));

var user = await _getUserById(db, 42);
```

---

## 🧍 4. Change Tracker (First-level cache)
Кэш сущностей в рамках одного контекста.

```csharp
var a = await db.Users.FindAsync(1);
var b = await db.Users.FindAsync(1); // возвращается из кэша
```

- Сбрасывается при `ChangeTracker.Clear()`.
- Для чтения используйте `AsNoTracking()`.

---

## 🗄️ 5. Second-level cache (внешний)

EF Core **не имеет встроенного кэша второго уровня**.

### Через NuGet

[`EFCoreSecondLevelCacheInterceptor`](https://github.com/VahidN/EFCoreSecondLevelCacheInterceptor):

```csharp
services.AddEFSecondLevelCache(options =>
    options.UseMemoryCacheProvider()
           .CacheAllQueries(CacheExpirationMode.Absolute, TimeSpan.FromMinutes(5)));

services.AddDbContext<AppDbContext>((sp, opt) =>
{
    opt.UseSqlServer(connStr)
       .AddInterceptors(sp.GetRequiredService<SecondLevelCacheInterceptor>());
});
```

### Альтернатива
Кэшируйте DTO-результаты вручную через `IMemoryCache` или Redis.

```csharp
public class ProductService
{
    private readonly AppDbContext _db;
    private readonly IMemoryCache _cache;

    public ProductService(AppDbContext db, IMemoryCache cache)
    {
        _db = db;
        _cache = cache;
    }

    public async Task<Product?> GetProductAsync(int id)
    {
        return await _cache.GetOrCreateAsync($"product:{id}", async entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
            return await _db.Products.AsNoTracking()
                         .FirstOrDefaultAsync(p => p.Id == id);
        });
    }
}
```

---

## ⚠️ 6. Типичные ошибки

| Ошибка | Почему плохо |
|--------|---------------|
| Долгоживущий DbContext | разрастается ChangeTracker |
| Кэширование сущностей с навигациями | ломается согласованность данных |
| Отсутствие AsNoTracking | расходуется память впустую |
| Кэш без инвалидатора | устаревшие данные |
| Состояние в DbContext при пуллинге | может “прилипнуть” между запросами |

---

## 📘 7. Итог (для интервью)

> В EF Core кэшируются модель и скомпилированные запросы, а также есть кэш первого уровня (Change Tracker). Второго уровня нет — добавляется внешне. Для readonly-запросов используйте `AsNoTracking`, а для частых запросов — Compiled Queries или внешний кэш (MemoryCache, Redis).
