# ModelConfiguration

## 🧠 Quick Recall (Trigger)
**Model Configuration** — это процесс настройки _модели данных_ в Entity Framework Core, то есть того, **как ваши .NET классы (сущности)** сопоставляются с **таблицами, колонками и связями** в базе данных.

По сути, это этап, когда EF Core строит внутреннюю _мета-модель_ (`IMutableModel`), на основе которой генерируются SQL-запросы, миграции и сопоставления.

## 💻 Где и как настраивается

Есть несколько (три) способов:

1. **Fluent API** (в `OnModelCreating`):
```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<Order>()
        .ToTable("OrdersTable")
        .HasKey(o => o.Id);

    modelBuilder.Entity<Order>()
        .Property(o => o.Total)
        .HasColumnType("decimal(18,2)");
}
```
- Более гибкий и детализированный способ.    
- Подходит для сложных конфигураций (составные ключи, индексы, фильтры, shadow properties).

2.  **Data Annotations** (атрибуты в классах):

```csharp
public class Order
{
    [Key]
    public int Id { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal Total { get; set; }
}
```
- Быстро и наглядно, но менее гибко.    
- Работает прямо в классе сущности.

3. **Отдельные классы конфигурации** (через `IEntityTypeConfiguration<T>`):

```csharp
public class OrderConfiguration : IEntityTypeConfiguration<Order>
{
    public void Configure(EntityTypeBuilder<Order> builder)
    {
        builder.ToTable("OrdersTable");
        builder.HasKey(o => o.Id);
        builder.Property(o => o.Total)
               .HasColumnType("decimal(18,2)");
    }
}
```
- Удобно для крупных проектов: конфигурация каждой сущности в отдельном файле.    
- Подключение:
```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.ApplyConfiguration(new OrderConfiguration());
    // или автоматически:
    modelBuilder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);
}
```

## 🛠 Что можно настраивать
- **Имена таблиц и колонок** (`ToTable`, `HasColumnName`).    
- **Типы данных и точность** (`HasColumnType`, `HasPrecision`).    
- **Ключи** (`HasKey`, `HasAlternateKey`).    
- **Связи** (`HasOne`, `HasMany`, `WithMany` и каскадное удаление).    
- **Индексы** (`HasIndex`).    
- **Ограничения** (`IsRequired`, `HasMaxLength`).    
- **Глобальные фильтры** (`HasQueryFilter`).    
- **Свойства без поля в классе** (shadow properties).    
- **Конфигурация Value Objects / Owned Types** (`OwnsOne`, `OwnsMany`).

## 📜 Зачем это нужно
- 📦 **Поддержка согласованности между кодом и БД**.    
- 🛠 **Гибкость** — можно переопределить дефолтные маппинги EF Core.    
- 🔄 **Миграции** строятся на основе этой конфигурации.    
- 🧹 **Разделение ответственности** — конфигурация модели отдельно от бизнес-логики.

## 🃏 Связанные темы
[[ModelConfiguration pipeline]]

---

**Tags:** #EFCore #01_Basics #ModelConfiguration
