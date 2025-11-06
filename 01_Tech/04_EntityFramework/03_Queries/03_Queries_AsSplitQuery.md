---
tags: [ef-core, queries, performance]
aliases: [AsSplitQuery, Split Query, EFCore Split Queries]
---
# EF Core – AsSplitQuery

## Обзор
`AsSplitQuery()` заставляет Entity Framework Core выполнять подгрузку навигационных свойств с помощью **нескольких SQL-запросов**, а не одного большого JOIN.

## Пример
```csharp
var orders = context.Orders
    .Include(o => o.Items)
    .AsSplitQuery()
    .ToList();
```

## Когда использовать
- Когда `Include` создаёт слишком большой JOIN, вызывающий **дублирование строк** и **падение производительности**.  
- При загрузке больших коллекций или сложных иерархий навигаций.

## Подводные камни
- Каждый `Include` выполняет отдельный запрос → больше round-trips.  
- При `Skip/Take` и `Distinct` возможны неожиданные результаты.  
- Некоторые провайдеры могут иметь собственные ограничения.

## Связанные темы
- [[03_Queries/Loading_Strategies]]
- [[03_Queries/Projections]]
- [[03_Queries/LINQ_Notes]]
