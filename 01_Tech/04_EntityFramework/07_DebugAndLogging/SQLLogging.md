# SQL Logging in EF Core
tags:: #efcore #logging #diagnostics #sql

## 💡 Concept
EF Core позволяет логировать все SQL‑запросы, выполняемые контекстом, включая параметры, время выполнения и ошибки.

---

## ⚙️ Быстрое включение (через ILogger)
```csharp
using var loggerFactory = LoggerFactory.Create(builder =>
{
    builder
        .AddFilter("Microsoft.EntityFrameworkCore.Database.Command", LogLevel.Information)
        .AddConsole();
});

var options = new DbContextOptionsBuilder<AppDbContext>()
    .UseLoggerFactory(loggerFactory)
    .EnableSensitiveDataLogging()   // показывает значения параметров
    .Options;

using var db = new AppDbContext(options);
```

---

## 📋 Пример вывода
```text
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (15ms) [Parameters=[@p0='1'], CommandType='Text']
      SELECT [u].[Id], [u].[Name]
      FROM [Users] AS [u]
      WHERE [u].[Id] = @p0
```

---

## 🧩 Полезные флаги
- `EnableDetailedErrors()` — включает более информативные ошибки EF.
- `EnableSensitiveDataLogging()` — показывает значения параметров (⚠️ осторожно в проде).
- `LogTo(...)` — кастомный обработчик логов.

```csharp
optionsBuilder.LogTo(Console.WriteLine, LogLevel.Information);
```

---

## 🧠 Советы
- Для временного профилирования можно использовать **MiniProfiler** или **EFCoreSecondLevelCacheInterceptor**.
- Логирование SQL помогает выявлять N+1, неоптимальные Includes и отсутствие индексов.