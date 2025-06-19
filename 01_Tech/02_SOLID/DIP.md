# DIP — Dependency Inversion Principle
topic:: SOLID
subtopic:: DIP
level:: Understand
type:: concept
status:: ready
tags:: #solid #oop #designprinciple

## ⚡ Краткое
Заменить композицию агрегацией.

## 📖 Развёрнутое
То есть вместо создания зависимостей напрямую, класс должен требовать их у более высокого уровня через аргументы метода или конструктора. При этом зависимость должна передаваться не в виде экземпляров конкретных классов, а в виде интерфейсов или абстрактных классов.
**Пример:** `ReportGenerator` зависит от `IDataProvider` (интерфейса), а не от `SqlDataProvider`. Конкретная реализация передаётся через конструктор (dependency injection).  
**Anti-DIP:** Избыточный DIP создаёт чрезмерную абстракцию, когда можно обойтись использование конкретной реализации, напрямую. Принятие окончательного решения зависит от контекста.

## 🧩 Детальное


## 📝 Термины
- [[01_Tech/00_OOP/DependencyInjection]]
- [[01_Tech/00_OOP/Abstraction]]
- [[01_Tech/00_OOP/Interface]]
- [[01_Tech/00_OOP/Composition]]
- [[01_Tech/00_OOP/Aggregation]]

## 🔗 Ссылки на первоисточник
https://sergeyteplyakov.blogspot.com/2014/09/the-dependency-inversion-principle.html