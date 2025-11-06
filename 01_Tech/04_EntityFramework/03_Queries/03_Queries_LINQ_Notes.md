---
tags: [ef-core, linq, queries]
aliases: [LINQ, EF Core LINQ]
---
# EF Core – LINQ Особенности

## Основы
LINQ-запросы в EF Core транслируются в SQL до вызова операторов материализации (`ToList`, `First`, `Single`, и т.д.).  
EF выполняет только то, что может выразить в SQL. Всё остальное — ошибка или client evaluation.

## Примеры
```csharp
var page = context.Orders
    .Where(o => o.Status == OrderStatus.Paid)
    .OrderByDescending(o => o.CreatedAt)
    .Skip(10)
    .Take(5)
    .ToList();
```

## Важно помнить
- Методы .NET не всегда транслируются (например, `Math.Sin`, `Regex` и т.д.).  
- После `ToList()` всё выполняется в памяти.  
- `GroupBy` работает не так, как LINQ-to-Objects.  

## Пример ошибки перевода
```csharp
var q = context.Orders
    .Select(o => new { Rounded = Math.Round(o.Total, 1) }) // ошибка
    .ToList();
```
> The LINQ expression could not be translated.

## Связанные темы
- [[03_Queries/Projections]]
- [[03_Queries/AsSplitQuery]]
