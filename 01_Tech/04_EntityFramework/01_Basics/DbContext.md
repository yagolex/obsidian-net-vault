# DbContext

## 🧠 Quick Recall (Trigger)
Abstraction of the DB structure in code (Unit of Work + Change Tracker):
	- lists the models and their DB table names
	- instantiates a DB connection during application runtime
	- allow DB objects manipulation (create, update, etc with DB tables)

## 📜 Interview-Ready Explanation
Here is the list of Context responsibilities:
- `DbContext` создаётся (DI или вручную).    
- Подтягивает конфигурацию подключения и модель.    
- Запросы LINQ превращаются в SQL → результат материализуется в объекты.    
- Если включён трекинг, `ChangeTracker` запоминает изменения.    
- `SaveChanges()` формирует SQL-команды и отправляет их в одной транзакции.    
- После `Dispose` все ресурсы освобождаются.

Если ChangeTracker включен, то он содержит граф сущностей. Поэтому отключение его за ненадобностью освобождает память и ускоряет производительность.

## Related References:
[[DbContext-lifecycle]]
[[DbContext-pooling]]

**Tags:** #EFCore #01_Basics #DbContext
