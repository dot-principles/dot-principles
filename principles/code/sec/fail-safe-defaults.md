# CODE-SEC-FAIL-SAFE-DEFAULTS — Default to denial; fail closed

**Layer:** 1 (universal)
**Categories:** security, reliability
**Applies-to:** all
**Summary:** Deny access by default; any error or ambiguity in an authorization check must result in denial, never access.

## Principle

Access decisions must default to denial. When authorisation state is absent, ambiguous, or fails to evaluate, the system must choose the secure (closed) state, not the open one. A missed configuration, an unhandled exception in an access check, or a missing role mapping should result in access denied — never access granted.

## Why it matters

A permissive default means that any error, misconfiguration, or unanticipated code path silently grants access. Most major access control vulnerabilities trace back to a code path that was expected to be unreachable but fell through to "permitted". Fail-safe defaults ensure that the worst outcome of a system failure is a denial of service, not a privilege escalation or data breach. The cost of an incorrectly denied request is a user complaint; the cost of an incorrectly granted request may be a breach.

## Violations to detect

- A `try/catch` block around an authorisation check that returns `true` (allowed) on exception rather than re-throwing or denying
- A feature-flag check that returns enabled/allowed when the flag store is unavailable
- A route-level access check that defaults to allowed when no roles or policies are configured for that route
- Middleware that skips authorisation when it cannot determine the user's identity
- ACL or permission checks where an unknown role is treated as having broad permissions rather than none

## Inspection

- `grep -rnE 'catch.*\{[^}]*(return true|return "allow"|allowed = true)' --include="*.java" --include="*.cs" --include="*.kt" $TARGET` | HIGH | Authorization check swallowed with permissive return

## Good practice

- Return `403 Forbidden` or `401 Unauthorized` from any code path that cannot positively confirm authorisation
- Design permission checks as allowlists: explicitly grant what is permitted; everything else is denied
- Treat exceptions in security code as security failures — log, alert, and deny, never silently allow
- Test the failure mode of every access check: disconnect the authorisation service and verify the system fails closed
- Use a deny-by-default ACL base rule; add explicit allow rules on top

## Sources

- Saltzer, J.H. and Schroeder, M.D. "The Protection of Information in Computer Systems." *Proceedings of the IEEE*, 63(9), 1975. (Principle of Fail-Safe Defaults.)
- OWASP Foundation. "Access Control Cheat Sheet — Deny by Default." https://cheatsheetseries.owasp.org/cheatsheets/Access_Control_Cheat_Sheet.html
