# DB-THIRD-NORMAL-FORM — Normalise to third normal form by default — eliminate redundancy before introducing it

**Layer:** 2
**Categories:** database, data-modeling, correctness, maintainability
**Applies-to:** all
**Summary:** Design relational schemas to at least Third Normal Form by default; denormalise only when justified by measurement.

## Principle

Design relational schemas in at least Third Normal Form (3NF) by default: every non-key attribute must depend on the whole primary key (2NF) and on nothing but the key (3NF). This eliminates update anomalies, insertion anomalies, and deletion anomalies caused by data redundancy. Denormalise only when a specific, measured read-performance requirement justifies it and the redundancy is explicitly managed.

## Why it matters

Unnormalised schemas store the same fact in multiple places. When that fact changes, every copy must be updated atomically — a discipline that applications routinely violate, producing inconsistent data that is expensive to clean up and impossible to trust. A 3NF schema stores each fact once; updating it is a single write with no risk of partial inconsistency.

## Violations to detect

- Columns that repeat the same value across rows because they depend on a partial key or on another non-key column (e.g. storing `customer_name` and `customer_email` on every order row instead of referencing a `customers` table)
- Tables with no primary key or with a composite primary key where some non-key columns depend only on part of the key
- Denormalised summary columns (e.g. `order_total`) that are updated by application code rather than computed from source rows — likely to drift out of sync
- Redundant columns that store derived data (e.g. `full_name` alongside `first_name` and `last_name`) with no enforcement of consistency

## Good practice

- Start every schema design with a 3NF analysis; identify functional dependencies and eliminate transitive ones
- Represent each real-world entity (customer, product, order) as its own table with a stable primary key
- Use foreign keys to express relationships rather than duplicating data across tables
- When denormalising for read performance, document the trade-off explicitly, maintain the canonical source of truth, and update the denormalised copy through a well-tested code path or database trigger

## Sources

- Codd, E.F. "A Relational Model of Data for Large Shared Data Banks." *Communications of the ACM*, vol. 13, no. 6, 1970. DOI 10.1145/362384.362685.
- Date, C.J. *An Introduction to Database Systems*, 8th ed. Pearson, 2003. ISBN 978-0-321-19784-9. Chapter 11: "Further Normalization I: 1NF, 2NF, 3NF, BCNF."
