# 📚 EF Core Glossary

## Change Tracker
EF Core component that tracks entity states and persists changes to the database.

## Navigation Property
A property on an entity that references a related entity or collection of entities.

## Compiled Queries
Precompiled LINQ queries to reduce translation overhead in hot paths.

## AsSplitQuery
Loads related data using multiple SQL queries instead of a single large JOIN. Useful to avoid Cartesian explosion in complex Includes.

## Eager Loading
Strategy that loads related entities immediately via `Include()` and `ThenInclude()`.

## Lazy Loading
Strategy that loads related entities on first access, often using dynamic proxies.

## Explicit Loading
Manual loading of related data via `context.Entry(entity).Reference(...).Load()` or `.Collection(...).Load()`.

## Projection
A LINQ operation that selects only specific fields or computed values instead of full entities.

## Client Evaluation
When EF Core executes part of the query in memory because it cannot translate the expression to SQL.
