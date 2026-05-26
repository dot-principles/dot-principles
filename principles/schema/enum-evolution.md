# SCHEMA-ENUM-EVOLUTION - Enums must be safe to extend; consumers must handle unknown values

**Layer:** 1 (universal)
**Categories:** schema-design, reliability, api-design
**Applies-to:** schema
**Summary:** Every enum must include an UNSPECIFIED sentinel and all consumers must handle unknown values without crashing.

## Principle

Every enum in a published schema must include an explicit unknown or unspecified sentinel value, and every consumer must handle enum values it does not recognise without crashing or discarding the containing message. Adding a new variant to an enum is a routine schema evolution; if any consumer treats an unknown variant as an error, enum extension becomes a breaking change that requires lockstep deployment of all consumers - defeating independent deployability.

## Why it matters

Enums are one of the most common sources of subtle schema incompatibility. When a new variant is added, producers begin emitting it immediately after deployment. If a consumer running the old schema version receives the new variant and has no fallback behaviour - because the enum is closed, or because the deserialization framework throws on unknown values - the consumer fails on valid data. In Protobuf, an unknown enum value in proto3 is preserved as its integer representation, but code that uses a `switch` without a `default` case will silently ignore it or crash. In OpenAPI, a closed `enum` list causes client-side validation to reject the response. The sentinel value and the fallback code path are not optional extras - they are the mechanism that makes enum evolution non-breaking.

## Violations to detect

- Protobuf enums whose first value (field number 0) is not an explicit `UNSPECIFIED` or `UNKNOWN` sentinel
- Protobuf enums that lack a comment or documentation noting that consumers must handle unknown values
- OpenAPI enums without documentation stating the list is non-exhaustive, or without an explicit `UNKNOWN` / `OTHER` variant
- `switch` / `match` / `case` statements on enum values that do not include a `default` / `_` / `else` branch handling unrecognised values
- Client-generated code from OpenAPI specs that throws on enum values not in the spec's `enum` list
- Avro enums without a `default` symbol - Avro 1.11+ requires a default for forward-compatible schema resolution

## Inspection

- `grep -rnE '^\s*enum\s+\w+\s*\{' --include="*.proto" -A 2 $TARGET` | MEDIUM | Protobuf enum - verify first value is UNSPECIFIED/UNKNOWN (field number 0)
- `grep -rnE 'enum:\s*\[' --include="*.yaml" --include="*.yml" --include="*.json" $TARGET` | MEDIUM | OpenAPI enum - verify UNKNOWN variant or non-exhaustive documentation exists

## Good practice

- In Protobuf, always define the first enum value (field number 0) as `FOO_UNSPECIFIED = 0;` - proto3 uses 0 as the default, so it must be a safe, explicit sentinel
- In OpenAPI, document every enum as non-exhaustive and include an `UNKNOWN` or `OTHER` variant; alternatively, use `x-extensible-enum` (a common extension) to signal openness
- In Avro, set the `default` property on every enum to the sentinel symbol so that readers with an older schema can resolve new variants
- In application code, always include a `default` / `_` / `else` branch in every `switch` or `match` on an enum; log the unrecognised value and either use the sentinel behaviour or propagate the raw value
- Treat a missing `default` case on an enum switch as a bug - it is a forward-compatibility hazard
- In GraphQL, document enum types as potentially extensible and instruct clients to handle unknown values gracefully

## Sources

- Google. "Protocol Buffers Language Guide - Enumerations." https://protobuf.dev/programming-guides/proto3/#enum (accessed 2026-03-22.)
- Apache Software Foundation. "Avro Specification 1.11.1 - Enums." https://avro.apache.org/docs/1.11.1/specification/#enums (accessed 2026-03-22.)
- Kleppmann, Martin. *Designing Data-Intensive Applications.* O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 4: "Encoding and Evolution."
