# OWASP-10-SSRF — Server-Side Request Forgery (SSRF)

**Layer:** 2 (contextual)
**Categories:** security, injection, network
**Applies-to:** all
**Summary:** Validate all server-side request URLs against a strict allowlist of permitted schemes, hosts, and ports.

## Principle

Validate and restrict all server-side requests to remote resources. SSRF flaws occur when an application fetches a remote resource using a URL or address supplied or influenced by user input, allowing an attacker to coerce the server to send requests to unintended destinations — internal services, cloud metadata endpoints, or arbitrary internet hosts.

## Why it matters

In cloud-native architectures, SSRF is particularly dangerous: the AWS/GCP/Azure metadata endpoint (`169.254.169.254`) is accessible from the server and can return IAM credentials with a single unauthenticated request. SSRF can bypass firewalls, access internal services invisible to external attackers, and escalate to full cloud account compromise.

## Violations to detect

- Accepting a URL as user input and fetching it server-side without validation
- No allowlist of permitted destination hosts or IP ranges for outbound server-side requests
- HTTP redirect following that can redirect from an allowlisted host to an internal address
- DNS rebinding protections absent — hostname resolves to a public IP but rebinds to internal before the request
- Access to internal metadata endpoints (`169.254.169.254`, `fd00:ec2::254`) not blocked

## Good practice

- Validate user-supplied URLs against a strict allowlist of permitted schemes, hosts, and ports
- Resolve hostnames and verify the resulting IP is not in private or reserved ranges before connecting
- Disable HTTP redirects in the HTTP client used for user-initiated fetches, or re-validate after each redirect
- Use network segmentation so the application server cannot reach internal services it does not need
- Block requests to cloud metadata endpoints at the network level (IMDSv2 enforcement on AWS)

## Sources

- OWASP Foundation. "A10:2021 – Server-Side Request Forgery (SSRF)." *OWASP Top 10*, 2021. https://owasp.org/Top10/A10_2021-Server-Side_Request_Forgery_%28SSRF%29/
