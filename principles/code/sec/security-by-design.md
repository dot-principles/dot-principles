# CODE-SEC-SECURITY-BY-DESIGN — Design for security from the start

**Layer:** 2 (contextual)
**Categories:** security
**Applies-to:** all
**Summary:** Perform threat modeling and apply secure design patterns before implementation begins, not after.

## Principle

Security must be a first-class concern in system design, not a feature bolted on after implementation. Insecure Design (A04:2021) is a broad category reflecting the absence of security-focused design patterns, threat modeling, and secure architecture decisions. Unlike implementation bugs, insecure design cannot be fixed by a perfect implementation — a missing defense cannot be patched in after the architecture is set.

## Why it matters

When systems are designed without considering abuse cases, trust boundaries, and failure modes, entire classes of attacks become possible regardless of how carefully the code is written. Retroactively adding security controls to a fundamentally insecure architecture is costly, often incomplete, and sometimes impossible. Threat modeling during design is far cheaper than incident response after a breach.

## Violations to detect

- No threat modeling or abuse-case analysis documented for the feature or system
- Trust boundaries not identified — all components treated as equally trusted
- Missing rate limiting or resource controls on operations that could be abused (account creation, password reset, file upload)
- Business logic that assumes users will follow the intended workflow without enforcement
- Sensitive operations lacking confirmation steps or re-authentication
- No defense-in-depth — a single control as the only barrier to a critical asset

## Good practice

- Perform threat modeling (e.g., STRIDE) during design to identify and mitigate risks early
- Define and document trust boundaries; validate data at every boundary crossing
- Use secure design patterns: least privilege, defense in depth, fail-safe defaults, complete mediation
- Write abuse cases and negative requirements alongside functional requirements
- Implement rate limiting and anti-automation controls on sensitive endpoints
- Conduct design reviews with security-focused checklists before implementation begins

## Sources

- OWASP Foundation. "OWASP Top 10:2021 — A04:2021 Insecure Design." https://owasp.org/Top10/A04_2021-Insecure_Design/
