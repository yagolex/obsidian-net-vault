---
aliases:
  - Liskov Substitution Principle
"topic:": SOLID
"subtopic:": LSP
"level:": Understand
"type:": concept
"status:": ready
"tags:": "#solid #oop #designprinciple"
intention: указывает, как использовать наследование «правильно»
---
# LSP — Liskov Substitution Principle

## ⚡ Краткое
Подкласс можно использовать вместо базового класса — без потери корректности (без изменения поведения).

## 📖 Развёрнутое
Если `B` — базовый класс, а `S` — его подкласс, то объекты `S` должны корректно работать везде, где ожидается `B`. Наследник может ослаблять предусловия и усиливать постусловия, при этом соблюдая инварианты.  
**Пример нарушения:** несогласованное поведение, неправильное наследование, к примеру `Rectangle` и `Square`, где изменение сторонами вызывает нарушение инварианта.  
**Anti-LSP:** “непонятное наследование” — либо избыток, либо полное отсутствие.

## 📝 Термины
- [[01_Tech/00_OOP/Precondition]]
- [[01_Tech/00_OOP/Postcondition]]
- [[01_Tech/00_OOP/Invariant]]
- [[01_Tech/00_OOP/Contract]]
- [[01_Tech/00_OOP/Inheritance]]
- [[01_Tech/00_OOP/Polymorphism]]

## 🔗 Ссылки на первоисточник
https://sergeyteplyakov.blogspot.com/2014/09/liskov-substitution-principle.html