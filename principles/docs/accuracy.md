# DOC-ACCURACY - Keep documentation accurate and synchronized with the system

**Layer:** 2 (contextual)
**Categories:** documentation, reliability
**Applies-to:** docs
**Summary:** Keep documentation synchronized with the system; never let it describe behavior that no longer exists.

## Principle

Documentation must accurately describe the current state of the system it documents. Out-of-date documentation is worse than no documentation because it misleads readers into incorrect mental models and wastes time debugging discrepancies between the docs and reality.

Accuracy requires a discipline of co-evolution: documentation changes must accompany the code, configuration, or API changes they describe. Treat a documentation lie as a bug.

## Why it matters

Developers rely on documentation to form mental models of a system. Inaccurate documentation causes wasted debugging time, incorrect integrations, and eroded trust in all documentation. Once readers learn that docs are unreliable, they stop consulting them and resort to reading source code or asking colleagues, defeating the purpose of writing documentation at all.

## Violations to detect

- Code examples in documentation that no longer compile or execute correctly
- API parameter names, types, or defaults that differ from the actual implementation
- Architecture diagrams that describe a previous design rather than the current one
- "Step 3: run this command" instructions that reference a command that no longer exists or has changed flags
- Version numbers in documentation that lag behind the released version
- Documented behavior that is contradicted by the actual system behavior

## Good practice

- Include documentation updates in the definition of done for every code change that affects observable behavior
- Run documentation examples as part of the CI pipeline where possible (doc-tests, code samples in tests)
- Date-stamp or version-stamp documentation sections that are known to drift
- Review documentation accuracy during API reviews and architecture reviews
- Mark known-stale sections explicitly rather than leaving readers to discover inaccuracies at runtime

## Sources

- Procida, Daniele. "Diátaxis - A systematic approach to technical documentation authoring." https://diataxis.fr (accessed 2026-03-18).
- Strimling, Yoel. "Beyond Accuracy: What Documentation Quality Means to Readers." *SIGDOC*, 2017.
