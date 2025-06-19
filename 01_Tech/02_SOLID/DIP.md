# DIP — Dependency Inversion Principle
topic:: SOLID
subtopic:: DIP
level:: Understand
type:: concept
status:: ready
tags:: #solid #oop #designprinciple

## ⚡ Краткое
Зависеть нужно от абстракций, а не от конкретик.

## 📖 Развёрнутое
Модули верхнего и нижнего уровней должны зависеть от абстрактных интерфейсов, не от конкретных реализаций. Абстракции не должны зависеть от деталей.  Рекомендуется внедрение зависимостей через интерфейсы (DI)
**Пример:** `ReportGenerator` зависит от `IDataProvider` (интерфейса), а не от `SqlDataProvider`. Конкретная реализация передаётся через конструктор (dependency injection).  
**Anti-DIP:** Избыточный DIP создаёт чрезмерную абстракцию, когда можно обойтись использование конкретной реализации, напрямую. Принятие окончательного решения зависит от контекста.

## 📝 Термины
- [[01_Tech/00_OOP/DependencyInjection]]
- [[01_Tech/00_OOP/Abstraction]]
- [[01_Tech/00_OOP/Interface]]