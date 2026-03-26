# CODE-SEC-COMPLETE-MEDIATION — Check every access, on every request

**Layer:** 2 (contextual)
**Categories:** security, access-control
**Applies-to:** all
**Summary:** Verify every access to every resource against the authorization policy on every request without exception.

## Principle

Every access to every resource must be verified against the authorisation policy on every request. Do not cache authorisation decisions beyond the lifetime of a single request, assume a prior successful check still applies, or rely on login-time permission checks to govern subsequent resource access.

## Why it matters

Stale authorisation caches, session tokens that outlive permission changes, and "we already checked at login" assumptions are a recurring root cause of privilege escalation bugs. When a user's role is revoked or a resource's visibility is changed, any cached authorisation decision instantly becomes incorrect. Complete mediation ensures that every operation reflects the current policy state — not the policy that was in effect when the session was created or the last explicit check was made.

## Violations to detect

- Authorisation decision cached in memory beyond the scope of a single request and not revalidated when the underlying permission changes
- Permission check performed at login or session creation time but not at the point of resource access
- Access control decisions based on the presence of a valid session token alone, without re-verifying entitlements for the specific resource
- Object-level (row-level) authorisation absent — callers can retrieve any record by ID if they know it, because only collection-level access is checked
- Revoked tokens or permissions that remain effective until cache TTL expires rather than taking effect immediately

## Good practice

- Perform authorisation at the resource level on every request — not just at the route or collection level
- Use short cache TTLs for authorisation decisions (seconds, not minutes) and implement a revocation signal to flush cached grants immediately
- For sensitive operations (payments, privilege changes, data export), re-verify entitlements at the point of execution regardless of prior checks
- Implement object-level authorisation: verify the requesting identity owns or is permitted to access the specific record being fetched, not just the resource type
- Log every authorisation decision — both grants and denials — to support anomaly detection and forensic analysis

## Sources

- Saltzer, J.H. and Schroeder, M.D. "The Protection of Information in Computer Systems." *Proceedings of the IEEE*, 63(9), 1975. (Principle of Complete Mediation.)
- OWASP Foundation. "Insecure Direct Object Reference Prevention Cheat Sheet." https://cheatsheetseries.owasp.org/cheatsheets/Insecure_Direct_Object_Reference_Prevention_Cheat_Sheet.html
