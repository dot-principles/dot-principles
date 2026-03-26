# CLEAN-ARCH-KEEP-OPTIONS-OPEN — Keep Options Open

**Layer:** 2 (contextual)
**Categories:** architecture
**Applies-to:** all
**Summary:** Defer binding to specific frameworks and databases by keeping them behind interfaces as long as possible.

## Principle

A good architecture maximizes the number of decisions not made. Defer binding to specific frameworks, databases, and delivery mechanisms for as long as possible by keeping them behind interfaces at the boundary of the system. The longer these decisions remain open, the more information you have when you finally make them, and the easier they are to change if circumstances shift.

## Why it matters

Early commitment to a framework or database shapes every decision that follows and makes reversal expensive. When the architecture treats these choices as deferred details rather than foundational commitments, the team can prototype with a simple in-memory implementation, delay vendor selection until requirements stabilize, and switch technologies when better options emerge — all without rewriting the core application.

## Violations to detect

- Application logic that cannot be tested or run without a specific database, message broker, or framework running
- Core business modules that directly depend on vendor-specific SDKs or driver libraries
- Architectural decisions made before requirements are understood, purely because "the team knows framework X"
- A system where replacing the database or web framework would require changes across most of the codebase

## Good practice

- Define repository interfaces, gateway interfaces, and service interfaces in the domain layer — implement them with concrete technology in the infrastructure layer
- Build and test the core application against in-memory or fake implementations before committing to production infrastructure
- Evaluate frameworks and databases as late as responsibly possible, treating them as pluggable details
- Document technology decisions as Architecture Decision Records (ADRs) so the reasoning is preserved and revisitable

## Sources

- Martin, Robert C. *Clean Architecture: A Craftsman's Guide to Software Structure and Design*. Prentice Hall, 2017. ISBN 978-0-13-449416-6. Chapter 15: "What Is Architecture?"
