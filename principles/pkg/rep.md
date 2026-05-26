# PKG-REP - Reuse/Release Equivalence Principle (REP)

**Layer:** 2 (contextual)
**Categories:** software-design, package-design, modularity
**Applies-to:** all
**Summary:** Group into a component only classes cohesive enough to be released, versioned, and maintained together.

## Principle

The granule of reuse is the granule of release. Classes and modules that are grouped into a component must belong together - they must form a cohesive unit that makes sense to release and maintain as a whole. If you are not willing to maintain and release a set of classes together, they should not be in the same component.

## Why it matters

Consumers of a reusable component need stability and versioning. If a component bundles unrelated things, any change to any part forces a new release that all consumers must evaluate and adopt - even those that don't use the changed part. Grouping by release cohesion gives consumers predictable versioning boundaries.

## Violations to detect

- A component that mixes completely unrelated utilities forced together for convenience
- Classes used by different consumers bundled into a single component, forcing consumers to take changes they don't care about
- No versioning or release boundary around a set of modules that others depend on

## Good practice

Group classes into components that will be released, versioned, and maintained together. Ask: "would all consumers of this component adopt a new release together, or do different consumers use different subsets?" If the latter, split the component.

## Sources

- Martin, Robert C. *Agile Software Development: Principles, Patterns, and Practices*. Prentice Hall, 2002. ISBN 978-0-13-597444-5. Chapter 20.
