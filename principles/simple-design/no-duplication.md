# SIMPLE-DESIGN-NO-DUPLICATION — No Duplication

**Layer:** 1 (universal)
**Categories:** software-design, simplicity, refactoring
**Applies-to:** all
**Summary:** Every piece of business logic must exist in exactly one place; eliminate all knowledge duplication.

## Principle

Simple design contains no duplication of knowledge. Every piece of business logic, every algorithm, and every policy should exist in exactly one place. Beck's third rule — sometimes stated as "no duplication" or expressed via the DRY (Don't Repeat Yourself) and "Once and Only Once" principles — means that if you find similar code or structures in multiple places, you should extract and unify them.

## Why it matters

Duplicated code means duplicated bugs and duplicated maintenance effort. When a business rule exists in multiple places, a change must be applied everywhere or the system becomes inconsistent. Duplication also obscures the design — it hides the fact that two pieces of code embody the same concept, making the system harder to understand and evolve.

## Violations to detect

- Copy-pasted code blocks with minor variations across classes or modules
- Multiple implementations of the same business rule or validation logic
- Repeated conditional structures that could be unified by polymorphism or a shared function
- Identical or near-identical SQL queries, API calls, or configuration scattered across the codebase
- Test setup code duplicated across many test files instead of being extracted into shared fixtures

## Good practice

- Extract common logic into well-named shared functions or modules
- Use parameterization to handle minor variations in otherwise identical code
- Apply refactoring patterns such as Extract Method, Extract Class, or Template Method to remove structural duplication
- Look for duplication of *knowledge*, not just textual similarity — two code fragments that encode the same rule are duplicates even if they look different
- After removing duplication, verify that the shared abstraction genuinely represents a single concept and is not a false unification

## Sources

- Beck, Kent. *Extreme Programming Explained: Embrace Change*, 2nd ed. Addison-Wesley, 2004. ISBN 978-0-321-27865-4.
- Fowler, Martin. "BeckDesignRules." https://martinfowler.com/bliki/BeckDesignRules.html
