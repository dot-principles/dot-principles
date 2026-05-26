# EFFECTIVE-JAVA-DESIGN-METHOD-SIGNATURES - Design Method Signatures Carefully

**Layer:** 2 (contextual)
**Categories:** api-design, developer-experience
**Applies-to:** java
**Summary:** Keep parameter lists to four or fewer, use enums instead of booleans, and choose method names carefully.

## Principle

Choose method names carefully, following standard naming conventions. Avoid long parameter lists - aim for four or fewer parameters. Prefer interfaces over classes as parameter types where feasible. Use two-element enum types instead of `boolean` parameters, which are more readable and easier to extend.

## Why it matters

Method signatures are the primary surface area of an API. A well-designed signature is self-documenting, hard to misuse, and easy to evolve. Long parameter lists are error-prone - callers can transpose arguments of the same type without a compiler warning - and boolean parameters obscure intent at the call site.

## Violations to detect

- Methods with more than four parameters, especially consecutive parameters of the same type
- Boolean parameters whose meaning is unclear at the call site (e.g., `createFile(true, false)`)
- Parameter types that are concrete classes when an interface would make the API more flexible
- Method names that do not follow the language's naming conventions or are misleading about what the method does

## Good practice

```java
// Violation - boolean parameter is meaningless at the call site
thermometer.newReading(98.6, true);  // what does "true" mean?

// Correct - enum makes intent clear
thermometer.newReading(98.6, TemperatureScale.FAHRENHEIT);
```

- Break up long parameter lists by introducing helper classes or Parameter Objects
- Replace boolean parameters with two-element enums (e.g., `TemperatureScale.CELSIUS` instead of `true`)
- Prefer interface types for parameters (e.g., `Map` instead of `HashMap`) to give callers flexibility
- Use consistent naming: `of`, `from`, `valueOf` for static factories; `get`, `is`, `has` for accessors

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 51: "Design method signatures carefully."
