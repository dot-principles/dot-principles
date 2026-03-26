# SEC-ARCH-PSYCHOLOGICAL-ACCEPTABILITY — Security must not make the system harder to use correctly

**Layer:** 2 (contextual)
**Categories:** security, architecture, usability
**Applies-to:** all
**Summary:** Make the secure path the easiest path; security controls must never incentivize workarounds.
**Audit-scope:** limited — fully auditable for overly complex configuration, excessive permission prompts, and convoluted security APIs; not auditable for subjective user experience friction

## Principle

Security mechanisms must be designed so that the secure path is the easiest path. If a security control makes the system harder to use correctly than to use insecurely, users and developers will find workarounds that defeat the control entirely. The mental model required to use the system securely must match the mental model users already have; where it cannot, the difference must be minimal and clearly communicated.

## Why it matters

Security controls that are painful to use do not make systems secure — they make systems insecure in less visible ways. Developers who face an onerous secrets management API will hardcode credentials. Users confronted with frequent, confusing permission prompts will click "allow all" reflexively. Operations teams given a firewall rule syntax that requires a PhD in networking will leave rules overly broad. The control itself is irrelevant if the humans interacting with it are incentivised to circumvent it. Every workaround a user invents to avoid a security control is an unmonitored, unaudited bypass.

## Violations to detect

- Security configuration that requires editing multiple files across different locations to perform a single logical operation
- Secret or credential management APIs that are significantly more complex to use correctly than hardcoding the value
- Permission prompts or confirmation dialogs that appear so frequently that users develop click-through habits
- Authentication flows that require more than 2-3 steps for routine access, encouraging users to share long-lived tokens
- Security documentation that exists only as a dense, monolithic reference without task-oriented guides for common operations
- Security-critical APIs where the insecure usage pattern requires fewer lines of code than the secure pattern

## Good practice

- Make the secure default the easiest default: secure configuration out of the box, explicit opt-out for insecure options
- Provide clear, task-oriented documentation for common security operations — not just a reference manual
- Design security APIs so that the correct usage requires the fewest lines of code; make incorrect usage syntactically awkward or impossible
- Minimise the number of security decisions users must make; where decisions are required, present clear options with sensible defaults
- Conduct usability testing on security-critical flows; measure how often users take the insecure path and treat that as a security bug
- When a security control must add friction, explain *why* at the point of friction — informed users tolerate necessary inconvenience

## Sources

- Saltzer, J.H. and Schroeder, M.D. "The Protection of Information in Computer Systems." *Proceedings of the IEEE*, 63(9), 1975. DOI 10.1109/PROC.1975.9939. (Principle of Psychological Acceptability.)
- Whitten, Alma and Tygar, J.D. "Why Johnny Can't Encrypt: A Usability Evaluation of PGP 5.0." *Proceedings of the 8th USENIX Security Symposium*, 1999. (Foundational usable security study.)
- NIST. *Special Publication 800-63B: Digital Identity Guidelines — Authentication and Lifecycle Management.* 2017. https://doi.org/10.6028/NIST.SP.800-63b (Usability considerations for authenticators.)
