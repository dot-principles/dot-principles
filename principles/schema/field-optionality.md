# SCHEMA-FIELD-OPTIONALITY - New fields must be optional; never add required fields to published schemas

**Layer:** 1 (universal)
**Categories:** schema-design, api-design, reliability
**Applies-to:** schema
**Summary:** Every new schema field must be optional with a sensible default; never add required fields to published schemas.

## Principle

Every new field added to a published schema must be optional and carry a sensible default value. Adding a required field to a schema that already has consumers is a breaking change - existing producers will generate messages or documents that fail validation, and existing consumers will reject or crash on data that lacks the new field. The only safe way to evolve a published schema is through additive, optional changes.

## Why it matters

In a distributed system, producers and consumers are upgraded independently. When a new required field is added to a shared schema, every producer must be updated before any consumer running the new schema version can accept messages. This creates a deployment-order dependency that defeats independent deployability. In practice, the requirement is discovered when the first consumer rejects a valid message because it lacks a field that did not exist when the message was produced. The result is a production outage caused entirely by a schema change, not a code bug. Optional fields with defaults avoid this: old producers omit the field, new consumers use the default, and the system continues to function during the rolling upgrade window.

## Violations to detect

- A `required` annotation on a field that was not present in the schema's initial published version
- Protobuf fields without `optional` keyword in proto3 that are expected to carry meaning distinct from the zero value
- OpenAPI `required` array including a field that did not exist in the previous published version of the schema
- Avro record fields without a `default` value - Avro treats fields without defaults as required for schema resolution
- JSON Schema `required` list containing newly added properties
- GraphQL non-null (`!`) fields added to existing types after the schema is already consumed by clients

## Inspection

- `grep -rnE '"required"\s*:\s*\[' --include="*.json" --include="*.yaml" --include="*.yml" $TARGET` | MEDIUM | JSON Schema / OpenAPI required array - verify no new fields were added to published schemas
- `grep -rnE '^\s+\w+\s+\w+\s*=\s*\d+\s*;' --include="*.proto" $TARGET` | INFO | Protobuf field - verify optionality and default semantics are intentional

## Good practice

- Make every new field optional with an explicit default value that preserves the existing behaviour when the field is absent
- In Protobuf (proto3), document the semantic meaning of the zero value for every field - it is the implicit default and must be a safe value
- In Avro, always specify a `default` for every field; without one, schema resolution between writer and reader will fail
- In OpenAPI, do not add new property names to the `required` array of an existing schema after it has been published
- In GraphQL, add new fields as nullable; non-null (`!`) can only be safely used on fields present since the type's first publication
- Enforce schema compatibility checks in CI - use a schema registry (Confluent, Apicurio) or a diff tool that flags new required fields as breaking

## Sources

- Google. "Protocol Buffers Language Guide (proto3) - Updating A Message Type." https://protobuf.dev/programming-guides/proto3/#updating (accessed 2026-03-22.)
- Apache Software Foundation. "Avro Specification 1.11.1 - Schema Resolution." https://avro.apache.org/docs/1.11.1/specification/#schema-resolution (accessed 2026-03-22.)
- Kleppmann, Martin. *Designing Data-Intensive Applications.* O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 4: "Encoding and Evolution."
