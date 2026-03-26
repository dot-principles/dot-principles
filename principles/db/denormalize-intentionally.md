# DB-DENORMALIZE-INTENTIONALLY — Denormalise intentionally — introduce redundancy only with a measured justification and explicit consistency enforcement

**Layer:** 2
**Categories:** database, performance, data-modeling, maintainability
**Applies-to:** all
**Summary:** Denormalise only when a measured performance problem justifies it and the redundancy is explicitly managed.

## Principle

Normalisation is the default; denormalisation is a deliberate trade-off made to solve a specific, measured performance problem. When a normalised query is provably too slow for its access frequency and optimising indexes, query structure, or caching is insufficient, introduce controlled redundancy: duplicate a column or pre-aggregate a value, document the decision, identify the canonical source, and implement a tested mechanism to keep the denormalised copy consistent with it.

## Why it matters

Unplanned denormalisation — adding a column "for convenience" or "because joins are slow" without evidence — produces the worst of both worlds: the schema acquires redundancy without the performance benefit, the redundancy is never consistently maintained, and the data silently diverges. Bugs in denormalised data are among the most expensive to diagnose: the schema appears correct, the application logic is valid, but the stored values disagree.

## Violations to detect

- Denormalised columns (e.g. `order_total`, `item_count`) that are updated by some code paths but not others, causing the stored value to drift from the computed value
- No documented canonical source for a denormalised value — the team disagrees about which table is authoritative
- Denormalisation introduced as an upfront schema decision before measuring whether the normalised query is actually slow
- Materialised or pre-computed columns with no test that validates them against the source data

## Good practice

- Profile the normalised query in production with representative data volumes before introducing denormalisation; an index may solve the problem without redundancy
- Name the canonical source explicitly in schema comments or an ADR: `-- denormalised from order_lines.unit_price * quantity; updated by OrderService.recalculateTotals()`
- Use database-level mechanisms where possible: generated columns, materialised views, or triggers that keep the denormalised value synchronised automatically
- Add a data-quality check (scheduled query or CI test) that compares the denormalised value against a fresh computation and alerts on drift

## Sources

- Fowler, Martin. *Patterns of Enterprise Application Architecture*. Addison-Wesley, 2002. ISBN 978-0-321-12742-6. "Query Object" and related data source patterns.
- Date, C.J. *An Introduction to Database Systems*, 8th ed. Pearson, 2003. ISBN 978-0-321-19784-9. Chapter 12: "Further Normalization II: Higher Normal Forms."
- Kleppmann, Martin. *Designing Data-Intensive Applications*. O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 2: "Data Models and Query Languages."
