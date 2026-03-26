# OWASP-04-INSECURE-DESIGN — Insecure Design

**Layer:** 2 (contextual)
**Categories:** security, architecture, threat-modelling
**Applies-to:** all
**Summary:** Threat-model every feature before implementation and embed security controls at the architectural design level.

## Principle

Security must be designed in from the start, not bolted on after implementation. Insecure design represents missing or ineffective security controls at the architectural level — business logic flaws, missing rate limiting, absent threat modelling — that cannot be fixed by secure implementation alone.

## Why it matters

Implementation-level controls (parameterised queries, output encoding) cannot compensate for absent design-level controls. A login flow with no account lockout, a password reset that leaks information, or a financial transaction with no fraud limit are design flaws that implementation hygiene alone cannot address.

## Violations to detect

- No rate limiting on authentication endpoints (allows credential stuffing at scale)
- Password reset flows that reveal whether an email address is registered
- Multi-step workflows with no server-side state validation (steps can be skipped)
- Business logic that allows negative quantities, impossible date ranges, or other nonsensical inputs
- No threat model considered during design — security requirements not defined before implementation

## Good practice

- Conduct threat modelling (STRIDE or similar) during design, before writing code
- Define security requirements as user stories: "As an attacker, I cannot enumerate registered emails via the reset flow"
- Apply secure design patterns: defence in depth, fail secure, least privilege, complete mediation
- Perform security design reviews before implementation begins on new features

## Sources

- OWASP Foundation. "A04:2021 – Insecure Design." *OWASP Top 10*, 2021. https://owasp.org/Top10/A04_2021-Insecure_Design/
- Shostack, Adam. *Threat Modeling: Designing for Security*. Wiley, 2014. ISBN 978-1-118-80999-0.
