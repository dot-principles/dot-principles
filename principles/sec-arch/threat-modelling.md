# SEC-ARCH-THREAT-MODELLING - Model threats before implementing security controls

**Layer:** 2 (contextual)
**Categories:** security, architecture
**Applies-to:** all
**Summary:** Enumerate threats with STRIDE before implementation and document every mitigation in version-controlled artifacts.
**Audit-scope:** excluded - threat modelling is a design-time process; whether it occurred cannot be determined from code alone

## Principle

Before implementing any security-sensitive feature, systematically enumerate threats using a structured methodology such as STRIDE or PASTA. Identify trust boundaries, data flows, threat actors, and attack vectors; document mitigations against each threat; and produce a durable artifact that is reviewed alongside the design and updated as the system evolves.

## Why it matters

Security controls added reactively address known, already-exploited threats. Threat modelling before implementation surfaces the unknown ones - the missing rate limiter, the unvalidated trust boundary, the unauthenticated admin endpoint - before they become vulnerabilities in production. The STRIDE framework (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege) provides a structured prompt that reliably surfaces categories of threats that are missed when security is reasoned about informally. The cost of identifying a missing control in a design review is orders of magnitude less than the cost of a breach.

## Violations to detect

- No threat model documented for features that handle authentication, authorisation, payments, or PII
- Trust boundaries not identified - components operating at different trust levels communicate without explicit validation
- Security design review conducted after implementation decisions are locked in, when changes are costly
- Threats discussed verbally during design but not recorded, tracked, or verified during implementation
- Data flow diagrams absent - it is not possible to reason about what crosses a trust boundary

## Good practice

- Draw a data flow diagram (DFD) for every significant feature: identify actors, processes, data stores, and the trust boundaries between them
- Apply STRIDE to each element: for each process and data flow, ask which of the six threat categories applies and what the mitigation is
- Record threats and mitigations in a durable document (ADR, design doc, or a dedicated threat model file) stored in version control alongside the code
- Treat unmitigated threats as open issues that block launch, just as failing tests block a release
- Update the threat model whenever trust boundaries, data flows, or authentication models change
- Use OWASP Threat Dragon, Microsoft Threat Modeling Tool, or a structured template to guide the process

## Sources

- Shostack, Adam. *Threat Modeling: Designing for Security.* Wiley, 2014. ISBN 978-1-118-80990-8.
- OWASP Foundation. "Threat Modeling Cheat Sheet." https://cheatsheetseries.owasp.org/cheatsheets/Threat_Modeling_Cheat_Sheet.html (accessed 2026-03-16.)
- Microsoft. "STRIDE Threat Modeling." https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats (accessed 2026-03-16.)
