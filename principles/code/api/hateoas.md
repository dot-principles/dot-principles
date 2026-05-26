# CODE-API-HATEOAS - Make APIs self-descriptive using hypermedia (HATEOAS)

**Layer:** 2
**Categories:** api-design, rest, protocol-design
**Applies-to:** all
**Summary:** Include hypermedia links in every response so clients discover available actions rather than hardcoding URIs.

## Principle

A REST API should drive application state through hypermedia - each response should include links and controls that tell the client what it can do next. The client should not need to hardcode URI structures or out-of-band knowledge to navigate the API. Hypermedia as the engine of application state (HATEOAS) means that the server's responses contain the information clients need to discover and transition between resources.

## Why it matters

When clients hardcode URI templates or rely on documentation to construct URLs, the server cannot evolve its URI structure without breaking those clients. Hypermedia decouples clients from server implementation details: the server can change URIs, add new capabilities, or restructure resources, and well-behaved clients will discover these changes through the links in responses. This is the same principle that makes the web browsable - users do not memorize URLs, they follow links.

## Violations to detect

- Clients that construct URIs by string concatenation or template substitution based on documentation rather than following links from responses
- API responses that return only data with no navigational links or action controls
- Tight coupling between client routing logic and server URL structure
- API documentation that lists all endpoints as a flat table of URL patterns with no mention of how responses link to one another

## Good practice

- Include `_links` or equivalent hypermedia controls in every resource representation, indicating related resources and available actions
- Use established hypermedia formats (HAL, JSON:API, Siren, or Hydra) rather than inventing a custom link structure
- Return links that reflect the current state of the resource - only advertise actions the client is authorized and able to perform
- Start clients from a single well-known entry point URL; all other URIs should be discovered from responses

## Sources

- Fielding, Roy. "Architectural Styles and the Design of Network-based Software Architectures." PhD dissertation, University of California, Irvine, 2000. Chapter 5, Section 5.1.5: "Uniform Interface."
