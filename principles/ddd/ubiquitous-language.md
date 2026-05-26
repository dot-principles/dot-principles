# DDD-UBIQUITOUS-LANGUAGE - Ubiquitous Language

**Layer:** 2 (contextual)
**Categories:** domain-modeling, domain-driven-design
**Applies-to:** all
**Summary:** Use domain expert vocabulary exactly in all code, conversations, and documentation without translation.
**Audit-scope:** limited - can detect generic technical names and intra-codebase naming inconsistencies; cannot verify whether naming matches domain-expert vocabulary (requires a domain glossary)

## Principle

The language used in code - class names, method names, variable names, module names - should directly reflect the language that domain experts use to describe the business. This shared vocabulary, called the Ubiquitous Language, must be rigorously used in conversations, documentation, and code alike. When the code mirrors the domain language, developers and domain experts can communicate without translation, and the model becomes a living, executable specification of the business.

## Why it matters

When code uses a different vocabulary than the business, every conversation requires mental translation, misunderstandings accumulate, and the model drifts away from the domain it represents. Over time, the software becomes harder to extend correctly because developers no longer understand the real-world concepts behind the abstractions. A shared language catches domain misunderstandings at design time rather than in production.

## Violations to detect

- Class or method names that use generic technical terms (e.g., `DataManager`, `Processor`, `Handler`) where a domain-specific name exists
- Different terms used for the same concept in different parts of the codebase (e.g., `Customer` in one module and `Client` in another for the same concept)
- Domain terms that appear in documentation or conversations but are absent from the code
- Comments that translate between code names and domain terms, indicating a vocabulary mismatch

## Good practice

- Name classes, methods, and variables using the exact terms domain experts use; if a term feels awkward in code, explore whether the model needs refinement rather than inventing a synonym
- Maintain a glossary of the Ubiquitous Language and refer to it during code reviews
- When domain experts introduce a new term or refine an existing one, rename the corresponding code elements to match
- Let naming inconsistencies trigger design discussions - they often reveal deeper modeling problems

## Sources

- Evans, Eric. *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Addison-Wesley, 2003. ISBN 978-0-321-12521-7. Chapter 2.
