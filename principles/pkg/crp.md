# PKG-CRP — Common Reuse Principle (CRP)

**Layer:** 2 (contextual)
**Categories:** software-design, package-design, modularity
**Applies-to:** all
**Summary:** Never bundle classes into a component unless all consumers of the component use all of them together.

## Principle

Don't force users of a component to depend on things they don't need. Classes that are reused together belong together; classes that are not reused together should not be grouped together. This is the Interface Segregation Principle applied at the component level.

## Why it matters

Every dependency on a component is a dependency on everything in that component. If a consumer only uses part of a component, it still has to deal with changes to the rest. Oversized components create unnecessary transitive dependencies and force consumers to manage change they don't care about.

## Violations to detect

- A component that bundles classes for unrelated features and forces all consumers to depend on all of them
- Consumers that import a large component but use only one or two classes from it
- Unrelated utilities bundled into a single shared library because they are used by the same team

## Good practice

Identify natural cohesion groups by asking "which classes are always used together by the same consumers?" Split components at the boundaries of those groups. Accept that this may produce more, smaller components.

## Sources

- Martin, Robert C. *Agile Software Development: Principles, Patterns, and Practices*. Prentice Hall, 2002. ISBN 978-0-13-597444-5. Chapter 20.
