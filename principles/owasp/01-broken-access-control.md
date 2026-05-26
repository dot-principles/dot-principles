# OWASP-01-BROKEN-ACCESS-CONTROL - Broken Access Control

**Layer:** 2 (contextual)
**Categories:** security, access-control, authorisation
**Applies-to:** all
**Summary:** Enforce server-side authorisation on every request; deny by default and verify resource ownership explicitly.

## Principle

Enforce authorisation checks on every request for a protected resource or action. Access control failures occur when users can act outside their intended permissions - reading another user's data, accessing admin functions, or elevating their own privilege. Controls must be enforced server-side, not just client-side.

## Why it matters

Broken access control was the #1 OWASP risk in 2021, found in 94% of tested applications. Client-side hiding is not access control. Without server-side enforcement, any user who knows or guesses the URL or API endpoint can access data and functionality they are not authorised to use.

## Violations to detect

- Accessing resources by manipulating a URL or API parameter (e.g., changing `/users/123/data` to `/users/124/data` with no ownership check)
- Accessing admin endpoints without verifying admin role on the server
- Viewing or modifying another user's data because the only check is whether the user is logged in, not whether they own the resource
- CORS misconfiguration that allows untrusted origins to make credentialed requests
- Force-browsing to pages that are hidden from the UI but not protected by server-side access checks

## Good practice

- Deny by default: return 403 unless access is explicitly permitted
- Enforce object-level authorisation: verify the authenticated user owns or is permitted to access the specific resource, not just the resource type
- Use a centralised authorisation library or middleware rather than ad-hoc checks scattered through handler code
- Log access control failures and alert on repeated failures

## Sources

- OWASP Foundation. "A01:2021 - Broken Access Control." *OWASP Top 10*, 2021. https://owasp.org/Top10/A01_2021-Broken_Access_Control/
