# DB-AVOID-N-PLUS-ONE — Avoid N+1 queries — never issue a query per row of a result set

**Layer:** 2
**Categories:** database, performance, query-optimization
**Applies-to:** all
**Summary:** Never issue a separate query per row; replace N+1 patterns with joins, batch loads, or eager loading.

## Principle

Never issue a separate database query for each row returned by an initial query. The N+1 pattern — one query to fetch N parent records, then one query per parent to fetch related children — is the most common database performance anti-pattern in application code. Replace it with a single join, a batch load (IN clause), or the ORM's eager-loading facility.

## Why it matters

N+1 queries degrade performance non-linearly: a page displaying 50 orders that each has 5 line items silently issues 51 queries. As the result set grows the query count grows with it, saturating the database connection pool and producing latency that is invisible during development (with a small seed dataset) but severe in production.

## Violations to detect

- A query inside a loop that iterates over a result set from a prior query (e.g. `for order in orders: db.query("SELECT * FROM line_items WHERE order_id = ?", order.id)`)
- ORM usage that accesses a lazy-loaded relationship inside a loop without configuring eager loading (e.g. accessing `order.line_items` for every `order` in a list)
- Log output showing the same parameterised query repeated N times with different IDs during a single request
- `SELECT *` on a parent table followed by child table lookups with individual foreign-key predicates

## Inspection

```
# Queries inside loops — potential N+1 (language-agnostic heuristic)
# Look for database call patterns inside for/foreach/while blocks
grep -rn "for\s\|foreach\s\|\.forEach\|while\s" --include="*.py" --include="*.java" --include="*.ts" --include="*.rb" .
```

## Good practice

- Use JOIN queries or subqueries to fetch parent and child data in a single round trip
- In ORMs, configure eager loading for relationships that are always needed in a given context (e.g. `include`, `joinedload`, `fetch = EAGER`)
- Use batch loading (WHERE id IN (...)) when a join would produce too many duplicate parent columns or when loading across service boundaries
- Enable slow query logging and N+1 detection tooling (e.g. `hibernate.show_sql`, `nplusone` for Django, `Bullet` for Rails) in development and CI

## Sources

- Kleppmann, Martin. *Designing Data-Intensive Applications*. O'Reilly, 2017. ISBN 978-1-449-37332-0. Chapter 2: "Data Models and Query Languages."
- Fowler, Martin. *Patterns of Enterprise Application Architecture*. Addison-Wesley, 2002. ISBN 978-0-321-12742-6. "Lazy Load" and "Unit of Work" patterns.
