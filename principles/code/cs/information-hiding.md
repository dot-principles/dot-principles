# CODE-CS-INFORMATION-HIDING — Information Hiding (Parnas)

**Layer:** 1 (universal)
**Categories:** software-design, modularity, encapsulation, maintainability
**Applies-to:** all
**Summary:** Hide design decisions behind module interfaces; expose only what callers must know.

## Principle

Each module should hide a design decision that is likely to change. The module's interface exposes only what other modules must know to use it; the implementation — the decision being hidden — remains private. Decompose systems by identifying the design choices that are most likely to change, and assign one module per such decision.

## Why it matters

Software changes. When modules hide volatile decisions (algorithms, data representations, hardware interfaces, third-party APIs), those decisions can be changed without affecting the rest of the system. When they are exposed, every consumer becomes tightly coupled to those details, and what should be a local change becomes a system-wide change.

## Violations to detect

- A class that exposes its internal data structure (e.g., returning a `List` when a `Set` would also work, or exposing a `HashMap` field directly)
- A module whose interface leaks the name or types of the library it uses internally (e.g., a repository that returns Hibernate `Session` objects)
- Changing an internal data representation requires updating callers
- Public fields or properties that allow external code to read and write internal state directly

## Inspection

- `grep -rnE 'public\s+(List|Map|Set|ArrayList|HashMap|HashSet)\b' --include="*.java" $TARGET` | MEDIUM | Public collection fields expose internal data structure choices

## Good practice

- Design interfaces around *what* a module does, not *how* it does it
- Return interface types (`List`, `Collection`) rather than concrete types (`ArrayList`)
- Hide third-party library types behind your own interfaces (anti-corruption layer)
- Ask: "if I change the implementation, which callers break?" Those callers are coupled to an exposed decision

## Sources

- Parnas, David L. "On the criteria to be used in decomposing systems into modules." *Communications of the ACM*, 15(12), 1972, pp. 1053–1058. DOI: 10.1145/361598.361623
