# SCHEMA-NO-POLYMORPHIC-BLOBS — Do not use untyped blobs that bypass schema validation

**Layer:** 1 (universal)
**Categories:** schema-design, type-safety, maintainability
**Applies-to:** schema
**Summary:** Never use untyped blobs or Any fields; define an explicit, validated schema for every structured payload.

## Principle

Schema fields must not use untyped, opaque containers — `Any`, `Object`, `bytes`, `JSON` columns, `additionalProperties: true`, or equivalent — to carry structured data that should have its own schema. Every piece of data that crosses a service boundary or is persisted must be described by an explicit schema so that it can be validated, evolved, documented, and understood by every consumer without out-of-band knowledge of its internal structure.

## Why it matters

An untyped blob inside a schema is a hole in the type system. It cannot be validated by schema tools, cannot be evolved with compatibility checks, and cannot be understood by consumers without consulting the producer's source code or documentation. When a field is declared as `google.protobuf.Any`, `additionalProperties: true`, or `type: object` without properties, the schema stops describing the data at that point — every consumer must implement its own parsing, validation, and error handling for the blob's actual contents. This defeats the purpose of having a schema at all. Bugs caused by untyped blobs are discovered at runtime (often in production) because no compile-time or schema-validation-time check can catch them.

## Violations to detect

- `google.protobuf.Any` or `google.protobuf.Struct` used as a field type in Protobuf messages
- `bytes` fields in Protobuf carrying serialized structured data rather than genuinely opaque binary (images, files)
- OpenAPI schemas using `type: object` without `properties` — an unconstrained object
- OpenAPI schemas with `additionalProperties: true` on the top-level request or response body
- JSON Schema using `{}` (empty schema) or `true` as a property schema
- SQL columns of type `JSON`, `JSONB`, `TEXT`, or `BLOB` storing structured domain data without a documented and validated internal schema
- GraphQL `JSON` or `Any` scalar types used to pass structured data

## Inspection

- `grep -rnE 'google\.protobuf\.(Any|Struct|Value)' --include="*.proto" $TARGET` | HIGH | Protobuf Any/Struct/Value bypasses typed schema
- `grep -rnE 'additionalProperties:\s*true' --include="*.yaml" --include="*.yml" --include="*.json" $TARGET` | MEDIUM | OpenAPI additionalProperties: true allows unconstrained fields
- `grep -rnE 'type:\s*object\s*$' --include="*.yaml" --include="*.yml" $TARGET` | MEDIUM | OpenAPI object type without properties — unconstrained schema

## Good practice

- Define explicit message types or schema objects for every structured payload — never use `Any`, `Object`, or `bytes` as a shortcut
- If a field genuinely needs to carry polymorphic data, use a `oneof` (Protobuf), discriminated union (OpenAPI `oneOf` with `discriminator`), or union type (GraphQL, Avro) so the set of valid shapes is enumerated and each shape has its own schema
- For SQL columns that store structured data, define a JSON Schema or application-level validation that is enforced on every write and documented alongside the table definition
- If `additionalProperties` is needed for extensibility, constrain it: `additionalProperties: { type: string }` is better than `additionalProperties: true`
- Treat every use of `Any`/`Struct`/`bytes`-for-structured-data as technical debt that warrants a tracking issue

## Sources

- Google. "Protocol Buffers Language Guide — Any." https://protobuf.dev/programming-guides/proto3/#any (accessed 2026-03-22.)
- Google. "API Design Guide — Common Design Patterns." https://cloud.google.com/apis/design/design_patterns (accessed 2026-03-22.)
- OpenAPI Initiative. "OpenAPI Specification 3.1.0 — Schema Object." https://spec.openapis.org/oas/v3.1.0#schema-object (accessed 2026-03-22.)
