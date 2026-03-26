# CODE-SEC-DEFENSE-IN-DEPTH — Layer independent security controls

**Layer:** 1 (universal)
**Categories:** security
**Applies-to:** all
**Summary:** Layer independent security controls so that no single failure grants full access to a protected resource.

## Principle

Layer independent security controls so that no single failure is catastrophic. Each layer — authentication, authorisation, input validation, encryption, audit logging — must function as if every other layer may be absent or already compromised. An attacker who defeats one layer should immediately face the next.

## Why it matters

A single security control creates a binary outcome: it holds, or the system is fully open. When a perimeter firewall is the only barrier, a firewall bypass grants complete access. Layered controls bound the blast radius of any single failure: bypassing the API gateway still meets authorisation checks at the service layer; bypassing authorisation still hits encryption at rest and audit logging. Defense in depth does not prevent breaches — it makes their consequences survivable and detectable.

## Violations to detect

- A single authentication check as the only barrier to a sensitive resource — no downstream authorisation layer
- No authorisation check inside a service because the API gateway "already authenticated the caller"
- Sensitive data stored unencrypted on the assumption that the database host is inaccessible
- No audit logging on the grounds that access controls are considered sufficient
- No network segmentation because all traffic is assumed to be from trusted internal sources
- Input validation only at the perimeter with no re-validation at the service boundary

## Good practice

- Apply controls at every boundary: network → API gateway → service layer → database → encryption at rest
- Design each layer to stand alone — remove any one layer and the system should still resist the next most likely attack
- Treat audit logging as a required independent layer, not optional — it is the layer that makes other failures visible
- Use short-lived credentials and session tokens so that a compromised credential has a bounded blast radius
- Test defense in depth explicitly: red-team exercises that assume one layer is bypassed verify that the next layer holds

## Sources

- NIST. *Special Publication 800-53 Rev 5: Security and Privacy Controls for Information Systems and Organizations.* 2020. https://doi.org/10.6028/NIST.SP.800-53r5 (SA-8: Defense-in-Depth.)
- NSA/CISA. "Defense in Depth: A Practical Strategy for Achieving Information Assurance." IA-032. https://media.defense.gov/2021/Aug/03/2002820425/-1/-1/1/CTR_CYBERSECURITY_TECHNICAL_REPORT_DEFENSE_IN_DEPTH.PDF
