# ARCH-CONWAYS-LAW - Conway's Law

**Layer:** 2 (contextual)
**Categories:** architecture, org-design, systems-thinking
**Applies-to:** system-design, team-structure
**Summary:** Align team structure with desired system architecture; design teams to produce the communication boundaries you want.
**Audit-scope:** excluded - violations require knowing team and org structure, which is external to the codebase

## Principle

Any organisation that designs a system will produce a design whose structure is a copy of the organisation's communication structure. Team boundaries become service boundaries; reporting lines become API contracts; silos become integration friction. This is not a failure of engineering - it is a structural force. Ignoring it produces systems whose architectures are in constant tension with the teams that maintain them.

The **Inverse Conway Manoeuvre**: deliberately shape team structure to produce the system architecture you want, rather than letting org structure dictate design by default.

## Why it matters

System boundaries that don't align with team ownership create coordination overhead, unclear accountability, and API surfaces that grow to accommodate political rather than technical requirements. Teams that must coordinate frequently across a boundary will eventually merge the systems or suffer the cost of that coordination indefinitely. Architecture decisions made without regard to org structure will be undone by org structure over time.

## Violations to detect

- Microservice boundaries that cut across a single team's domain, requiring constant cross-service coordination for routine features
- A shared service owned by no clear team, modified by many, with no single accountable maintainer
- System architecture diagrams that match the org chart exactly - a sign the architecture was inherited rather than designed
- Integration layers that exist to bridge two teams' systems rather than two technical domains

## Good practice

- When designing system boundaries, ask: which team will own this? Does ownership align with the communication patterns this architecture requires?
- Use the Inverse Conway Manoeuvre: if you want loosely coupled services, form loosely coupled teams with clear ownership first
- Treat frequent cross-team coordination on a shared component as a signal that the boundary is wrong
- Recognise that reorganisations change effective system architecture - plan for it

## Sources

- Conway, Melvin E. "How Do Committees Invent?" *Datamation*, April 1968.
- Newman, Sam. *Building Microservices*, 2nd ed. O'Reilly, 2021. ISBN 978-1-492-03402-9. Chapter 15.
- Skelton, Matthew; Pais, Manuel. *Team Topologies*. IT Revolution, 2019. ISBN 978-1-942788-81-4.
