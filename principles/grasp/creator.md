# GRASP-CREATOR - Creator

**Layer:** 2 (contextual)
**Categories:** software-design, responsibility-assignment, object-creation
**Applies-to:** all
**Summary:** Assign object-creation responsibility to the class that aggregates, contains, or holds initializing data for the new object.

## Principle

Assign class B the responsibility to create instances of class A if B aggregates, contains, records, closely uses, or has the initialising data for A. The creator is the object with the most context about what a new object should look like.

## Why it matters

Arbitrary or centralised object creation scatters construction logic and creates hidden coupling to concrete types. Applying Creator keeps construction responsibility close to the objects with the most context, making instantiation logic easy to find and reducing the need for widespread knowledge of constructors.

## Violations to detect

- A factory or service creating objects it does not own, aggregate, or use closely
- Construction logic for a domain object spread across multiple callers
- An unrelated class knowing the initialisation details of another class's collaborators
- Factories used when one of the GRASP Creator conditions is clearly satisfied by an existing class

## Good practice

- Have `Order` create `OrderLine` objects - it aggregates them and has the product and quantity data
- Have `Playlist` create `PlaylistEntry` - it contains entries and has the track reference
- Use Factory patterns only when the Creator heuristic doesn't clearly apply (e.g., the creator varies at runtime)

## Sources

- Larman, Craig. *Applying UML and Patterns: An Introduction to Object-Oriented Analysis and Design and Iterative Development*. 3rd ed. Prentice Hall, 2004. ISBN 978-0-13-148906-6. Chapter 17.
