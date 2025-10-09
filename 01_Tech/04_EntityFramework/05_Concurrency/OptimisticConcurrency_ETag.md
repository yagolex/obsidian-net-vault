
# Optimistic Concurrency via ETag in Web API
tags:: #efcore #concurrency #etag #rest #webapi

## 💡 Concept
ETag (Entity Tag) — уникальный идентификатор версии ресурса в HTTP.  
Используется совместно с заголовком **If-Match** для реализации **оптимистичной конкуренции** на REST-уровне.

Когда клиент получает объект, сервер добавляет ETag — "версию" ресурса.  
При обновлении клиент отправляет `If-Match: "<etag>"`.  
Если версия изменилась — сервер возвращает **HTTP 412 Precondition Failed**.

---

## ⚙️ Связь с EF Core
В EF Core `RowVersion` (или `[Timestamp]`) — бинарное значение, автоматически обновляемое при `UPDATE`.  
Оно идеально подходит в качестве ETag:  
просто закодируйте `RowVersion` в Base64 и верните в HTTP-заголовке `ETag`.

---

## 🧱 Пример модели
```csharp
public class Order
{
    public int Id { get; set; }
    public decimal Total { get; set; }

    [Timestamp]
    public byte[] RowVersion { get; set; } = default!;
}
```

---

## 🧩 Пример контроллера (ASP.NET Core + EF Core)

### 📤 GET (выдача ETag)
```csharp
[HttpGet("{id}")]
public async Task<IActionResult> GetOrder(int id)
{
    var order = await _db.Orders.FindAsync(id);
    if (order is null)
        return NotFound();

    var etag = Convert.ToBase64String(order.RowVersion);
    Response.Headers.ETag = $""{etag}"";

    return Ok(order);
}
```

Ответ:
```
200 OK
ETag: "AAAAAAAAB9E="
{
  "id": 1,
  "total": 250.00
}
```

---

### 📥 PUT (обновление с If-Match)
```csharp
[HttpPut("{id}")]
public async Task<IActionResult> UpdateOrder(int id, [FromBody] Order input)
{
    var order = await _db.Orders.AsNoTracking().FirstOrDefaultAsync(o => o.Id == id);
    if (order is null)
        return NotFound();

    if (!Request.Headers.TryGetValue("If-Match", out var etagHeader))
        return StatusCode(StatusCodes.Status428PreconditionRequired); // RFC 6585

    var clientRowVersion = Convert.FromBase64String(etagHeader.ToString().Trim('"'));

    if (!order.RowVersion.SequenceEqual(clientRowVersion))
        return StatusCode(StatusCodes.Status412PreconditionFailed, "Entity was modified by another user.");

    input.RowVersion = clientRowVersion; // важно передать EF старое значение
    _db.Entry(input).State = EntityState.Modified;

    await _db.SaveChangesAsync();
    return NoContent();
}
```

---

## 🔍 Как это работает
| Шаг | Описание | Кто сравнивает |
|-----|-----------|----------------|
| 1 | Клиент получает объект и ETag | — |
| 2 | Клиент отправляет `PUT` с `If-Match` | — |
| 3 | Сервер достаёт текущий `RowVersion` из БД | — |
| 4 | Сравнивает `RowVersion` с переданным `If-Match` | **Приложение (C#)** |
| 5 | Если не совпадает — HTTP 412 Precondition Failed | **HTTP уровень** |
| 6 | Если совпадает — EF Core делает `UPDATE ... WHERE RowVersion = @old` и обновляет RowVersion | **EF Core + SQL Server** |

---

## ⚠️ Типичные ошибки
| Ошибка | Почему плохо |
|--------|---------------|
| Не проверяют `If-Match` | Потеря обновлений |
| Не конвертируют `RowVersion` в Base64 | HTTP не поддерживает бинарные байты |
| Не возвращают новый `ETag` после PUT | Клиент не узнает новую версию |
| Не передают `RowVersion` обратно EF | EF не сможет обновить запись (ConcurrencyException) |

---

## 🧠 Преимущества
- Полностью REST-совместимо (RFC 9110 §13.1.1)
- Никаких блокировок (оптимистичный подход)
- Простая интеграция в EF Core
- Совместимо с CDN и кешами (`If-None-Match`)

---

## 🔧 Вспомогательные методы
```csharp
private static string EncodeETag(byte[] rowVersion) => $""{Convert.ToBase64String(rowVersion)}"";
private static byte[] DecodeETag(string etag) => Convert.FromBase64String(etag.Trim('"'));
```


## 🃏 Связанные темы
- [[Optimistic_Concurrency]]
- [[Transaction_Isolation]]