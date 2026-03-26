# CODE-SMELLS-MESSAGE-CHAINS — Message Chains

**Layer:** 2 (contextual)
**Categories:** code-smells, refactoring, maintainability
**Applies-to:** all
**Summary:** Break long navigation chains by moving logic closer to the data it needs, reducing coupling to structure.

## Principle

A Message Chain occurs when a client asks one object for another object, then asks that object for yet another, and so on: `a.getB().getC().getD()`. The client becomes coupled to the entire navigation structure. If any intermediate link changes, the client breaks, even though it only cares about the object at the end of the chain.

## Why it matters

Message chains tightly couple the calling code to the internal structure of a series of objects. Any restructuring of the intermediate classes — renaming a method, moving a relationship — forces changes in every client that navigates through the chain. This coupling makes refactoring risky and expensive.

## Violations to detect

- Chains of three or more getter or accessor calls on a single line
- Navigation paths that traverse multiple object boundaries to retrieve a value (e.g., `order.getCustomer().getAddress().getCity()`)
- Test setups that must construct deep object graphs just to call one method
- Fluent API calls that navigate structure (as distinct from builder-style fluent APIs, which are acceptable)

## Good practice

- Apply Hide Delegate: give the intermediate object a method that provides what the client needs directly
- Use Extract Function to encapsulate the navigation and give it a meaningful name
- Consider whether the intermediate objects should expose less of their internal structure
- Accept that some chains (e.g., fluent builders, stream pipelines) are idiomatic and not a smell

## Sources

- Fowler, Martin. *Refactoring: Improving the Design of Existing Code*, 2nd ed. Addison-Wesley, 2018. ISBN 978-0-13-475759-9. Chapter 3: "Bad Smells in Code."
