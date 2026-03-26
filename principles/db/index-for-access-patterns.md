# DB-INDEX-FOR-ACCESS-PATTERNS — Index for access patterns — design indexes from the queries, not the schema

**Layer:** 2
**Categories:** database, performance, query-optimization
**Applies-to:** all
**Summary:** Create indexes based on specific measured query access patterns, not schema shape or general intuition.

## Principle

Design indexes based on the specific queries the application runs, not on the shape of the schema or a general intuition that "foreign keys should be indexed." For each high-traffic or latency-sensitive query, identify the predicate columns, the sort order, and the projected columns, then create an index that serves that exact access pattern. An index that does not match any query plan is dead weight.

## Why it matters

Missing indexes cause full table scans that scale with data size — a query that runs in milliseconds on 10,000 rows may take seconds on 10 million. Conversely, excess indexes slow every write, consume storage, and confuse the query planner. The right indexes are those derived from measured query plans, not from schema aesthetics.

## Violations to detect

- Foreign key columns with no corresponding index, causing full scans on JOIN operations
- Queries whose `EXPLAIN` output shows `Seq Scan` or `Full Table Scan` on large tables
- Indexes on columns that appear only in SELECT projections and never in WHERE, JOIN, or ORDER BY clauses
- Composite indexes whose column order does not match the query predicate order (leading column not in the WHERE clause)
- Indexes created but never appearing in any query plan (identifiable via `pg_stat_user_indexes.idx_scan = 0`)

## Good practice

- For every slow or high-frequency query, run `EXPLAIN ANALYZE` (Postgres) or `EXPLAIN FORMAT=JSON` (MySQL) and check the access path before adding an index
- Use covering indexes (include all projected columns) for the highest-frequency read paths to avoid the extra heap fetch
- Review unused indexes monthly in production using `pg_stat_user_indexes` or equivalent; drop indexes with zero or near-zero scan counts
- Create indexes on the write side of the workload only after confirming the read benefit outweighs the write cost

## Sources

- Kleppmann, Martin. *Designing Data-Intensive Applications*. O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 3: "Storage and Retrieval."
- Winand, Markus. *SQL Performance Explained*. Winand, 2012. ISBN 978-3-950-30461-4. https://use-the-index-luke.com/
