# 🧱 EF Core — Управление миграциями

## 1. Добавление новой миграции
```bash
dotnet ef migrations add <ИмяМиграции>
```

**Пример:**
```bash
dotnet ef migrations add InitCreate
```

Создаёт новую миграцию на основе изменений в моделях.
→ В папке `Migrations` появятся два файла:
- `YYYYMMDDHHMMSS_<ИмяМиграции>.cs`
- `ModelSnapshot.cs`

---

## 2. Применение миграций к базе данных
```bash
dotnet ef database update
```
или с указанием конкретной миграции:
```bash
dotnet ef database update <ИмяМиграции>
```

**Примеры:**
```bash
dotnet ef database update
dotnet ef database update InitCreate
```

---

## 3. Откат базы данных
```bash
dotnet ef database update <ИмяПредыдущейМиграции>
```
Чтобы откатить все миграции:
```bash
dotnet ef database update 0
```

---

## 4. Удаление последней миграции
```bash
dotnet ef migrations remove
```

Если миграция уже применена:
```bash
dotnet ef database update <ИмяПредыдущейМиграции>
dotnet ef migrations remove
```

---

## 5. Просмотр списка миграций
Все:
```bash
dotnet ef migrations list
```

Только применённые:
```bash
dotnet ef migrations list --applied
```

---

## 6. Генерация SQL-скриптов
Все миграции:
```bash
dotnet ef migrations script
```

Между двумя миграциями:
```bash
dotnet ef migrations script <От> <До>
```

**Примеры:**
```bash
dotnet ef migrations script InitCreate AddOrderTable
dotnet ef migrations script 0 AddOrderTable
```

---

## 7. Указание контекста и проектов
Если контекст не найден:
```bash
dotnet ef migrations add InitCreate --context OrderContext
```

Если контекст и WebAPI в разных проектах:
```bash
dotnet ef migrations add InitCreate --project Order.Data --startup-project Order.WebAPI
```

---

## 8. Установка EF CLI
```bash
dotnet tool install --global dotnet-ef
dotnet ef --version
```

---

## 9. Помощь и справка
```bash
dotnet ef --help
dotnet ef migrations --help
dotnet ef database --help
```

---

## 📋 Краткий конспект

| Действие | Команда |
|-----------|----------|
| Добавить миграцию | `dotnet ef migrations add <Name>` |
| Удалить последнюю | `dotnet ef migrations remove` |
| Применить миграции | `dotnet ef database update` |
| Откатить к миграции | `dotnet ef database update <Name>` |
| Откатить все | `dotnet ef database update 0` |
| Список миграций | `dotnet ef migrations list` |
| SQL-скрипт | `dotnet ef migrations script` |
| Указать контекст | `--context <DbContextName>` |
| Указать проект | `--project <DataProject>` |
| Указать стартовый проект | `--startup-project <WebProject>` |

---

## 💡 Пример для проекта giacom-tech-test

```bash
dotnet ef migrations add InitCreate --project Order.Data --startup-project Order.WebAPI --context OrderContext
dotnet ef database update --project Order.Data --startup-project Order.WebAPI
dotnet ef migrations list --project Order.Data
```
