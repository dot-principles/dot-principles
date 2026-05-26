# CODE-SMELLS-FEATURE-ENVY - Feature Envy

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Move methods that use another class's data more than their own into that other class.

## Principle

A method exhibits Feature Envy when it uses more data or behaviour from another class than from the class in which it resides. The fundamental rule of object-oriented design is to keep data and the operations on that data together. When a method reaches across object boundaries to pull in data it needs, it usually belongs in the other class.

## Why it matters

Feature Envy increases coupling between classes and scatters related logic across the codebase. When the envied class changes its internal structure, the envious method must change too, even though it lives somewhere else. Moving the method to where the data lives reduces coupling and makes the code easier to evolve.

## Violations to detect

- A method that calls multiple getters on the same foreign object to perform a calculation
- Logic that could be expressed as a method on the data-owning class but is instead written externally
- A method that takes an object as a parameter and then immediately destructures or queries most of its fields
- Utility or helper methods that operate almost entirely on another class's state

## Good practice

- Move the method to the class whose data it uses most (Move Function)
- If only part of the method envies another class, extract that part and move it (Extract Function, then Move Function)
- Apply the rule of thumb: put behaviour with the data it operates on
- Accept the rare exceptions - Strategy and Visitor patterns deliberately separate data from some operations

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
