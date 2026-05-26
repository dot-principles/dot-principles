# CODE-AR-MESSAGE-BROKER - Use a message broker to decouple producers from consumers

**Layer:** 2 (contextual)
**Categories:** architecture, integration, distributed-systems
**Applies-to:** all
**Summary:** Route all inter-service messages through a central broker to decouple producers from consumers.

## Principle

Route messages through a centralized message broker rather than having producers send directly to consumers. The broker acts as an intermediary that receives messages from producers, handles routing, and delivers them to the appropriate consumers. This means producers and consumers do not need to know about each other's identity, location, or even existence, achieving full location and identity decoupling.

## Why it matters

Point-to-point connections between services create an O(n²) wiring problem as the number of services grows. Each new service must know the addresses and protocols of all the services it talks to. A message broker centralizes routing, enables publish-subscribe patterns, and allows new consumers to be added without modifying producers. It also provides capabilities like message persistence, delivery guarantees, and load balancing across competing consumers.

## Violations to detect

- Services that maintain hard-coded lists of downstream service endpoints for event distribution
- Producers that fan out messages to multiple consumers by making individual HTTP calls to each one
- Point-to-point integrations where adding a new consumer requires changes to the producer's code or configuration
- Event notification systems built on shared databases or polling rather than brokered messaging

## Good practice

- Use a message broker (e.g., RabbitMQ, Apache Kafka, Amazon SNS/SQS) to mediate communication between producers and consumers
- Leverage publish-subscribe topics when multiple consumers need to react to the same event independently
- Use competing consumers (multiple instances reading from the same queue) to scale processing horizontally
- Design for broker unavailability - implement local buffering or outbox patterns so producers are not blocked when the broker is temporarily unreachable

## Sources

- Hohpe, Gregor; Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0-321-20068-6. Chapter 7: "Message Routing."
