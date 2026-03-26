# CODE-CS-NO-SILVER-BULLET — No Silver Bullet

**Layer:** 2 (contextual)
**Categories:** software-design, pragmatism, architecture
**Applies-to:** all
**Summary:** No single technique solves all problems; choose tools based on actual context and constraints.

## Principle

There is no single technique, tool, pattern, or architecture that solves all software problems. Every approach has a domain where it excels and a domain where it fails. The danger comes in two forms: the **Golden Hammer** — over-applying a familiar tool because you already have it — and the **Silver Bullet** — adopting a new approach because it solved someone else's problem at a different scale, in a different context, for a different team.

Both failures share the same root: mistaking a solution that worked *somewhere* for a solution that works *everywhere*.

## Why it matters

Software problems are not uniform. A solution fitted to one context carries assumptions — about scale, team structure, consistency requirements, deployment model — that do not transfer. Applying it universally produces systems that are over-engineered for simple cases, under-fitted for complex ones, and increasingly hard to change because the wrong abstraction is now load-bearing. The more powerful and general a solution appears, the more dangerous its uncritical adoption.

## Violations to detect

- Mandating one framework, ORM, message broker, or database engine across all services regardless of their differing requirements
- Adopting microservices, event sourcing, CQRS, or similar patterns because a large tech company uses them, without matching scale or organisational need
- A shared platform or infrastructure layer that all teams must route through, regardless of whether it fits their workload
- Reaching for the same architectural pattern for the third project in a row without re-evaluating fit
- "We already use X for everything else" as the primary justification for a new use of X

## Good practice

- Choose tools and patterns based on the specific constraints of the problem: scale, team size, consistency requirements, operational complexity
- Treat successful patterns from other organisations as *inspiration*, not *prescription* — understand the context that made them successful before adopting them
- Prefer boring, proven technology for new problems; reserve novel approaches for the specific constraints that justify them
- Regularly revisit architectural decisions as context changes — a good fit at 10k users may be a poor fit at 10M

## Sources

- Brooks, Fred. "No Silver Bullet — Essence and Accident in Software Engineering." *IEEE Computer*, April 1987.
- Brown, William J. et al. *AntiPatterns: Refactoring Software, Architectures, and Projects in Crisis*. Wiley, 1998. (Golden Hammer anti-pattern)
- Maslow, Abraham. *The Psychology of Science*, 1966. ("If the only tool you have is a hammer, you tend to see every problem as a nail.")
