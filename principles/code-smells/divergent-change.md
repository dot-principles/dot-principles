# CODE-SMELLS-DIVERGENT-CHANGE — Divergent Change

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Split classes that change for multiple unrelated reasons to enforce single responsibility.

## Principle

Divergent Change occurs when a single class is often changed in different ways for different reasons. If you look at a class and say "I change this class whenever there is a new database type AND whenever there is a new financial instrument", the class has too many axes of change and should be split along those axes. Each class should have one reason to change (Single Responsibility).

## Why it matters

A class with multiple axes of change must be edited for unrelated reasons, increasing the risk of unintended side effects. Changes made for one reason can inadvertently break behavior associated with a different reason. This is the class-level expression of a Single Responsibility violation.

## Violations to detect

- A class that is modified whenever requirements change in two or more unrelated areas of the system
- A class that contains logic for multiple distinct concerns (e.g., data access AND business rules AND formatting)
- Methods in the same class that clearly group into distinct responsibility clusters that never interact

## Good practice

- Split the class along its axes of change using Extract Class
- Give each resulting class a name that reflects its single responsibility
- Divergent Change and Shotgun Surgery are opposites: one class, multiple changes → Divergent Change; one change, multiple classes → Shotgun Surgery

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
