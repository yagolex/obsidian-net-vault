---
aliases:
  - '["UoW"]'
"topic:": OOP
"subtopic:": pattern
"level:": Understand
"type:": pattern
"status:": ready
"tags:": "#patterns, #architecture, #csharp, #uow, #ado.net, #dapper"
---


# Что такое Unit of Work

**Unit of Work** — это объект, который:
1) группирует изменения как единую «единицу работы»;  
2) обеспечивает атомарную фиксацию/откат (commit/rollback);  
3) часто даёт общий транзакционный контекст для репозиториев/DAO;  
4) (опционально) координирует побочные эффекты (доменные события, outbox).

Минимальная обязанность — **одна транзакция на набор операций**.

---

## Интерфейсы (ядро паттерна)

```csharp
public interface IUnitOfWork : IAsyncDisposable
{
    Task BeginAsync(CancellationToken ct = default);
    Task CommitAsync(CancellationToken ct = default);
    Task RollbackAsync(CancellationToken ct = default);
}

public interface IRepository<T>
{
    Task<T?> GetAsync(object id, CancellationToken ct = default);
    Task AddAsync(T entity, CancellationToken ct = default);
    Task UpdateAsync(T entity, CancellationToken ct = default);
    Task DeleteAsync(object id, CancellationToken ct = default);
}
```

---

## Реализация UoW поверх ADO.NET (провайдер-независимо)

```csharp
using System.Data;
using System.Data.Common;

public sealed class AdoNetUnitOfWork : IUnitOfWork
{
    private readonly DbConnection _conn;
    private DbTransaction? _tx;
    private bool _begun;

    public AdoNetUnitOfWork(DbConnection connection)
    {
        _conn = connection ?? throw new ArgumentNullException(nameof(connection));
    }

    public IDbConnection Connection => _conn;
    public IDbTransaction? Transaction => _tx;

    public async Task BeginAsync(CancellationToken ct = default)
    {
        if (_begun) return;
        if (_conn.State != ConnectionState.Open)
            await _conn.OpenAsync(ct);
        _tx = await _conn.BeginTransactionAsync(ct);
        _begun = true;
    }

    public async Task CommitAsync(CancellationToken ct = default)
    {
        if (!_begun) return;
        await (_tx?.CommitAsync(ct) ?? Task.CompletedTask);
        await DisposeAsync();
    }

    public async Task RollbackAsync(CancellationToken ct = default)
    {
        if (!_begun) return;
        await (_tx?.RollbackAsync(ct) ?? Task.CompletedTask);
        await DisposeAsync();
    }

    public async ValueTask DisposeAsync()
    {
        if (_tx is not null) { await _tx.DisposeAsync(); _tx = null; }
        await _conn.DisposeAsync();
        _begun = false;
    }
}
```

> Такой UoW держит **подключение + транзакцию**. Вы можете передавать их репозиториям.

---

## Репозитории: ADO.NET- и Dapper-варианты

### 1) Чистый ADO.NET

