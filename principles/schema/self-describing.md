# SCHEMA-SELF-DESCRIBING — Make schemas self-describing

**Layer:** 1 (universal)
**Categories:** documentation, api-design
**Applies-to:** schema
**Summary:** Every field, enum value, and method must be described clearly enough to understand without external documentation.

## Principle

Every field, type, enum value, and RPC method in a schema should carry enough description, naming clarity, and structural context that a consumer can understand its purpose without consulting external documentation. Descriptions, comments, and naming conventions are part of the schema's public contract — not optional annotations to be added later.

## Why it matters

Schemas are consumed by developers who did not write them, often months or years after they were created. A schema without descriptions forces every consumer to reverse-engineer intent from field names alone. Poorly named or undescribed schemas lead to misuse, integration bugs, and repeated consultations with the original author. A self-describing schema reduces onboarding time and the cost of integration.

## Violations to detect

- Fields named `data`, `value`, `info`, `obj`, `result`, or other generic names without descriptions
- Enum values with no indication of what each variant means (e.g., `STATUS_1`, `STATUS_2`)
- Protobuf fields with no comment blocks explaining units, constraints, or expected format
- OpenAPI schema properties with no `description` field
- SQL columns with abbreviations that require tribal knowledge to decode (`acct_nbr_cd`, `usr_flg_tp`)
- RPC method names that are verbs without object context (`Process`, `Handle`, `Execute`)

## Good practice

- Every field in a public schema must have a description explaining what it represents, its units (if numeric), and any constraints
- Enum variants should have names that read as domain concepts, not codes: `ORDER_STATUS_PENDING` not `STATUS_1`
- Use consistent naming conventions throughout a schema — mixing camelCase and snake_case in the same schema signals lack of ownership
- Include examples in OpenAPI schemas (`example:` property) to make the format concrete
- In Protobuf, use field comments to document backward-compatibility constraints: "Do not reuse field number 3"
- Schema descriptions are documentation — apply the same review discipline as prose docs

## Sources

- Google. "API Design Guide — Naming Conventions." https://cloud.google.com/apis/design/naming_convention (accessed 2026-03-18).
- OpenAPI Initiative. "OpenAPI Specification 3.1.0." https://spec.openapis.org/oas/v3.1.0 (accessed 2026-03-18). Section on `description` fields.
