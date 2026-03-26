# OWASP-05-SECURITY-MISCONFIGURATION — Security Misconfiguration

**Layer:** 2 (contextual)
**Categories:** security, configuration, hardening
**Applies-to:** all
**Summary:** Change defaults, disable unused features, and enforce hardening checklists across all components and environments.

## Principle

Secure and harden all configuration: default credentials changed, unnecessary features disabled, error messages that do not leak implementation details, security headers in place, and all software kept up to date. Misconfiguration is the most commonly seen issue in practice.

## Why it matters

Default configurations are optimised for ease of use, not security. Default passwords, open admin consoles, verbose error messages exposing stack traces, permissive CORS, and missing security headers are trivially exploitable — they require no sophisticated attack, just knowledge of the default.

## Violations to detect

- Default credentials not changed (admin/admin, changeme)
- Verbose error responses exposing stack traces, SQL queries, or file paths to clients
- Missing HTTP security headers: `Content-Security-Policy`, `X-Frame-Options`, `Strict-Transport-Security`
- Cloud storage buckets or databases exposed publicly with no authentication required
- Debug features or admin endpoints enabled in production
- Directory listing enabled on web servers

## Good practice

- Establish a hardening checklist for each component type; enforce it in the deployment pipeline
- Use security scanner tooling (DAST, cloud posture management) to detect misconfigurations automatically
- Implement a minimal configuration: disable everything not explicitly needed
- Send generic error messages to clients; log full details server-side

## Sources

- OWASP Foundation. "A05:2021 – Security Misconfiguration." *OWASP Top 10*, 2021. https://owasp.org/Top10/A05_2021-Security_Misconfiguration/
