# DbContext lifecycle

## 📜 Interview-Ready Explanation
The DbContext in Entity Framework Core is designed as a lightweight object to manage interactions with a database for a single unit of work. Its lifecycle, therefore, is typically short-lived and tied to the scope of a specific operation or request.

### Key aspects of the DbContext lifecycle:
#### Creation:
A DbContext instance is created at the beginning of a unit of work. This can be done manually using new ApplicationDbContext() or, more commonly in modern ASP.NET Core applications, through Dependency Injection (DI).
#### Usage:
Within its lifetime, the DbContext tracks changes to entities, performs queries, and prepares changes for persistence. It acts as a unit of work, allowing multiple operations to be grouped and committed together.
#### Disposal:
The DbContext instance should be disposed of once the unit of work is complete. This releases resources, such as database connections, and ensures proper cleanup.
- using statement: For simple, isolated operations, the using statement ensures automatic disposal.
- Dependency Injection (Scoped Lifetime): In web applications (e.g., ASP.NET Core), DbContext is typically registered with a "scoped" lifetime in the DI container. This means a new instance is created for each HTTP request and automatically disposed at the end of the request.
- IDbContextFactory: For scenarios like background services or Blazor Server applications where a single DbContext might span multiple operations or connections, IDbContextFactory can be used to explicitly create and dispose of DbContext instances as needed for each operation.
### Important Considerations:
#### Short-lived:
DbContext instances are not thread-safe and are not intended for long-term use or sharing across multiple threads or requests.
#### Avoid Singletons:
Using a singleton lifetime for DbContext can lead to concurrency issues, data inconsistencies, and memory leaks. 
#### Unit of Work:
The DbContext embodies the Unit of Work pattern, allowing a set of operations to be treated as a single transaction.

**Tags:** #EFCore #01_Basics #DbContext
