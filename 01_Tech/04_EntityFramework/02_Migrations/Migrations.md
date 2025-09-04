# EF DB Migrations 

## 🧠 What is DB Migration
A way to incrementally update the database schema from your model changes. 

EF-миграция — это версионированный набор инструкций (C# + сгенерированный снимок модели `ModelSnapshot`), который переводит схему БД из состояния **N** в состояние **N+1** и обратно (через `Down`). EF хранит применённые версии в таблице `__EFMigrationsHistory`. Это решает «drift» между кодовой моделью и реальной БД и позволяет воспроизводимо раскатывать/откатывать изменения схемы вместе с кодом.

---

## 📜 Create Migration

Настроить `DbContext` и подключение (обычно через `IHostBuilder`/`AddDbContext`).

`dotnet ef migrations add MigrationName`

Проверить код миграции: методы `Up/Down`, `CreateTable`, `AddColumn`, `Sql(...)` для сложных шагов, корректность `ModelSnapshot`.

### 🛠 Полезное
- Удалить последнюю неподходящую миграцию: `dotnet ef migrations remove` (если не применена в БД).    
- Сгенерировать SQL-скрипт для ревью:  
    `dotnet ef migrations script` (с начала) или `dotnet ef migrations script FromMig ToMig`.

---

## 💻 Apply Migration

- Быстро накатить в локальную БД:

`dotnet ef database update`

- Автонакат при старте сервиса (удобно только для dev/test):

```csharp
using var scope = app.Services.CreateScope();
var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
db.Database.Migrate(); // НЕ делайте так на проде без крайней нужды
```

- Через SQL-скрипты (рекомендовано для прод):
	- Генерируем скрипт:

```bash
# Дифф от текущего: 
dotnet ef migrations script -o sql/2025-08-25_prod.sql

# Идемпотентный (можно запускать повторно в любом окружении):
dotnet ef migrations script --idempotent -o sql/2025-08-25_prod_idem.sql

```
- Скрипт проходит ревью/апрув DBA, попадает в релиз-артефакты и исполняется инструментом деплоя (Azure DevOps, Octopus, Flyway-style, Liquibase-style, ручной запуск DBA и т.п.).

- Через Migration Bundle
- 

**Tags:** #EFCore #02_Migrations 
