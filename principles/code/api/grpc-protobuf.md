# CODE-API-GRPC-PROTOBUF — Define gRPC service contracts in .proto files; evolve them without breaking existing clients

**Layer:** 2
**Categories:** api-design, protocol-design, backward-compatibility
**Applies-to:** all
**Summary:** Define gRPC contracts in `.proto` files and never reuse a field number after it has been retired.

## Principle

gRPC service contracts must be defined in `.proto` files and treated as the authoritative API contract — not generated code. Field numbers in Protobuf messages are permanent identifiers; once assigned and published, a field number must never be reused for a different field. Use `reserved` to retire fields and field numbers. Prefer unary RPCs for request-response interactions and server-streaming for high-throughput or push flows. Follow semantic versioning for `.proto` package names when introducing breaking changes.

## Why it matters

Protobuf's binary encoding relies on field numbers, not field names. Reusing a field number for a different field corrupts messages for clients that have not updated, silently producing wrong data rather than an error. Unlike JSON APIs where breaking changes are immediately visible, Protobuf incompatibilities can go undetected until a stale client encounters a reused field number. The `.proto` file is also the only human-readable contract — if it drifts from the implementation, consumers cannot trust it.

## Violations to detect

- Removing a field from a `.proto` message without adding its number and name to a `reserved` statement
- Reusing a field number for a new field after a previous field at that number was deleted
- Changing the type of an existing field (e.g., `string` to `int32`, `optional` to `repeated`)
- Renaming an RPC method or message type in a way that breaks generated client code without a package version bump
- `.proto` files that have drifted from the running implementation (fields present in code but absent from the schema, or vice versa)

## Inspection

- `grep -rn "reserved\b" $TARGET --include="*.proto" -l` | LOW | Proto files using reserved statements (absence may indicate deleted fields were not properly retired)
- `grep -rn "^\s*\(string\|int32\|int64\|bool\|bytes\|repeated\|optional\|message\|enum\)\s" $TARGET --include="*.proto" | grep -v "reserved"` | LOW | Active field definitions in proto files (review for reused or missing field numbers)

## Good practice

- Treat the `.proto` file as the source of truth — generate server stubs and client SDKs from it, never the reverse
- Reserve deleted field numbers and names immediately: `reserved 3, 5; reserved "old_field_name";`
- Never change the type or cardinality of an existing field; add a new field with a new number instead
- Use package versioning for breaking changes: `package myservice.v1;` → `package myservice.v2;`
- Prefer `optional` fields for new additions so old clients can ignore them gracefully
- Use server-streaming RPCs (`rpc ListOrders(ListRequest) returns (stream Order)`) for large result sets instead of pagination hacks over unary calls
- Run a proto linter (e.g., `buf lint`) and breaking-change detector (`buf breaking`) in CI

## Sources

- Google. *Protocol Buffers Language Guide (proto3).* https://protobuf.dev/programming-guides/proto3/
- Google. *API Design Guide — gRPC.* https://cloud.google.com/apis/design
- Indrasiri, Kasun; Kuruppu, Danesh. *gRPC: Up and Running*. O'Reilly, 2020. ISBN 978-1-492-05833-5.
