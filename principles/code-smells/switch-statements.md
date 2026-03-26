# CODE-SMELLS-SWITCH-STATEMENTS — Switch Statements

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Replace repeated switch/if-else type-dispatch chains with polymorphism so new variants require no edits.

## Principle

When you see the same switch or if/else chain repeated in multiple places — branching on a type code or status value — it is a sign that polymorphism is missing. Each time a new case is added, every copy of the switch must be found and updated. The refactoring is to replace the conditional with polymorphism so that adding a new variant means adding a new class, not editing existing code.

## Why it matters

Duplicated conditional logic is fragile. Adding a new case requires hunting down every switch on the same type code, and missing one introduces a bug. Polymorphism localises each variant's behaviour into its own class, making the system open for extension and closed for modification.

## Violations to detect

- The same switch or if/else chain on a type code appearing in more than one method or class
- A switch that grows every time a new variant or status is added to the system
- Methods that branch on `instanceof`, `typeof`, or string-based type discriminators
- Conditional logic that could be replaced by a method override in a subclass

## Good practice

- Replace Type Code with Subclasses, then Replace Conditional with Polymorphism
- Use the Strategy or State pattern when subclassing the host class is not practical
- A single, isolated switch is often acceptable — the smell is about duplication of the same conditional structure
- When the conditional truly belongs in one place (e.g., a factory), keep it there rather than forcing polymorphism

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
