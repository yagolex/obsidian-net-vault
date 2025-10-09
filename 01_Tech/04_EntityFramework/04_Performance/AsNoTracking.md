
# AsNoTracking: Performance Optimization in EF Core
tags:: #efcore #performance #ChangeTracker #AsNoTracking

## 💡 Суть
`AsNoTracking()` говорит EF Core **не помещать материализованные сущности в ChangeTracker**.  
Это уменьшает аллокации, ускоряет материализацию и снижает нагрузку на GC — идеально для **read‑only** сценариев.

---

## ⚙️ Что делает ChangeTracker (и чего мы избегаем)
- хранит «оригинальные значения» для каждой сущности;
- отслеживает изменения (Modified/Deleted);
- поддерживает граф навигаций и identity map.

`AsNoTracking()` пропускает эти шаги — EF просто создаёт объекты и отдаёт их вам.

```csharp
// Tracked (по умолчанию): добавляет сущности в ChangeTracker
var users = await db.Users.Where(u => u.IsActive).ToListAsync();

// No tracking: не трекает → быстрее и меньше памяти
var users = await db.Users.AsNoTracking()
                          .Where(u => u.IsActive)
                          .ToListAsync();
```

---

## ⚡ Где даёт прирост
| Сценарий | Эффект |
|---|---|
| Большие списки (тысячи строк) | 2–3× быстрее материализация, в 2–4× меньше аллокаций |
| Проекции DTO (`Select`) | 3–5× на горячих путях API |
| Отчёты/экспорт/дашборды | Существенно меньше память и GC |
| Сложные графы (`Include`) | Быстрее, но помните про identity resolution |

> Для **чтения** используйте `AsNoTracking()` как настройку «по умолчанию».

---

## 🧪 Режимы трекинга
```csharp
// Глобально для контекста
options.UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);

// Локально в запросе
.AsNoTracking()                       // без трекинга
.AsNoTrackingWithIdentityResolution() // без трекинга, но одна и та же сущность в графе — один объект
.AsTracking()                         // принудительно с трекингом (перекрывает глобальную настройку)
```

`AsNoTrackingWithIdentityResolution()` полезен для `Include`, чтобы одинаковые навигации не дублировались.

---

## 🧩 Как сохранить изменения, если сущность была прочитана с `AsNoTracking`
Сущность не трекается — EF о её изменениях не знает. Есть **три стандартных пути**:

### Вариант A — повторно загрузить tracked и применить изменения (безопасно для конкуренции)
```csharp
var dto = await db.Products.AsNoTracking()
    .Where(p => p.Id == id)
    .Select(p => new ProductEditDto(p.Id, p.Name, p.Price, p.RowVersion)) // берём токен
    .SingleAsync();

// ...пользователь меняет dto...

var entity = await db.Products.FirstAsync(p => p.Id == dto.Id);  // tracked
db.Entry(entity).Property(e => e.RowVersion).OriginalValue = dto.RowVersion; // токен конкуренции
entity.Name  = dto.Name;
entity.Price = dto.Price;

await db.SaveChangesAsync(); // при конфликте будет DbUpdateConcurrencyException
```

### Вариант B — «прицепить» сущность и пометить нужные поля как изменённые
```csharp
var dto = new ProductEditDto(id, newName, newPrice, rowVersionBase64);

var stub = new Product { Id = dto.Id };        // ключевой «каркас»
db.Attach(stub);                                // делаем tracked
db.Entry(stub).Property(e => e.RowVersion).OriginalValue = Convert.FromBase64String(dto.RowVersion);
db.Entry(stub).Property(e => e.Name).CurrentValue  = dto.Name;
db.Entry(stub).Property(e => e.Price).CurrentValue = dto.Price;

db.Entry(stub).Property(e => e.Name).IsModified  = true;  // помечаем к сохранению только изменённые поля
db.Entry(stub).Property(e => e.Price).IsModified = true;

await db.SaveChangesAsync();                    // WHERE RowVersion=@old обеспечит оптимистичную конкуренцию
```

### Вариант C — Update целиком (грубее, но быстро для простых DTO)
```csharp
var entity = new Product { Id = dto.Id, Name = dto.Name, Price = dto.Price, RowVersion = Convert.FromBase64String(dto.RowVersion) };
db.Update(entity); // пометит все скалярные поля как Modified
await db.SaveChangesAsync(); // риск «перезатереть» поля, которые вы не показывали пользователю
```

> **Рекомендации:**  
> • Для критичных данных — вариант A (перезагрузка + маппинг) или B (Attach + IsModified).  
> • Всегда передавайте токен конкуренции (RowVersion/xmin) обратно в EF через `OriginalValue`.

---

## 🧠 Когда НЕ использовать `AsNoTracking`
- Вы планируете редактирование и сохранение **без пересоздания запроса**;
- Вам нужна automatic change detection по графу навигаций;
- Вы используете долгоживущий `DbContext` (лучше не надо) и рассчитываете на его first-level cache.

---

## 🧰 Шаблон для Query‑сервисов (CQRS)
```csharp
public sealed class ProductsQuery
{
    private readonly AppDbContext _db;
    public ProductsQuery(AppDbContext db) => _db = db;

    public Task<List<ProductListItem>> GetAsync(CancellationToken ct) =>
        _db.Products.AsNoTracking()
           .Where(p => p.IsActive)
           .OrderBy(p => p.Name)
           .Select(p => new ProductListItem(p.Id, p.Name, p.Price))
           .ToListAsync(ct);
}
```

---

## 📌 Итоги (для собеседования)
- `AsNoTracking()` выключает ChangeTracker → **меньше CPU и памяти**, быстрее материализация.  
- Используйте для **read‑only** запросов, отчётов, API и DTO‑проекций.  
- Для сохранения после `AsNoTracking`: либо **перезагрузить tracked и применить изменения** (A), либо **Attach + пометить поля** (B), либо `Update` целиком (C — осторожно).  
- При конкуренции **обязательно передавайте RowVersion/xmin** в `OriginalValue`.

