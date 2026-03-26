# ARCH-DATABASE-PER-SERVICE — Each service owns its data store; no cross-service database sharing

**Layer:** 2 (contextual)
**Categories:** architecture, microservices, data-management, service-boundaries
**Applies-to:** all
**Summary:** Each microservice must own its data exclusively; no other service may bypass its API to access its database.

## Principle

Each microservice owns its data exclusively. No other service may directly read from or write to that service's database, table, or schema. Data belonging to another service is accessed only through its public API. Shared databases — where multiple services connect to the same instance and access overlapping tables — create tight coupling that prevents independent deployment and defeats service boundaries.

## Why it matters

A shared database is a hidden synchronous coupling point. Any schema change — adding a column, renaming a table, changing a constraint — becomes a cross-team coordination event that requires all consumers to deploy simultaneously. It also prevents services from choosing the right storage technology for their workload (relational, document, time-series), and makes it impossible to scale one service's storage tier independently. Violations also tend to accumulate: once a service reads another's tables directly, the boundary erodes progressively.

## Violations to detect

- Multiple services sharing the same database connection string or database name in configuration
- Service A querying a table owned by service B via a direct SQL join or SELECT
- A shared schema or database with table names prefixed by different service names (sign of logical sharing that became physical)
- Cross-service transactions using a shared database connection rather than the Saga pattern
- A service's ORM entity classes referencing tables in a schema owned by another service
- Database migrations in one service modifying tables that another service reads or writes

## Inspection

- `grep -rnE 'DB_URL|DATABASE_URL|JDBC_URL|SPRING_DATASOURCE' --include="*.env" --include="*.env.example" --include="*.properties" --include="*.yaml" --include="*.yml" $TARGET` | INFO | Locate database connection strings — verify each service has a distinct database name
- `grep -rnE 'from\s+[a-z_]+\.(orders|users|payments|inventory|catalog)\b' -i --include="*.sql" --include="*.py" --include="*.java" $TARGET` | HIGH | Cross-schema SQL reference — potential cross-service table access
- `grep -rnE 'import.*Repository|@Repository' --include="*.java" --include="*.kt" $TARGET` | INFO | Repository imports — verify they reference this service's entities only

## Good practice

```
# Bad: order-service reads the inventory database directly
SELECT * FROM inventory_db.products WHERE id = ?

# Good: order-service calls the inventory API
GET /api/inventory/products/{id}

# Good: each service has its own schema even on shared infrastructure
order-service   → order_db (or order schema)
inventory-service → inventory_db (or inventory schema)
```

- Enforce the boundary at the network level: grant each service a dedicated database user with access only to its own schema
- Use event-driven integration (domain events, CDC) to propagate data changes across service boundaries asynchronously rather than shared reads
- Accept data duplication — a service may materialise a read-optimised copy of another service's data via events; this is intentional and desirable
- For reporting that requires cross-service data, use a dedicated read model or data warehouse populated from events rather than joining operational databases
- The Saga pattern (choreography or orchestration) handles distributed transactions without requiring a shared ACID database

## Sources

- Richardson, Chris. *Microservices Patterns*. Manning, 2018. ISBN 978-1617294549. Chapter 2: "Decomposition strategies." Chapter 3: "Interprocess communication."
- Newman, Sam. *Building Microservices*, 2nd ed. O'Reilly, 2021. ISBN 978-1492034025. Chapter 4: "Decomposing the Monolith."
