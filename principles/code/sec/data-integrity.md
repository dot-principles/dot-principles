# CODE-SEC-DATA-INTEGRITY — Verify data integrity

**Layer:** 2 (contextual)
**Categories:** security
**Applies-to:** all
**Summary:** Verify the integrity of all software artifacts, dependencies, and data before consuming them.

## Principle

Ensure that software updates, critical data, and CI/CD pipelines are protected against integrity violations. Software and Data Integrity Failures (A08:2021) occur when code and infrastructure do not verify the integrity of what they consume — unsigned software updates, untrusted deserialization, dependency confusion, and compromised CI/CD pipelines all fall under this category. Every artifact entering the system should be verified against a trusted source.

## Why it matters

Attackers who can inject malicious code into a software update, a dependency, or a build pipeline can compromise every user of that software at once. Supply chain attacks (e.g., SolarWinds, event-stream, codecov) have demonstrated that a single compromised component can affect thousands of organizations. Insecure deserialization can lead to remote code execution.

## Violations to detect

- Dependencies pulled without integrity verification (missing lock files, no checksum verification)
- Software updates delivered without digital signatures or signature verification
- Insecure deserialization of untrusted data without type restrictions or integrity checks
- CI/CD pipelines that pull dependencies or scripts from unverified sources
- Missing code review or approval gates on changes to build and deployment configurations
- Auto-update mechanisms that do not verify the authenticity of updates

## Good practice

- Use lock files and verify dependency checksums or signatures on every build
- Sign software releases and verify signatures before deployment or installation
- Avoid insecure deserialization; use safe serialization formats (JSON, Protocol Buffers) and validate schemas
- Protect CI/CD pipelines with access controls, audit logs, and segregation of duties
- Use dependency pinning and private artifact repositories to prevent dependency confusion attacks
- Implement code review and approval requirements for changes to build scripts and infrastructure configuration

## Sources

- OWASP Foundation. "OWASP Top 10:2021 — A08:2021 Software and Data Integrity Failures." https://owasp.org/Top10/A08_2021-Software_and_Data_Integrity_Failures/
