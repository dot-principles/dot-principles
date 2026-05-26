# OWASP-07-AUTHENTICATION-FAILURES - Identification and Authentication Failures

**Layer:** 3 (risk-elevated)
**Categories:** security, authentication, session-management
**Applies-to:** all
**Summary:** Use MFA, rate-limit login endpoints, use vetted auth libraries, and invalidate sessions on logout.

## Principle

Implement authentication and session management correctly. Failures include permitting credential stuffing, brute force, weak passwords, insecure credential recovery, missing or ineffective multi-factor authentication, weak session tokens, and improper session invalidation.

## Why it matters

Authentication is the gateway to everything else. A broken authentication implementation allows attackers to assume other users' identities, bypass all authorisation controls, and access all data the compromised account can reach. Automated credential stuffing attacks test millions of stolen credential pairs at scale.

## Violations to detect

- No rate limiting or account lockout on login endpoints
- Passwords stored insecurely (plain text, MD5, unsalted hash - see also A02)
- Session tokens with insufficient entropy or predictable values
- Session tokens not invalidated on logout or after a timeout
- Password reset tokens that do not expire or can be reused
- Allowing passwords from known-breached lists or with no minimum complexity
- Missing multi-factor authentication for high-value or admin accounts

## Good practice

- Implement multi-factor authentication for all accounts; require it for admin and privileged accounts
- Use a battle-tested authentication library or identity provider rather than a custom implementation
- Enforce session expiry and invalidate server-side session state on logout
- Require strong passwords; check against breach databases (HaveIBeenPwned API)
- Rate-limit and monitor authentication endpoints; alert on anomalous login patterns

## Sources

- OWASP Foundation. "A07:2021 - Identification and Authentication Failures." *OWASP Top 10*, 2021. https://owasp.org/Top10/A07_2021-Identification_and_Authentication_Failures/
- OWASP Foundation. "Authentication Cheat Sheet." https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html
