# ModelConfiguration pipeline

## 🧠 Shorter simpler pipeline version

```flowchart TB
flowchart TB
    A[DbContext ctor / OnConfiguring] --> B[Создание ModelBuilder]
    B --> C[Conventions (правила по умолчанию)]
    C --> D[Data Annotations (атрибуты в классах)]
    D --> E[Fluent API (OnModelCreating)]
    E --> F[ApplyConfiguration(s) via IEntityTypeConfiguration<T>]
    F --> G[Доп. шаги: OwnsOne/OwnsMany, ValueConverter, QueryFilter, Indices, Keys, Relations]
    G --> H[Validate & Finalize модель]
    H --> I[Кэширование IModel (per контекст + опции)]
    I --> J[Миграции / Runtime: генерация SQL]
```
### Короткие подсказки к схеме

- **Порядок приоритетов:** Conventions → DataAnnotations → Fluent API (**самый сильный**).    
- **Где пишем конфигурацию:**    
    - прямо в `OnModelCreating`,        
    - или разносить по классам `IEntityTypeConfiguration<T>` и подключать `ApplyConfigurationsFromAssembly(...)`.        
- **Что ещё важно:**    
    - Модель **кэшируется** на тип контекста + ключ опций (можно переопределить через `IModelCacheKeyFactory`).        
    - Всё, что зависит от пользователя/тенанта/локали, не зашиваем в модель на этапе билда — используем **Query Filters с параметрами** или интерцепторы.     
    - Миграции берут истину из **итоговой модели** (после всех шагов на схеме).

## 💻 Более подробно (с развилками)

### Сама схема
```flowchart TB
flowchart TB
    A[Start: OnModelCreating/ApplyConfigurationsFromAssembly] --> K[Keys]
    A --> R[Relations]
    A --> I[Indexes]
    A --> O[Owned Types]
    A --> V[ValueConverter / Precision]
    A --> F[Global Query Filters]

    subgraph Keys
      K1[Primary Key]
      K2[Alternate Key]
      K3[Composite Key]
    end
    K --> K1 -->|HasKey| K3
    K --> K2

    subgraph Relations
      R1[1:1]
      R2[1:N]
      R3[N:M]
      R4[Cascade/DeleteBehavior]
    end
    R --> R1 --> R4
    R --> R2 --> R4
    R --> R3

    subgraph Indexes
      I1[Single / Composite]
      I2[Unique]
      I3[Filtered (HasFilter)]
      I4[Include (HasDatabaseName/IncludeProperties)]
    end
    I --> I1 --> I2
    I --> I3
    I --> I4

    subgraph Owned
      O1[OwnsOne]
      O2[OwnsMany]
      O3[ToTable/WithOwner]
    end
    O --> O1 --> O3
    O --> O2 --> O3

    subgraph Conversions
      V1[ValueConverter]
      V2[Precision / ColumnType]
      V3[Enums / Strongly-typed IDs]
    end
    V --> V1 --> V3
    V --> V2

    subgraph Filters
      F1[HasQueryFilter]
      F2[Soft Delete]
      F3[Multi-Tenancy]
      F4[Per-Request Params]
    end
    F --> F1 --> F2
    F --> F3 --> F4
```
### 🛠 Мини-примеры к каждому блоку

#### Keys
```csharp
builder.Entity<Order>()
	.HasKey(o => o.Id);                    // PK
builder.Entity<User>()
	.HasAlternateKey(u => u.Email);         // Alternate key
builder.Entity<LineItem>()
	.HasKey(li => new { li.OrderId, li.Seq }); // Composite
```
#### Relations
```csharp
// 1:N
builder.Entity<Order>()
    .HasMany(o => o.Items)
    .WithOne(i => i.Order)
    .HasForeignKey(i => i.OrderId)
    .OnDelete(DeleteBehavior.Cascade);

// 1:1
builder.Entity<User>()
    .HasOne(u => u.Profile)
    .WithOne(p => p.User)
    .HasForeignKey<UserProfile>(p => p.UserId);

// N:M (skip entity auto)
builder.Entity<Post>()
    .HasMany(p => p.Tags)
    .WithMany(t => t.Posts)
    .UsingEntity(j => j.ToTable("PostTags"));

```
#### Indexes
```csharp
builder.Entity<User>()
    .HasIndex(u => u.Email)
    .IsUnique();

builder.Entity<Order>()
    .HasIndex(o => new { o.CustomerId, o.CreatedAt })
    .HasFilter("[IsDeleted] = 0"); // SQL Server пример

// Include-колонки (провайдерозависимо)
builder.Entity<Order>()
    .HasIndex(o => o.CustomerId)
    .IncludeProperties(o => new { o.Total, o.Status });

```
#### Owned Types
```csharp
builder.Entity<Customer>().OwnsOne(c => c.Address, a =>
{
    a.Property(p => p.Street).HasMaxLength(200);
    a.ToTable("CustomerAddresses"); // опционально вынести в отдельную таблицу (TPH/TPT зависит от настройки)
});

builder.Entity<Order>().OwnsMany(o => o.AuditEntries, ae =>
{
    ae.WithOwner().HasForeignKey("OrderId");
    ae.Property<DateTime>("CreatedAt");
    ae.ToTable("OrderAudits");
});

```
#### ValueConverter / Precision
```csharp
// Strongly-typed ID
var idConverter = new ValueConverter<OrderId, Guid>(
    v => v.Value, v => new OrderId(v));

builder.Entity<Order>()
    .Property(o => o.Id)
    .HasConversion(idConverter);

builder.Entity<Product>()
    .Property(p => p.Price)
    .HasPrecision(18, 2); // или HasColumnType("decimal(18,2)")

```
#### Global Query Filters
```csharp
// Soft delete
builder.Entity<Order>().HasQueryFilter(o => !o.IsDeleted);

// Multitenancy (параметр из контекста/сервиса)
builder.Entity<Order>().HasQueryFilter(o => o.TenantId == _tenantProvider.TenantId);
// Важно: при пуллинге DbContext не «шьём» Tenant внутрь модели.
// Передавайте параметр через контекст запроса/интерцепторы безопасным способом.

```

## 📜 Памятка для интервью (тезисы)

- **Приоритеты:** Conventions < Data Annotations < Fluent API.    
- **Структура:** выносите конфигурации в `IEntityTypeConfiguration<T>` и подключайте `ApplyConfigurationsFromAssembly(...)`.    
- **Производительность:** задавайте точные типы (`HasPrecision`), индексы, `AsNoTracking` для чтения; избегайте N+1 через явные Include/проектирование.    
- **Безопасность модели:** не вносите per-user/per-tenant состояние в модель при пуллинге — используйте фильтры/интерцепторы с параметрами операции.    
- **Миграции:** источник истины — итоговая `IModel`; держите модель детерминированной и воспроизводимой.

## 🃏 Ссылки 
[[ModelConfiguration]]
https://chatgpt.com/c/6899dbe8-427c-8326-89a5-96567a998645


---

**Tags:** #EFCore #01_Basics #ModelConfiguration
