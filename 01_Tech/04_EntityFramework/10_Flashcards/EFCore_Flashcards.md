# EF Core Flashcards
#tag: #flashcard

Q: What is Entity Framework Core?
??
A: EF Core is an open-source, cross-platform ORM for .NET that maps .NET objects to database tables and handles data access.

Q: What is an ORM?
??
A: Object-Relational Mapper; it maps objects in code to relational database tables.

Q: What is the difference between EF Core and EF 6? 
??
A: EF Core is cross-platform, lightweight, supports LINQ improvements, and some features like batch operations, but lacks some EF6 features like lazy loading proxies by default.

Q: What is DbContext?
??
A: A session with the database for querying and saving data; manages entity objects during runtime.

Q: How to configure a DbContext in EF Core?
??
A: Use `OnConfiguring` method or pass `DbContextOptions` via dependency injection.

Q: What is a Migration in EF Core?
??
A: A way to incrementally update the database schema from your model changes.

Q: Command to add a migration? 
??
A: `dotnet ef migrations add MigrationName`

Q: Command to apply migrations? 
??
A: `dotnet ef database update`

Q: What is Change Tracker? 
??
A: Component in EF Core that keeps track of entity state changes for persistence.

Q: Entity states in EF Core? 
??
A: Added, Modified, Deleted, Unchanged, Detached.

Q: What is Lazy Loading? 
??
A: Delayed loading of related entities upon first access, requires enabling proxies or manual loading.

Q: What is Eager Loading? 
??
A: Loading related entities as part of the initial query using `Include()`.

Q: What is Explicit Loading? 
??
A: Loading related data explicitly with `context.Entry(entity).Collection(...).Load()`.

Q: Difference between Include() and ThenInclude()? 
??
A: `Include()` loads related entity; `ThenInclude()` loads related data from the included entity.

Q: How does AsNoTracking improve performance? 
??
A: Disables Change Tracker, reducing overhead for read-only queries.

Q: What is Compiled Query? 
??
A: A precompiled LINQ query to avoid translation cost for frequently executed queries.

Q: How to execute raw SQL in EF Core safely? 
??
A: Use `FromSqlInterpolated` or parameterized queries to avoid SQL injection.

Q: How to handle transactions in EF Core? 
??
A: Use `DbContext.Database.BeginTransaction()` or `TransactionScope`.

Q: What is Optimistic Concurrency? 
??
A: Assumes multiple transactions can complete without affecting each other; detects conflicts at save time.

Q: What is Pessimistic Concurrency? 
??
A: Locks data to prevent other transactions from modifying it until the lock is released.

Q: How to enable Lazy Loading in EF Core? 
??
A: Install `Microsoft.EntityFrameworkCore.Proxies` and enable it in `OnConfiguring` or DI.

Q: What is the N+1 problem? 
??
A: A performance issue when each entity query triggers an additional query for related data.

Q: How to solve N+1 problem? 
??
A: Use Eager Loading (`Include`) or projection.

Q: What are Value Conversions? 
??
A: Convert property values when reading/writing to the database.

Q: What is Shadow Property? 
??
A: A property not in the entity class but tracked by EF Core.

Q: How to configure relationships in EF Core? 
??
A: Use Fluent API in `OnModelCreating` or data annotations.

Q: Difference between HasKey() and HasAlternateKey()? 
??
A: `HasKey()` defines the primary key; `HasAlternateKey()` defines an alternate unique key.

Q: What is a Navigation Property? 
??
A: A property on an entity that points to related entities.

Q: What is a Foreign Key? 
??
A: A property that links one entity to another via a relationship.

Q: How to log generated SQL in EF Core? 
??
A: Configure logging with `ILoggerFactory` or `LogTo` in `OnConfiguring`.

Q: What is Database First vs Code First? 
??
A: Database First: generate models from existing DB. Code First: define models in code, generate DB schema from them.

Q: How to seed initial data in EF Core? 
??
A: Use `modelBuilder.Entity<>().HasData()` in `OnModelCreating`.

Q: What are Owned Entities? 
??
A: Entities that do not have their own identity and are part of another entity.

Q: How to handle multiple DbContexts? 
??
A: Configure each with its own options and connection string.

Q: Can EF Core work without a database? 
??
A: Yes, using the InMemory provider for testing.

Q: What is Split Query in EF Core? 
??
A: Loads related collections with separate SQL queries instead of one big join.

Q: What is Single Query in EF Core? 
??
A: Loads related collections in a single SQL query (default before EF Core 5).

Q: How to detect performance issues in EF Core? 
??
A: Use logging, profiling tools, and look for excessive queries or N+1 issues.

Q: How to execute stored procedures in EF Core? 
??
A: Use `FromSqlRaw` or `ExecuteSqlRaw`.

Q: What is the purpose of ToListAsync()? 
??
A: Executes query asynchronously and materializes the results into a list.

Q: How to disable Change Tracker for a specific query? 
??
A: Use `AsNoTracking()`.

Q: What is a Compiled Model in EF Core? 
??
A: Pre-builds model metadata at compile-time to improve startup performance.

Q: How to roll back a transaction in EF Core? 
??
A: Call `transaction.Rollback()` on the transaction object.

Q: What is the difference between First() and FirstOrDefault()? 
??
A: `First()` throws if no match; `FirstOrDefault()` returns default value.

Q: How to paginate results in EF Core? 
??
A: Use `Skip()` and `Take()` with an ordered query.

Q: How to execute LINQ queries asynchronously in EF Core? 
??
A: Use async versions like `ToListAsync`, `FirstOrDefaultAsync`.

Q: How to set default values for a property in EF Core? 
??
A: Configure via Fluent API or annotations with `HasDefaultValue`.

Q: What is the difference between Add() and Attach()? 
??
A: `Add()` marks entity as Added, will be inserted; `Attach()` marks as Unchanged, only tracked.

Q: What does AsSplitQuery() do in EF Core?
??
A: It splits a single complex query with multiple Includes into separate SQL queries, reducing duplication and memory load.

Q: When should you use AsSplitQuery()?
??
A: When a single joined query causes performance issues due to Cartesian explosion of rows.

Q: What are the main loading strategies in EF Core?
??
A: Eager, Lazy, and Explicit loading.

Q: How does Explicit Loading differ from Lazy Loading?
??
A: Explicit Loading requires manual calls to `.Load()` methods; Lazy Loading happens automatically upon first property access.

Q: What is a Projection in EF Core?
??
A: Selecting only specific properties or computed values with LINQ `Select`, often mapped into DTOs.

Q: Why can some Select projections fail in EF Core?
??
A: Because not all .NET methods or expressions can be translated to SQL; EF may throw an exception or perform client evaluation.

Q: What happens if EF Core cannot translate a part of a LINQ expression to SQL?
??
A: It either executes that part in memory (client evaluation) or throws an exception, depending on configuration.
