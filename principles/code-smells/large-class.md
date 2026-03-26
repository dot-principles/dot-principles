# CODE-SMELLS-LARGE-CLASS — Large Class

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Split classes with too many responsibilities into focused, single-purpose classes.

## Principle

A class that tries to do too much invariably has too many instance variables, too many methods, or both. When a class accumulates multiple responsibilities, it becomes difficult to understand, and changes in one area risk breaking another. A class should have a single, clearly stated purpose.

## Why it matters

Large classes violate the Single Responsibility Principle. They attract more code over time because developers add "just one more method" to an already convenient location. The result is a tangled web of internal dependencies that resists testing, reuse, and safe modification.

## Violations to detect

- Classes with a large number of instance variables, especially when subsets of variables are used by different subsets of methods
- Classes whose name includes vague terms like "Manager," "Processor," or "Handler" without further qualification
- Classes that implement multiple unrelated interfaces
- A single class file that spans hundreds of lines

## Good practice

- Extract Class to split a large class into cohesive, focused classes
- Use Extract Subclass or Extract Interface when different clients use different subsets of the class's behaviour
- Group related instance variables and the methods that use them — each group is a candidate for its own class
- Look for prefixes or suffixes on method/variable names that hint at a hidden class (e.g., `phone_number`, `phone_area_code` suggest a Phone class)

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
