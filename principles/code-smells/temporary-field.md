# CODE-SMELLS-TEMPORARY-FIELD — Temporary Field

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Never leave instance fields valid only sometimes; extract context-specific state into a dedicated class.

## Principle

Temporary Field occurs when an instance variable is only set and used in certain circumstances, remaining null or meaningless otherwise. A class whose fields are only sometimes valid is confusing: callers cannot predict when the field will hold a meaningful value, and the object's state is partially undefined for large parts of its lifetime.

## Why it matters

Fields that are only sometimes valid create invisible state dependencies. Code must track whether the field is currently "valid" or not. This implicit protocol is hard to discover and easy to violate, leading to bugs when code assumes a field is set when it isn't.

## Violations to detect

- An instance field that is `null` except when a particular method has been called
- A field that is set in one method and read in a completely different method, with no guarantee of ordering
- A class where the valid state of some fields depends on the values of other fields ("sometimes this field is meaningful, sometimes not")

## Good practice

- Extract Class: move the temporary field and the logic that uses it into a separate class that only exists when those fields are needed
- Replace the conditional logic with a Null Object for the temporary field's type
- Consider whether the temporary state represents a distinct phase of the object's lifecycle that should be modelled explicitly

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
