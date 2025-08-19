# CompiledQueries

## 🧠 Quick Recall (Trigger)
EF supports _compiled queries_, which allow the explicit compilation of a LINQ query into a .NET delegate. Once this delegate is acquired, it can be invoked directly to execute the query, without providing the LINQ expression tree.

---

## 📜 Interview-Ready Explanation
Once this delegate is acquired, it can be invoked directly to execute the query, without providing the LINQ expression tree. This technique bypasses the cache lookup, and provides the most optimized way to execute a query in EF Core. 

---

## 💻 Code Examples

To use compiled queries, first compile a query with [EF.CompileAsyncQuery](https://learn.microsoft.com/en-us/dotnet/api/microsoft.entityframeworkcore.ef.compileasyncquery) as follows (use [EF.CompileQuery](https://learn.microsoft.com/en-us/dotnet/api/microsoft.entityframeworkcore.ef.compilequery) for synchronous queries):
```csharp
static readonly Func<MyDbContext, int, Task<Customer?>> _compiledQuery =
    EF.CompileAsyncQuery((MyDbContext ctx, int id) =>
        ctx.Customers.FirstOrDefault(c => c.Id == id));
```
In this code sample, we provide EF with a lambda accepting a `DbContext` instance, and an arbitrary parameter to be passed to the query. You can now invoke that delegate whenever you wish to execute the query:
```csharp
var customer = await _compiledQuery(context, 42);
```
Note that the delegate is thread-safe, and can be invoked concurrently on different context instances.

---

## 🚨 Common Pitfalls
- Compiled queries may only be used against a single EF Core model. Different context instances of the same type can sometimes be configured to use different models; running compiled queries in this scenario is not supported. See more details [[https://chatgpt.com/c/68a2e6bc-b680-832d-9b78-d35d06e10f13|here]].
- When using parameters in compiled queries, use simple, scalar parameters. More complex parameter expressions - such as member/method accesses on instances - are not supported.



**Tags:** #EFCore #04_Performance #CompiledQueries
