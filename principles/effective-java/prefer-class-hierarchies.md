# EFFECTIVE-JAVA-PREFER-CLASS-HIERARCHIES - Prefer Class Hierarchies to Tagged Classes

**Layer:** 2 (contextual)
**Categories:** api-design, developer-experience
**Applies-to:** java
**Summary:** Replace tagged classes that branch on a type field with a proper abstract class hierarchy.

## Principle

A tagged class - one that uses a field to indicate which "flavour" of instance it is, with switch statements branching on that tag - is a verbose, error-prone, and inefficient imitation of a class hierarchy. Replace it with an abstract class and concrete subclasses, placing each variant's behaviour and data in the subclass where it belongs.

## Why it matters

Tagged classes are cluttered with boilerplate: tag fields, switch statements, fields that are only relevant to some variants, and constructors that must initialise irrelevant fields. They are hard to extend because adding a new flavour means editing the class rather than adding a new subclass. A proper hierarchy makes each variant self-contained and independently extensible.

## Violations to detect

- A class with an enum or integer "type" field and switch/if-else statements that branch on it
- Fields that are only used when the tag has a certain value (dead weight for other variants)
- Constructors that accept parameters irrelevant to some variants or set fields to sentinel values
- Methods whose first action is to check a tag field before deciding what to do

## Good practice

```java
// Violation - tagged class
class Shape {
    enum Type { CIRCLE, RECTANGLE }
    Type type;
    double radius;      // only for CIRCLE
    double width, height;  // only for RECTANGLE
    double area() {
        switch (type) {
            case CIRCLE: return Math.PI * radius * radius;
            case RECTANGLE: return width * height;
        }
    }
}

// Correct - class hierarchy; each variant is self-contained
abstract class Shape { abstract double area(); }
class Circle extends Shape {
    double radius;
    double area() { return Math.PI * radius * radius; }
}
class Rectangle extends Shape {
    double width, height;
    double area() { return width * height; }
}
```

- Define an abstract class (or interface) for the common type, with abstract methods for variant-specific behaviour
- Create a concrete subclass for each tag value, containing only the data and behaviour relevant to that variant
- If the tagged class is a data carrier, consider sealed classes (Java 17+) or algebraic data types where available
- Keep shared behaviour in the abstract base; push variant-specific logic into subclasses

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 23: "Prefer class hierarchies to tagged classes."
