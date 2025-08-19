# Interceptors в EF Core

## Что это такое

В **Entity Framework Core** интерсепторы (Interceptors) --- это
механизм, который позволяет перехватывать и изменять выполнение
определённых операций на уровне EF Core, до или после того как они будут
выполнены. По сути, это «хуки» для работы с событиями жизненного цикла
EF Core.

## Зачем нужны интерсепторы

Они позволяют: - Логировать SQL-запросы и параметры до их выполнения. -
Модифицировать SQL-запросы (например, добавлять хинты). - Реализовывать
кэширование или собственные механизмы аудита. - Влиять на процесс
подключения к базе данных (например, добавлять retry-политику). -
Отлавливать ошибки и реагировать на них.

## Отличие от ChangeTracker и событий

-   `ChangeTracker` работает только с сущностями в памяти (например, при
    `SaveChanges`).
-   События EF Core (например, `SavingChanges`) больше связаны с
    DbContext.
-   **Интерсепторы работают глубже** --- на уровне ADO.NET команд,
    транзакций, соединений.

## Основные типы интерсепторов

-   **Подключение к БД**\
    `IDbConnectionInterceptor` -- позволяет отслеживать
    открытие/закрытие соединений.

-   **Команды (SQL)**\
    `IDbCommandInterceptor` -- перехватывает выполнение SQL-запросов
    (`SELECT`, `INSERT`, `UPDATE`, `DELETE`).

-   **Транзакции**\
    `IDbTransactionInterceptor` -- работа с транзакциями (начало,
    коммит, откат).

-   **Сохранение изменений**\
    `ISaveChangesInterceptor` -- перехват вызова `SaveChanges()` /
    `SaveChangesAsync()`.

-   **Материализация сущностей**\
    `IMaterializationInterceptor` -- позволяет изменить процесс создания
    объекта из результата SQL.

## Пример: логирование SQL через IDbCommandInterceptor

``` csharp
public class LoggingCommandInterceptor : DbCommandInterceptor
{
    public override InterceptionResult<DbDataReader> ReaderExecuting(
        DbCommand command,
        CommandEventData eventData,
        InterceptionResult<DbDataReader> result)
    {
        Console.WriteLine($"Executing SQL: {command.CommandText}");
        return base.ReaderExecuting(command, eventData, result);
    }
}
```

Регистрация в DbContext:

``` csharp
public class AppDbContext : DbContext
{
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder
            .UseSqlServer("connection_string")
            .AddInterceptors(new LoggingCommandInterceptor());
    }
}
```

## Пример: аудит через ISaveChangesInterceptor

``` csharp
public class AuditInterceptor : SaveChangesInterceptor
{
    public override int SavedChanges(SaveChangesCompletedEventData eventData, int result)
    {
        Console.WriteLine($"Saved {result} entities at {DateTime.Now}");
        return base.SavedChanges(eventData, result);
    }
}
```

## Когда использовать

-   Если нужно **централизованно контролировать все SQL-запросы** или
    операции с БД.
-   Если требуется **глобальный кросс-контекстный функционал**
    (например, аудит, кэш, логирование).
-   Если обычные события `DbContext` или `ChangeTracker` слишком
    высокоуровневые.

## References
https://chatgpt.com/c/68a45b19-dd3c-8330-8a53-9fca3f32da99
[[DbContext]]


**Tags:** [#EFCore](app://obsidian.md/index.html#EFCore) [#01_Basics](app://obsidian.md/index.html#01_Basics) [#Interceptors](app://obsidian.md/index.html#Interceptors)