```csharp
public sealed class Customer
{
    public int Id { get; init; }
    public string Name { get; set; } = "";
}

public interface ICustomerRepository : IRepository<Customer> { }

public sealed class CustomerRepository : ICustomerRepository
{
    private readonly AdoNetUnitOfWork _uow;
    public CustomerRepository(AdoNetUnitOfWork uow) => _uow = uow;

    public async Task<Customer?> GetAsync(object id, CancellationToken ct = default)
    {
        using var cmd = _uow.Connection.CreateCommand();
        cmd.Transaction = (DbTransaction?)_uow.Transaction;
        cmd.CommandText = "SELECT Id, Name FROM Customers WHERE Id = @id";
        var p = cmd.CreateParameter(); p.ParameterName = "@id"; p.Value = (int)id;
        cmd.Parameters.Add(p);

        using var rdr = await ((DbCommand)cmd).ExecuteReaderAsync(ct);
        if (!await rdr.ReadAsync(ct)) return null;
        return new Customer { Id = rdr.GetInt32(0), Name = rdr.GetString(1) };
    }

    public async Task AddAsync(Customer e, CancellationToken ct = default)
    {
        using var cmd = _uow.Connection.CreateCommand();
        cmd.Transaction = (DbTransaction?)_uow.Transaction;
        cmd.CommandText = "INSERT INTO Customers (Name) VALUES (@name);";
        var p = cmd.CreateParameter(); p.ParameterName = "@name"; p.Value = e.Name;
        cmd.Parameters.Add(p);
        await ((DbCommand)cmd).ExecuteNonQueryAsync(ct);
    }

    public async Task UpdateAsync(Customer e, CancellationToken ct = default)
    {
        using var cmd = _uow.Connection.CreateCommand();
        cmd.Transaction = (DbTransaction?)_uow.Transaction;
        cmd.CommandText = "UPDATE Customers SET Name=@name WHERE Id=@id;";
        var p1 = cmd.CreateParameter(); p1.ParameterName = "@name"; p1.Value = e.Name;
        var p2 = cmd.CreateParameter(); p2.ParameterName = "@id";   p2.Value = e.Id;
        cmd.Parameters.Add(p1); cmd.Parameters.Add(p2);
        await ((DbCommand)cmd).ExecuteNonQueryAsync(ct);
    }

    public async Task DeleteAsync(object id, CancellationToken ct = default)
    {
        using var cmd = _uow.Connection.CreateCommand();
        cmd.Transaction = (DbTransaction?)_uow.Transaction;
        cmd.CommandText = "DELETE FROM Customers WHERE Id=@id;";
        var p = cmd.CreateParameter(); p.ParameterName = "@id"; p.Value = (int)id;
        cmd.Parameters.Add(p);
        await ((DbCommand)cmd).ExecuteNonQueryAsync(ct);
    }
}
```

### 2) Dapper (короче, но смысл тот же)

```csharp
using Dapper;

public sealed class CustomerRepositoryDapper : ICustomerRepository
{
    private readonly AdoNetUnitOfWork _uow;
    public CustomerRepositoryDapper(AdoNetUnitOfWork uow) => _uow = uow;

    public Task<Customer?> GetAsync(object id, CancellationToken ct = default) =>
        _uow.Connection.QuerySingleOrDefaultAsync<Customer>(
            new CommandDefinition(
                "SELECT Id, Name FROM Customers WHERE Id=@id",
                new { id }, _uow.Transaction, cancellationToken: ct));

    public Task AddAsync(Customer e, CancellationToken ct = default) =>
        _uow.Connection.ExecuteAsync(
            new CommandDefinition(
                "INSERT INTO Customers (Name) VALUES (@name)", 
                new { name = e.Name }, _uow.Transaction, cancellationToken: ct));

    public Task UpdateAsync(Customer e, CancellationToken ct = default) =>
        _uow.Connection.ExecuteAsync(
            new CommandDefinition(
                "UPDATE Customers SET Name=@name WHERE Id=@id",
                new { e.Name, e.Id }, _uow.Transaction, cancellationToken: ct));

    public Task DeleteAsync(object id, CancellationToken ct = default) =>
        _uow.Connection.ExecuteAsync(
            new CommandDefinition(
                "DELETE FROM Customers WHERE Id=@id",
                new { id }, _uow.Transaction, cancellationToken: ct));
}
```

---

## Сервис приложения: координация через UoW

```csharp
public sealed class CustomerService
{
    private readonly Func<DbConnection> _connFactory; // например, () => new NpgsqlConnection(cs)

    public CustomerService(Func<DbConnection> connFactory) => _connFactory = connFactory;

    public async Task RenameCustomerAsync(int id, string newName, CancellationToken ct)
    {
        await using var uow = new AdoNetUnitOfWork(_connFactory());
        await uow.BeginAsync(ct);

        var repo = new CustomerRepositoryDapper(uow);
        var c = await repo.GetAsync(id, ct) ?? throw new InvalidOperationException("Not found");

        c.Name = newName;
        await repo.UpdateAsync(c, ct);

        await uow.CommitAsync(ct);
    }
}
```

