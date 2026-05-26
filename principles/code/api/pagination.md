# CODE-API-PAGINATION - Paginate all collection resources; never return unbounded results

**Layer:** 2
**Categories:** api-design, performance, reliability
**Applies-to:** all
**Summary:** Paginate every collection endpoint with a server-enforced maximum page size; never return unbounded results.

## Principle

Collection endpoints must never return an unbounded number of items in a single response. Implement either cursor-based pagination (a stable `cursor` or `after` token derived from the last item) or offset-based pagination (`page` and `pageSize`), and include navigation links (`next`, `prev`) in the response envelope. Enforce a maximum page size server-side regardless of what the client requests. Prefer cursor-based pagination for large or frequently-updated collections.

## Why it matters

An unbounded collection response becomes a reliability and performance hazard as data grows. A table with millions of rows will eventually cause out-of-memory errors, request timeouts, and database strain - and clients that consume the full result set on every call will break silently as the dataset scales. Cursor-based pagination avoids the "missing row" and "duplicate row" anomalies caused by insertions during offset-based traversal.

## Violations to detect

- Collection endpoints that return a plain array with no pagination metadata or navigation links
- `getAll()`, `findAll()`, or `SELECT *` queries against large tables without a `LIMIT` clause
- A `pageSize` or `limit` parameter accepted by the API but not capped server-side
- No `next` link or cursor in the response, leaving clients with no way to detect incomplete results
- Offset-based pagination on high-write-rate tables without an awareness of potential row instability

## Inspection

- `grep -rn "findAll\|getAll\|listAll\b" $TARGET --include="*.java" --include="*.ts" --include="*.py" --include="*.go" --include="*.cs" -l` | MEDIUM | Methods that may return unbounded collections (verify each has pagination applied)

## Good practice

- Return a consistent envelope: `{ "data": [...], "meta": { "total": 1500, "pageSize": 20 }, "links": { "next": "...", "prev": "..." } }`
- Enforce a hard maximum page size server-side (e.g., clamp to 100 regardless of client request)
- For cursor pagination, make the cursor opaque to clients (base64-encode internal state); never expose raw offsets or IDs as cursors on mutable datasets
- Return `data: []` rather than 404 when a page is valid but contains no results
- Include `total` in offset pagination for UIs that render page counts; omit it in cursor pagination (expensive and misleading on live data)

## Sources

- Richardson, Leonard; Ruby, Sam. *RESTful Web Services*. O'Reilly, 2007. ISBN 978-0-596-52926-0. Chapter 8.
- RFC 5988: "Web Linking." IETF, 2010. https://www.rfc-editor.org/rfc/rfc5988 (Link header for navigation)
