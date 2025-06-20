---
aliases:
  - Dependency Inversion Principle
"topic:": SOLID
"subtopic:": DIP
"level:": Understand
"type:": concept
"status:": ready
"tags:": "#solid #oop #designprinciple"
intention: минимизация зависимостей
---
# DIP — Dependency Inversion Principle


## ⚡ Краткое
Заменить композицию агрегацией.

## 📖 Развёрнутое
То есть вместо создания зависимостей напрямую, класс должен требовать их у более высокого уровня через аргументы метода или конструктора. При этом зависимость должна передаваться не в виде экземпляров конкретных классов, а в виде интерфейсов или абстрактных классов.
**Пример:** `ReportGenerator` зависит от `IDataProvider` (интерфейса), а не от `SqlDataProvider`. Конкретная реализация передаётся через конструктор (dependency injection).  
**Anti-DIP:** Избыточный DIP создаёт чрезмерную абстракцию, когда можно обойтись использование конкретной реализации, напрямую. Принятие окончательного решения зависит от контекста.

## 🧩 Детальное
С практической точки зрения мы знаем, что иногда нам можно и нужно создавать экземпляры конкретного класса напрямую, а иногда стоит выделить у класса интерфейс и передавать уже его. 
Создавать экземпляры конкретного класса стоит, если:
- класс является неизменяемым "объектом-значением" (Value Object) или объектом данных (Data Object).
- класс обладает стабильным поведением (не работает с внешним окружением).
Выделять интерфейс и передавать его снаружи стоит, если:
- класс является реализацией стратегии и будет использоваться полиморфным образом.
- реализация класса работает с внешним окружением (файлами, сокетами, конфигурацией).
- класс находится на стыке модулей. 
При том, что рекомендованное количество зависимостей которые может иметь класс это 3 или 4 (корни этого числа идет от среднего объёма краткосрочной памяти человека).

## 📝 Термины
- [[01_Tech/00_OOP/DependencyInjection]]
- [[01_Tech/00_OOP/Abstraction]]
- [[01_Tech/00_OOP/Interface]]
- [[01_Tech/00_OOP/Composition]]
- [[01_Tech/00_OOP/Aggregation]]

## 🔗 Ссылки на первоисточник
https://sergeyteplyakov.blogspot.com/2014/09/the-dependency-inversion-principle.html