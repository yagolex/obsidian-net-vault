---
tags: [ef-core, projection, select, dto]
aliases: [Projections, Select, Client Evaluation]
---
# EF Core – Проекции (Projections)

## Обзор
Проекция — это выбор **только нужных полей** из сущности с помощью LINQ `Select`.

## Пример
```csharp
var dtos = context.Orders
    .Where(o => o.Status == OrderStatus.Paid)
    .Select(o => new OrderDto {
        Id = o.Id,
        Customer = o.Customer.Name,
        Total = o.Items.Sum(i => i.Price * i.Quantity)
    })
    .ToList();
```

## Зачем использовать
- Уменьшает количество данных, загружаемых из БД.  
- Повышает производительность.  
- Позволяет маппить результат прямо в DTO/ViewModel.

## Подводные камни
1. **Не всё переводится в SQL.**  
   Если EF не знает, как интерпретировать выражение, оно выполняется в памяти (client evaluation) или вызывает исключение.
   ```csharp
   var q = context.Products
       .Select(p => new { Rounded = Math.Round(p.Price, 2) }) // не всегда транслируется
       .ToList();
   ```
   В EF Core 3+ client evaluation по умолчанию запрещена — будет исключение:
   > The LINQ expression could not be translated.

2. **Не все методы поддерживаются.**  
   Только те, что можно преобразовать в SQL (`StartsWith`, `Contains`, `EF.Functions.Like` и т.п.).

3. **Подзапросы и агрегаты.**  
   Некоторые выражения с `GroupBy` и `Sum` могут не работать, если содержат .NET-функции без SQL-аналога.

4. **Навигации.**  
   Ссылки вида `o.Customer.Name` работают, но `o.Customer.Orders.Count()` может породить подзапрос.

## Связанные темы
- [[03_Queries/LINQ_Notes]]
- [[03_Queries/AsSplitQuery]]
