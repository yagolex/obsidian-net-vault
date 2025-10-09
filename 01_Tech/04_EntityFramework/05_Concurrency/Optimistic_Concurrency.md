
# Optimistic Concurrency in EF Core
tags:: #efcore #concurrency #optimistic #rowversion

## 💡 Concept

**Optimistic Concurrency** — стратегия без блокировок: EF Core предполагает, что конфликты случаются редко.  Поэтому при чтении данные не блокируются, но при `SaveChanges()` EF **проверяет, не изменилась ли запись в БД** с момента последнего чтения (с помощью **токена конкурентности**). 


---

## ⚙️ Токен конкурентности (RowVersion / Timestamp)

- Для SQL Server это системная колонка  типа `rowversion` (старое имя `timestamp`).
	- PostgreSQL: системная колонка `xmin` (через конфигурацию);
	- Либо любое поле (например `UpdatedAt`), помеченное как токен в модели 
```csharp
  // RowVersion (SQL Server)
builder.Entity<Order>()
    .Property(o => o.RowVersion)
    .IsRowVersion(); // автоматически делает свойство concurrency token

// Универсально (любое поле)
builder.Entity<Order>()
    .Property(o => o.UpdatedAt)
    .IsConcurrencyToken();

// Data Annotations
public class Order {
    public int Id { get; set; }

    [Timestamp]             // для rowversion
    public byte[] RowVersion { get; set; } = default!;
}

```
- Каждая строка имеет бинарное значение (8 байт), которое **автоматически обновляется** при каждом `UPDATE`.
- EF Core сохраняет прочитанное значение `RowVersion` в `OriginalValues`.
- При сохранении EF генерирует SQL:
  ```sql
  UPDATE Orders
  SET Total = @Total
  WHERE Id = @Id AND RowVersion = @OriginalRowVersion;
  ```
- Если `UPDATE` затронул 0 строк → строка была изменена кем-то ещё → EF выбрасывает `DbUpdateConcurrencyException`.

---

## 🧱 Пример (Обработка конфликта)


Стратегии:
- **Client Wins** (переписать базу нашими данными).    
- **Store Wins** (перечитать из БД, отменить наши изменения).    
- **Merge** (ручной мердж полей).

```csharp
public class Order
{
    public int Id { get; set; }
    public decimal Total { get; set; }

    [Timestamp] // SQL Server автоматически обновит значение при UPDATE
    public byte[] RowVersion { get; set; } = default!;
}

try
{
    await context.SaveChangesAsync();
}
catch (DbUpdateConcurrencyException ex)
{
    foreach (var entry in ex.Entries)
    {
	     // Перечитать текущие данные из БД
        var databaseValues = await entry.GetDatabaseValuesAsync();

        if (databaseValues == null)
        {
             // Строка удалена: решить, создаём заново или игнорируем
            entry.State = EntityState.Detached;
            continue;
        }

        var dbOrder = (Order)databaseValues.ToObject();
        var clientOrder = (Order)entry.Entity;

        Console.WriteLine($"Conflict detected! DB total={dbOrder.Total}, Client={clientOrder.Total}");

        // Вариант Store Wins (принимаем БД)
        entry.OriginalValues.SetValues(databaseValues); // сбросить оригинальные
        entry.CurrentValues.SetValues(databaseValues);  // принять БД
        entry.State = EntityState.Unchanged;

        // Вариант Client Wins (осторожно! перезаписываем БД)
        // entry.OriginalValues.SetValues(databaseValues);
        // entry.State = EntityState.Modified; // перезапишет БД нашими значениями
        
        // Вариант Merge: сравнить entry.CurrentValues vs databaseValues и выбрать поле-за-полем
    }

    await context.SaveChangesAsync();
}
```

---

## 🧩 Кто сравнивает RowVersion

EF Core делает это **сам при выполнении UPDATE**:
- EF подставляет старое значение `RowVersion` в `WHERE`.
- SQL Server сравнивает это значение с текущим.
- Если строка изменилась — сравнение не проходит (`0 rows affected`).
- EF видит `0 rows` и выбрасывает `DbUpdateConcurrencyException`.

Таким образом, **сравнение делает СУБД**, а EF только обрабатывает результат.

## 🃏 Связанные темы
- [[OptimisticConcurrency_ETag]]
- [[Transaction_Isolation]]