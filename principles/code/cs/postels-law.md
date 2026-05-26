# CODE-CS-POSTELS-LAW - Postel's Law (Robustness Principle)

**Layer:** 2 (contextual)
**Categories:** api-design, interoperability, resilience
**Applies-to:** apis, protocols, integrations
**Summary:** Be conservative in what you send and liberal in what you accept.

## Principle

Be conservative in what you send; be liberal in what you accept. When producing output, conform strictly to the spec - send only well-formed, minimal, expected data. When consuming input, be tolerant of minor variations: extra fields, different orderings, whitespace differences, missing optional values. This asymmetry makes systems more interoperable and more resilient to the inevitable imperfections of real-world integrations.

## Why it matters

In distributed systems and public APIs, producers and consumers evolve independently. A receiver that rejects any input not exactly matching its expectations breaks on legitimate variations from conforming senders. A sender that emits extra, unexpected data breaks receivers that fail on unknown fields. The robustness principle allows systems to interoperate across versions and across imperfect implementations.

## Violations to detect

- Rejecting requests that contain unknown or extra fields rather than ignoring them
- Strict schema validation that rejects cosmetically different but semantically equivalent input (e.g. `"true"` vs `true`, extra whitespace, different date formats)
- Sending undocumented fields, large payloads, or non-standard values "because the receiver currently ignores them"
- Emitting error responses that expose internal stack traces, implementation details, or inconsistent formats

## Good practice

- On the receive side: ignore unknown fields, apply lenient parsing for format variations, treat missing optional fields as their defined defaults
- On the send side: emit only documented fields, use standard formats, omit optional fields when empty rather than sending nulls
- Apply extra conservatism at public API boundaries - what you send becomes part of your implicit contract (see Hyrum's Law)
- Do not take liberal acceptance as licence to accept malformed or malicious input - validate for security and correctness, tolerate for interoperability

## Sources

- Postel, Jon. *RFC 793: Transmission Control Protocol*, DARPA, 1981. §2.10: "Robustness Principle."
- Deutsch, Martin. "The Robustness Principle Reconsidered." (critique: liberal acceptance can propagate errors - apply with judgement)
