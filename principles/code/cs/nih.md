# CODE-CS-NIH - NIH: Not Invented Here

**Layer:** 1 (universal)
**Categories:** dependency-management, pragmatism, simplicity
**Applies-to:** all
**Summary:** Prefer proven external solutions over building equivalent functionality in-house.

## Principle

Prefer proven, well-maintained external solutions over building equivalent functionality in-house. The Not Invented Here bias - the instinct to distrust or reject solutions because they originated outside the team - leads to reinventing wheels that are poorly tested, undermaintained, and underdocumented compared to the battle-hardened alternatives they replace.

The inverse trap is equally real: pulling in a heavy dependency for trivial functionality (Cargo Cult adoption). The principle is about resisting the bias against adoption, not blindly maximising dependency counts.

## Why it matters

Custom implementations of general-purpose problems (auth, crypto, serialization, queues, HTTP clients) carry compounding costs: initial build time, ongoing maintenance, security patching, and onboarding friction for new developers. Mature external libraries have been tested at scale, fixed through adversarial use, and documented by communities far larger than any single team. Reinventing them rarely produces a better result; it almost always produces a worse one.

## Violations to detect

- Custom implementations of auth, cryptography, or token handling instead of established libraries
- In-house queue, cache, or retry logic when Redis, RabbitMQ, or equivalent would serve
- Hand-rolled date parsing, serialization, HTTP clients, or logging frameworks
- "We can't use that - we don't own it" as the primary objection to an established library
- Internal forks of open-source tools with no meaningful divergence from upstream

## Good practice

- Default to established libraries for general-purpose problems; reserve custom implementations for genuine domain-specific requirements
- Evaluate external dependencies on maintenance activity, community size, security track record, and licence compatibility
- When a dependency does too much, prefer a smaller focused library over building from scratch
- Distinguish between "not invented here" (bias) and legitimate reasons to own: regulatory constraints, performance-critical hot paths, genuinely novel requirements

## Sources

- Spolsky, Joel. "Not Invented Here Syndrome." Joel on Software, 2001.
- Hunt, Andrew; Thomas, David. *The Pragmatic Programmer*, 20th Anniversary ed. Addison-Wesley, 2019. ISBN 978-0-13-595705-9.
