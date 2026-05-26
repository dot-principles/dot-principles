# CODE-API-RESOURCE-NOUNS - Design resources around nouns, not verbs

**Layer:** 2
**Categories:** api-design, rest, protocol-design
**Applies-to:** all
**Summary:** Identify resources with noun URIs and let HTTP methods express the action, never verbs in the path.

## Principle

REST APIs expose resources - entities and collections that are identified by URIs. Resource URIs should be nouns representing the things in your domain (`/orders`, `/users/42`, `/invoices/2024-001/line-items`), not verbs representing actions (`/getUser`, `/createOrder`). The HTTP method supplies the verb; the URI identifies the resource being acted upon. This separation is central to the uniform interface constraint.

## Why it matters

When URIs contain verbs, the API drifts toward an RPC style where every operation gets its own endpoint, leading to an explosion of endpoints that are difficult to discover, cache, and document. Noun-based resources naturally map to CRUD operations through HTTP methods, resulting in a smaller, more consistent API surface. Caches and intermediaries work correctly because the resource identity is stable and the method communicates the action.

## Violations to detect

- URIs containing action verbs: `/getUser`, `/createOrder`, `/deleteItem`, `/updateProfile`
- Endpoints that duplicate the HTTP method in the path: `POST /api/createUser` instead of `POST /api/users`
- Inconsistent resource naming - mixing plural and singular forms (`/user/42` vs. `/orders`)
- Deeply nested verbs-as-resources: `/api/orders/42/cancel` where a state-transition resource like `POST /api/orders/42/cancellation` would be more RESTful

## Good practice

- Use plural nouns for collection resources (`/orders`, `/users`, `/products`)
- Use the resource identifier for individual resources (`/orders/42`, `/users/jane`)
- Let HTTP methods express the action: `GET /orders` (list), `POST /orders` (create), `GET /orders/42` (retrieve), `PUT /orders/42` (replace), `DELETE /orders/42` (remove)
- For operations that do not map cleanly to CRUD, model the action as a subordinate resource (e.g., `POST /orders/42/shipments` to ship an order, rather than `POST /shipOrder`)

## Sources

- Fielding, Roy. "Architectural Styles and the Design of Network-based Software Architectures." PhD dissertation, University of California, Irvine, 2000. Chapter 5.
- Richardson, Leonard; Ruby, Sam. *RESTful Web Services*. O'Reilly, 2007. ISBN 978-0-596-52926-0.
