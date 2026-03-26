# EFFECTIVE-JAVA-INTERFACES-FOR-TYPES — Use Interfaces Only to Define Types

**Layer:** 2 (contextual)
**Categories:** api-design, developer-experience
**Applies-to:** java
**Summary:** Use interfaces to define behavioral types; never use them solely as containers for constants.

## Principle

An interface should define a type — a set of methods that a class can implement to indicate that its instances can be used in a certain way. Using an interface solely to export constants (the "constant interface" antipattern) is a misuse of the mechanism. Constants are an implementation detail; leaking them into a type definition pollutes the API and commits all implementing classes to those constants forever.

## Why it matters

When a class implements a constant interface, the constants become part of its exported API. Clients may come to depend on them, making it impossible to remove the constants in future releases without breaking compatibility. The constants also clutter the implementing class's namespace and confuse users about the class's purpose.

## Violations to detect

- Interfaces that contain only `static final` fields and no method declarations
- Classes that implement an interface solely to use its constants without qualification
- Constants defined in an interface rather than in a utility class, an enum, or the class that is most closely associated with them

## Good practice

- Define constants in a non-instantiable utility class with a private constructor, or as `enum` values
- Use `static import` to avoid qualifying constant names when readability demands it
- If the constants are strongly tied to an existing class or interface that defines a type, add them there
- An interface may contain constants alongside methods if they are integral to the type it defines

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 22: "Use interfaces only to define types."
