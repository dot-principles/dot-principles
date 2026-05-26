# SEC-ARCH-OPEN-DESIGN - Security must not depend on secrecy of the mechanism

**Layer:** 2 (contextual)
**Categories:** security, architecture
**Applies-to:** all
**Summary:** Design security to remain strong when fully disclosed; derive it from key secrecy, never from obscurity.

## Principle

The security of a system must not depend on the secrecy of its design, algorithms, or implementation. Assume that an attacker has full knowledge of the system's architecture, source code, and security mechanisms. Security must derive from the secrecy of keys and credentials - not from the obscurity of the mechanism itself. A system whose security collapses when its design is revealed was never secure.

## Why it matters

Security through obscurity is fragile because obscurity is temporary. Source code leaks, reverse engineering, insider knowledge, and open-source dependencies all erode the secrecy of a mechanism. Once the mechanism is known, the security it provided vanishes instantly and completely. Conversely, systems designed on the assumption that the attacker knows the mechanism - Kerckhoffs's principle - remain secure even after full disclosure because their security rests on a replaceable secret (a key) rather than on an irreplaceable structural property (the design). This is why AES remains secure despite its algorithm being public, while proprietary encryption schemes routinely fail when reverse-engineered.

## Violations to detect

- Hardcoded secret values (API keys, passwords, tokens) used as the primary security barrier rather than as one layer of a key-based system
- Custom or proprietary encryption algorithms instead of peer-reviewed, published standards (AES, ChaCha20, RSA, Ed25519)
- Security that depends on URL obscurity - unprotected admin endpoints, debug routes, or internal APIs that are "hidden" but not authenticated
- Obfuscation of code or configuration treated as a security control rather than as an anti-tampering convenience
- Internal API endpoints with no authentication because they are "not publicly documented"
- Comments or documentation stating that a mechanism's security depends on attackers not knowing how it works

## Inspection

- `grep -rnE '(secret|password|token|api_key|apikey)\s*=\s*["\x27][^"\x27]{8,}' --include="*.java" --include="*.py" --include="*.ts" --include="*.go" --include="*.cs" --include="*.rb" --include="*.env" $TARGET` | HIGH | Hardcoded secret used as security mechanism
- `grep -rnE '(security|safe|secure|protected).*obscur|obscur.*(security|safe|secure|protected)' --include="*.md" --include="*.txt" --include="*.java" --include="*.py" --include="*.ts" $TARGET` | MEDIUM | Reference to security through obscurity

## Good practice

- Use only published, peer-reviewed cryptographic algorithms and protocols - treat any proprietary security mechanism as insecure until proven otherwise
- Protect all endpoints with authentication and authorisation regardless of whether they are publicly documented or externally routable
- Store secrets (keys, tokens, credentials) in dedicated secret management systems (Vault, AWS Secrets Manager, Azure Key Vault) - never in source code, configuration files, or environment variables baked into images
- Design security mechanisms to be auditable: open-source components, published threat models, and documented security architectures that can withstand public scrutiny
- Treat obfuscation as a nuisance for attackers, not a security boundary - all real security must hold when the obfuscation is removed
- Regularly rotate keys and credentials so that even if a secret is compromised, the window of exposure is bounded

## Sources

- Saltzer, J.H. and Schroeder, M.D. "The Protection of Information in Computer Systems." *Proceedings of the IEEE*, 63(9), 1975. DOI 10.1109/PROC.1975.9939. (Principle of Open Design.)
- Kerckhoffs, Auguste. "La cryptographie militaire." *Journal des sciences militaires*, 1883. (Kerckhoffs's principle - foundational formulation of open design in cryptography.)
- Schneier, Bruce. *Applied Cryptography.* 2nd ed. Wiley, 1996. ISBN 978-0-471-11709-4. (Discussion of why security through obscurity fails.)
