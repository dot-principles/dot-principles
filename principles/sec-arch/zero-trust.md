# SEC-ARCH-ZERO-TRUST - Never trust implicitly; verify every request

**Layer:** 2 (contextual)
**Categories:** security, architecture, networking
**Applies-to:** all
**Summary:** Authenticate and authorize every request explicitly; never grant implicit trust based on network location.

## Principle

Never grant implicit trust based on network location. Every request - regardless of whether it originates inside or outside the corporate perimeter - must be authenticated with a verified identity, authorised for the specific resource being accessed, and transmitted over an encrypted channel. Trust is established per-request through cryptographic verification, not inherited from the network segment the caller resides in.

## Why it matters

The traditional perimeter model assumes that anything inside the corporate network is trusted. Lateral movement attacks, insider threats, compromised cloud workloads, and the dissolution of stable perimeters in multi-cloud and remote-work environments make this assumption invalid. Once an attacker gains access to the internal network - through a phishing attack, a compromised CI runner, or a misconfigured VPC peering rule - they inherit all implicit trust and can move laterally without restriction. Zero trust eliminates the implicit trust grant; a compromised internal host gains no access to adjacent services beyond what its verified identity explicitly permits.

## Violations to detect

- Service-to-service calls within the same VPC, subnet, or Kubernetes cluster that skip authentication on the assumption that "it's internal traffic"
- Authorisation checks absent on internal API endpoints that are not publicly routable
- Unencrypted inter-service communication (plain HTTP) on the assumption that the internal network is private
- Identity established by source IP address or network segment rather than by cryptographically verified credentials (mTLS, JWT signed by a trusted issuer)
- Long-lived service credentials (API keys, passwords) without automatic rotation
- No network segmentation between services - any compromised workload can reach any other workload on all ports

## Good practice

- Require mutual TLS (mTLS) for all service-to-service communication; use a service mesh (Istio, Linkerd) to enforce it uniformly
- Issue short-lived, scoped credentials (SPIFFE/SPIRE SVIDs, workload identity tokens) to every service; rotate automatically
- Apply authorisation at the resource level for every internal API call, not only at the perimeter
- Segment the network by service identity, not by subnet: a compromised service should have network access only to the services it legitimately calls
- Log every authenticated request with the verified identity - not just the source IP
- Apply the same authentication and authorisation standards to internal tooling, CI pipelines, and build systems as to user-facing APIs

## Sources

- Rose, Scott et al. *NIST Special Publication 800-207: Zero Trust Architecture.* NIST, 2020. https://doi.org/10.6028/NIST.SP.800-207
- Kindervag, John. "Build Security Into Your Network's DNA: The Zero Trust Network Architecture." Forrester Research, 2010. (Foundational paper coining the term.)
- CISA. "Zero Trust Maturity Model." CISA, 2023. https://www.cisa.gov/zero-trust-maturity-model
