# SEC-ARCH-LEAST-COMMON-MECHANISM — Minimize shared mechanisms between users and components

**Layer:** 2 (contextual)
**Categories:** security, architecture, isolation
**Applies-to:** all
**Summary:** Minimize shared credentials, caches, and mechanisms between users or components at different trust levels.

## Principle

Minimize the amount of mechanism shared between users, tenants, or components that operate at different trust levels. Shared service accounts, global singletons for authentication state, common file systems, and pooled processes create covert channels and blast-radius amplifiers — a compromise in one consumer propagates through the shared mechanism to all others.

## Why it matters

Every shared mechanism is a potential lateral movement path. A shared database connection pool means a SQL injection in one tenant's query can read another tenant's data. A shared service account means revoking access for one consumer revokes it for all. A global authentication cache means a cache poisoning attack grants access to every consumer that reads from it. The less mechanism is shared, the smaller the blast radius of any individual compromise. This principle is the security foundation of multi-tenancy isolation, microservice decomposition, and the separation of control planes from data planes.

## Violations to detect

- A single service account or set of credentials shared across multiple applications or environments that operate at different trust levels
- A shared in-memory authentication or session cache accessible to multiple tenants or services without isolation
- Multiple services writing to or reading from the same database schema without schema-level or row-level tenant isolation
- A shared file system or storage bucket used by services at different trust levels without access-control boundaries
- A single logging pipeline that commingles data from different tenants or security zones, enabling cross-tenant data leakage
- Global singletons or static variables holding security state (tokens, permissions, identity context) in multi-tenant applications

## Inspection

- `grep -rnE '(static|global|shared).*(token|session|credential|auth|secret)' --include="*.java" --include="*.py" --include="*.ts" --include="*.go" --include="*.cs" $TARGET` | MEDIUM | Potential shared security state in global/static variable

## Good practice

- Assign distinct credentials to each service, environment, and tenant; never share service accounts across trust boundaries
- Isolate tenant data at the database level — separate schemas, separate databases, or enforced row-level security policies
- Use per-request or per-tenant security context objects rather than global singletons for authentication state
- Separate control plane and data plane communication channels so that management traffic cannot be observed or influenced by workload traffic
- Ensure logging pipelines enforce tenant-level isolation — a tenant's logs must not be visible to other tenants
- In multi-tenant systems, use separate encryption keys per tenant so that a key compromise affects only one tenant

## Sources

- Saltzer, J.H. and Schroeder, M.D. "The Protection of Information in Computer Systems." *Proceedings of the IEEE*, 63(9), 1975. DOI 10.1109/PROC.1975.9939. (Principle of Least Common Mechanism.)
- NIST. *Special Publication 800-53 Rev 5: Security and Privacy Controls for Information Systems and Organizations.* 2020. https://doi.org/10.6028/NIST.SP.800-53r5 (SC-4: Information in Shared System Resources.)
