# OWASP-08-SOFTWARE-INTEGRITY-FAILURES — Software and Data Integrity Failures

**Layer:** 2 (contextual)
**Categories:** security, supply-chain, integrity
**Applies-to:** all
**Summary:** Verify checksums and signatures for all artifacts; never deserialize untrusted data into complex objects.

## Principle

Protect the integrity of software update pipelines, CI/CD pipelines, and serialised data. Integrity failures occur when code or data is used without verification that it has not been tampered with — unsigned updates, insecure deserialization, CI/CD pipeline compromise, and untrusted CDN resources.

## Why it matters

Software integrity failures enable supply-chain attacks: compromised update packages, malicious CDN scripts, or a hijacked CI pipeline can silently deliver attacker-controlled code to all users. The SolarWinds and XZ Utils compromises demonstrate the catastrophic scale possible when integrity checks are absent.

## Violations to detect

- Installing packages without verifying checksums or signatures
- Loading JavaScript from a CDN without Subresource Integrity (SRI) hashes
- Deserializing untrusted data without validation (insecure deserialization)
- CI/CD pipeline with write access to production that is not protected by access controls or approvals
- Auto-updating dependencies without review in a production pipeline

## Good practice

- Verify checksums and signatures for all downloaded artifacts and packages
- Use SRI (`integrity` attribute) for external scripts and stylesheets loaded from CDNs
- Never deserialise untrusted data into complex objects; use data-transfer objects with explicit field mapping
- Protect CI/CD pipelines: require approval for production deployments, audit who can modify pipeline config
- Sign build artifacts and verify signatures at deployment

## Sources

- OWASP Foundation. "A08:2021 – Software and Data Integrity Failures." *OWASP Top 10*, 2021. https://owasp.org/Top10/A08_2021-Software_and_Data_Integrity_Failures/
