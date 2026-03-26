# GRASP-INFORMATION-EXPERT — Information Expert

**Layer:** 1 (universal)
**Categories:** software-design, responsibility-assignment
**Applies-to:** all
**Summary:** Assign each responsibility to the class that already holds the data needed to fulfill it.

## Principle

Assign a responsibility to the class that has the information needed to fulfil it. The object that knows the data needed to perform a task is the best candidate to perform that task.

## Why it matters

Placing behaviour far from the data it operates on creates excessive coupling: the caller must reach into another object's internals or expose data just to perform a computation. Information Expert keeps behaviour and data together, producing cohesive objects with minimal unnecessary coupling.

## Violations to detect

- A service class that extracts data from a domain object and performs calculations on it externally (feature envy)
- Anemic domain model: objects with only getters/setters and all logic in external services
- A caller accessing multiple fields of an object to compute something the object could compute itself
- Repeated logic in multiple places that all operate on the same class's data

## Good practice

- Ask "which class has the information to compute this?" and put the method there
- Replace `order.getItems().stream().mapToDouble(Item::getPrice).sum()` with `order.totalPrice()`
- Use the principle iteratively — a responsibility may be split across multiple objects, requiring a new class to aggregate them

## Sources

- Larman, Craig. *Applying UML and Patterns: An Introduction to Object-Oriented Analysis and Design and Iterative Development*. 3rd ed. Prentice Hall, 2004. ISBN 978-0-13-148906-6. Chapter 17.