- Все репозитории, которые участвуют в операции, получают **один и тот же UoW** → общая транзакция.
- При ошибках выбрасываем исключение и вызываем `RollbackAsync()` (или rely on `DisposeAsync()` если вы так решите).

---

## Альтернатива: UoW как «реестр операций» (ORM-агностично)

Иногда вы не хотите отдавать внутрь репозиториев транзакцию/коннекшн. Тогда UoW может просто **накапливать действия**, которые выполнятся в транзакции при `CommitAsync()`:

```csharp
public sealed class ActionUnitOfWork : IUnitOfWork
{
    private readonly List<Func<IDbTransaction, CancellationToken, Task>> _ops = new();
    private readonly Func<DbConnection> _connFactory;

    public ActionUnitOfWork(Func<DbConnection> connFactory) => _connFactory = connFactory;

    public void Register(Func<IDbTransaction, CancellationToken, Task> op) => _ops.Add(op);

    public async Task BeginAsync(CancellationToken ct = default) { /* no-op */ }

    public async Task CommitAsync(CancellationToken ct = default)
    {
        await using var conn = _connFactory();
        await conn.OpenAsync(ct);
        await using var tx = await conn.BeginTransactionAsync(ct);

        foreach (var op in _ops)
            await op(tx, ct);

        await tx.CommitAsync(ct);
    }

    public Task RollbackAsync(CancellationToken ct = default)
    { _ops.Clear(); return Task.CompletedTask; }

    public ValueTask DisposeAsync() { _ops.Clear(); return ValueTask.CompletedTask; }
}
```

Репозиторий тогда не «знает» про транзакции, он регистрирует действия:

```csharp
public sealed class CustomerRepositoryQueued
{
    private readonly ActionUnitOfWork _uow;
    private readonly Func<DbConnection> _connFactory;

    public CustomerRepositoryQueued(ActionUnitOfWork uow, Func<DbConnection> connFactory)
    { _uow = uow; _connFactory = connFactory; }

    public void Add(Customer c)
    {
        _uow.Register(async (tx, ct) =>
        {
            using var cmd = tx.Connection!.CreateCommand();
            cmd.Transaction = tx;
            cmd.CommandText = "INSERT INTO Customers (Name) VALUES (@name)";
            var p = cmd.CreateParameter(); p.ParameterName = "@name"; p.Value = c.Name;
            cmd.Parameters.Add(p);
            await ((DbCommand)cmd).ExecuteNonQueryAsync(ct);
        });
    }
}
```

Плюс: репо остаются простыми; Минус: для чтения всё равно понадобится соединение.

---

## UoW для тестов: in-memory «хранилище с коммитом»

```csharp
public sealed class InMemoryUnitOfWork : IUnitOfWork
{
    private readonly List<Action> _ops = new();
    private bool _begun;

    public void Register(Action op) => _ops.Add(op);

    public Task BeginAsync(CancellationToken ct = default)
    { _begun = true; return Task.CompletedTask; }

    public Task CommitAsync(CancellationToken ct = default)
    {
        foreach (var op in _ops) op();
        _ops.Clear(); _begun = false;
        return Task.CompletedTask;
    }

    public Task RollbackAsync(CancellationToken ct = default)
    { _ops.Clear(); _begun = false; return Task.CompletedTask; }

    public ValueTask DisposeAsync() => ValueTask.CompletedTask;
}

// Пример использования
public sealed class InMemoryCustomerRepository
{
    private readonly Dictionary<int, Customer> _store;
    private readonly InMemoryUnitOfWork _uow;

    public InMemoryCustomerRepository(Dictionary<int, Customer> store, InMemoryUnitOfWork uow)
    { _store = store; _uow = uow; }

    public Task AddAsync(Customer c, CancellationToken ct = default)
    {
        _uow.Register(() => _store[c.Id] = c);
        return Task.CompletedTask;
    }
}
```

