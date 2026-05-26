# SEC-ARCH-ECONOMY-OF-MECHANISM - Keep security mechanisms as simple as possible

**Layer:** 2 (contextual)
**Categories:** security, architecture, maintainability
**Applies-to:** all
**Summary:** Keep security mechanisms as small and simple as possible; use established libraries, never custom cryptography.

## Principle

Security mechanisms must be as simple and small as possible so that they can be correctly implemented, thoroughly tested, and confidently reasoned about. Every line of security-critical code is a potential source of vulnerability; complexity in authentication, authorisation, encryption, or access control logic multiplies the number of states an attacker can exploit and the number of paths a reviewer must verify.

## Why it matters

Complex security mechanisms are difficult to audit, easy to misuse, and fragile under change. Custom cryptographic protocols, bespoke session management, and multi-layered ACL engines with overlapping rules routinely harbour vulnerabilities that survive multiple review cycles precisely because reviewers cannot hold the full state space in their heads. The SolarWinds compromise, the Heartbleed bug, and the majority of authentication bypass CVEs trace back to unnecessary complexity in security-critical code paths. A simple mechanism that is fully understood and correctly implemented provides stronger security than a sophisticated one that nobody can completely verify.

## Violations to detect

- Custom cryptographic algorithms or hand-rolled protocol implementations instead of using established libraries (OpenSSL, libsodium, bcrypt)
- Authentication or authorisation logic scattered across multiple modules with overlapping, inconsistent rules
- Access control lists with redundant, conflicting, or deeply nested rules that make it unclear what effective permissions a principal has
- Security middleware with multiple code paths for the same decision, some of which are dead or untested
- Token validation logic that manually parses JWTs rather than using a vetted library
- Complex session management with custom expiry, renewal, and revocation logic when a standard session framework is available

## Inspection

- `grep -rnE '(AES|DES|RSA|SHA[0-9]|HMAC|encrypt|decrypt|cipher)\s*[\(\.]' --include="*.java" --include="*.py" --include="*.ts" --include="*.go" --include="*.cs" $TARGET` | MEDIUM | Potential hand-rolled cryptography - verify library usage

## Good practice

- Use well-established, widely-audited libraries for all cryptographic operations - never implement your own
- Centralise authentication and authorisation in a single, well-tested module or middleware; do not scatter security decisions across the codebase
- Prefer flat, explicit allow-lists over complex hierarchical permission models
- Limit the number of code paths that handle security-critical decisions; each additional branch is a potential bypass
- Prefer standard protocols (OAuth 2.0, OpenID Connect, SAML) over bespoke authentication flows
- Regularly audit security-critical code for dead paths, redundant checks, and unnecessary complexity

## Sources

- Saltzer, J.H. and Schroeder, M.D. "The Protection of Information in Computer Systems." *Proceedings of the IEEE*, 63(9), 1975. DOI 10.1109/PROC.1975.9939. (Principle of Economy of Mechanism.)
- OWASP Foundation. "Security by Design Principles." https://wiki.owasp.org/index.php/Security_by_Design_Principles (accessed 2026-03-22.)
