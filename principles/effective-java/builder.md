# EFFECTIVE-JAVA-BUILDER - Consider Builders for Constructors with Many Parameters

**Layer:** 2 (contextual)
**Categories:** api-design, developer-experience
**Applies-to:** java
**Summary:** Use the Builder pattern when constructors or factories require many parameters, especially optional ones.

## Principle

When a constructor or static factory method would require many parameters - especially optional ones - consider the Builder pattern. A builder lets the client set parameters one at a time in a fluent style and then call a `build()` method that validates the parameters and constructs the object. Builders combine the safety of telescoping constructors with the readability of the JavaBeans pattern.

## Why it matters

Telescoping constructors (overloading constructors with increasing numbers of parameters) are hard to read and write. The JavaBeans pattern (empty constructor + setters) allows objects to be in an inconsistent state during construction and prevents immutability. The Builder pattern eliminates both problems: construction is atomic, the resulting object can be immutable, and the calling code is clear.

## Violations to detect

- Constructors with more than four or five parameters, especially when several are of the same type
- Telescoping constructor chains where each overload adds one more parameter
- JavaBeans-style construction where setters are called after the constructor, leaving a window of inconsistency
- Complex object creation that requires the caller to remember parameter order

## Good practice

```java
// Violation - telescoping constructor; easy to transpose arguments
NutritionFacts cocaCola = new NutritionFacts(240, 8, 100, 0, 35, 27);

// Correct - fluent builder; only required fields are mandatory
NutritionFacts cocaCola = new NutritionFacts.Builder(240, 8)
    .calories(100)
    .sodium(35)
    .carbohydrate(27)
    .build();
```

- Make the builder a `static` inner class of the class it builds
- Return `this` from each setter method to enable method chaining
- Perform validation in the `build()` method, not in individual setter methods, to enforce cross-field constraints
- Consider making the built class immutable - the builder is the only way to set its fields

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 2: "Consider a builder when faced with many constructor parameters."
