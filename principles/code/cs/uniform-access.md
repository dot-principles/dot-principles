# CODE-CS-UNIFORM-ACCESS - Uniform Access Principle

**Layer:** 2 (contextual)
**Categories:** software-design, api-design, encapsulation
**Applies-to:** all
**Summary:** Expose all module services through a uniform notation regardless of storage or computation.

## Principle

All services offered by a module should be available through a uniform notation, whether they are implemented through storage (a stored field) or through computation (a calculated method). Callers should not need to know - or care - whether the value they are accessing is stored or computed. The distinction is an implementation detail that should be hidden.

## Why it matters

When an API exposes whether a value is stored or computed, callers become coupled to that implementation decision. Changing a stored field to a computed property (or vice versa) breaks all callers, even though the external contract is unchanged. Languages with properties (C#, Kotlin, Python, Swift) make this easy; languages without them require discipline to achieve the same effect.

## Violations to detect

- A public field that is later changed to a method, requiring updates at every call site
- An API that exposes `getX()` for computed values and direct field access for stored values - callers must know which is which
- Changing from lazy-computed to eagerly-stored (or vice versa) breaking client code

## Good practice

```csharp
// Violation - callers distinguish field from computation
public string FirstName;          // stored
public string FullName() { ... }  // computed - different call syntax

// Correct - uniform property syntax regardless of storage
public string FirstName { get; set; }
public string FullName => $"{FirstName} {LastName}";
```

- Use language properties (C# properties, Python `@property`, Kotlin `val/var` with custom getters, Swift computed properties) to hide storage vs. computation
- In Java, consistently use `getX()` for both stored and computed values so callers cannot tell the difference
- Design APIs around the concept, not the mechanism

## Sources

- Meyer, Bertrand. *Object-Oriented Software Construction*, 2nd ed. Prentice Hall, 1997. ISBN 978-0-13-629155-8. Chapter 4, "The Uniform Access Principle."
