# OWASP-06-VULNERABLE-COMPONENTS - Vulnerable and Outdated Components

**Layer:** 2 (contextual)
**Categories:** security, dependency-management, supply-chain
**Applies-to:** all
**Summary:** Track all dependency versions, run SCA in CI, and fail builds on high-severity known vulnerabilities.

## Principle

Know the versions of all components - libraries, frameworks, OS packages, runtime environments - and keep them free of known vulnerabilities. Components run with the same privileges as the application; a vulnerability in a dependency is a vulnerability in your application.

## Why it matters

Modern applications are mostly composed code - the application itself may be 10% of the total running code, with 90% coming from dependencies. Known vulnerabilities in widely used libraries (Log4Shell, Heartbleed, Spring4Shell) are weaponised within hours of public disclosure and exploited en masse against unpatched systems.

## Violations to detect

- No software composition analysis (SCA) in the CI pipeline
- Dependencies pinned to versions with known CVEs
- No process to receive and act on vulnerability alerts for project dependencies
- Transitive dependencies not tracked or audited
- Long-lived applications with no dependency update policy

## Good practice

- Run SCA tools (`npm audit`, `trivy`, `OWASP Dependency-Check`, `Snyk`) in CI and fail builds on high-severity CVEs
- Subscribe to vulnerability feeds for your key dependencies
- Keep dependencies up to date with automated pull requests (Dependabot, Renovate)
- Maintain a software bill of materials (SBOM) for compliance and incident response

## Sources

- OWASP Foundation. "A06:2021 - Vulnerable and Outdated Components." *OWASP Top 10*, 2021. https://owasp.org/Top10/A06_2021-Vulnerable_and_Outdated_Components/