---

## Доменные события и Outbox (надстройка поверх UoW)

Частая практика — собирать события в течение UoW и публиковать **после успешного коммита** (или писать их в таблицу **Outbox** в той же транзакции).

Схема «после коммита» (упрощённо):

```csharp
public interface IDomainEvent { }

public sealed class DomainEventsBuffer
{
    private readonly List<IDomainEvent> _events = new();
    public void Add(IDomainEvent e) => _events.Add(e);
    public IReadOnlyList<IDomainEvent> Drain() { var c = _events.ToArray(); _events.Clear(); return c; }
}

public sealed class UowWithEvents : AdoNetUnitOfWork
{
    private readonly DomainEventsBuffer _bus;
    private readonly Func<IDomainEvent, Task> _publisher;

    public UowWithEvents(DbConnection conn, DomainEventsBuffer bus, Func<IDomainEvent, Task> publisher)
        : base(conn) { _bus = bus; _publisher = publisher; }

    public override async Task CommitAsync(CancellationToken ct = default)
    {
        await base.CommitAsync(ct);
        foreach (var e in _bus.Drain()) await _publisher(e); // «гарантированно после коммита»
    }
}
```

> Для строгой гарантии доставки используйте **Outbox**: событие записывается в таблицу в той же транзакции; отдельный процесс читает и публикует.

---

## Практические рекомендации

1) **Срок жизни** UoW = срок «единицы работы». Не делайте UoW долгоживущим.  
2) **Параллелизм**: один UoW/транзакция — на один поток/операцию. Не шарьте ни соединение, ни транзакцию.  
3) **Ошибки**: всегда делайте `try/commit` + `catch/rollback`.  
4) **Чтение vs запись**: используйте `AsNoTracking`-подобный подход — для чтения создавайте отдельный путь без участия UoW, если транзакция не нужна.  
5) **Границы**: ставьте UoW на **команду/юзкейс**, а не на «весь HTTP-запрос» механически, если запрос выполняет только чтение.  
6) **TransactionScope**: можно обернуть несколько ресурсов, но помните про DTC, провайдеры и `TransactionScopeAsyncFlowOption.Enabled`.  
7) **DI**: в веб-приложении UoW обычно регистрируется **Scoped**, в фоновых/Blazor-сценариях — создаётся **на операцию**.

---

## Короткий «end-to-end» пример

```csharp
// Регистрация (пример для Npgsql)
builder.Services.AddSingleton<Func<DbConnection>>(
    () => new Npgsql.NpgsqlConnection(builder.Configuration.GetConnectionString("Default")));

builder.Services.AddScoped<CustomerService>(); // сам uow создаём вручную в сервисе

// Использование
public sealed class CreateCustomerHandler
{
    private readonly Func<DbConnection> _connFactory;
    public CreateCustomerHandler(Func<DbConnection> connFactory) => _connFactory = connFactory;

    public async Task<int> HandleAsync(string name, CancellationToken ct)
    {
        await using var uow = new AdoNetUnitOfWork(_connFactory());
        await uow.BeginAsync(ct);

        var repo = new CustomerRepositoryDapper(uow);
        var customer = new Customer { Name = name };

        await repo.AddAsync(customer, ct);
        await uow.CommitAsync(ct);

        // в реальном коде вернётся сгенерированный Id (через RETURNING / SCOPE_IDENTITY()).
        return 0;
    }
}
```

---

**Итог:** UoW — это управляемая граница транзакции + координация репозиториев в рамках одной «единицы работы». На ADO.NET/Dapper это реализуется так же, как в любой ORM: *одна транзакция → несколько операций → commit/rollback*. 
