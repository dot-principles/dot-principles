# EIP-RETURN-ADDRESS - Return Address

**Layer:** 2 (contextual)
**Categories:** integration, messaging
**Applies-to:** all
**Summary:** Include a Return Address in every request message so responders can route replies to the correct channel.

## Principle

In an asynchronous request-reply exchange, the requester includes a Return Address in the request message that tells the responder where to send its reply. The Return Address is the address of the channel or queue on which the requester is listening. The responder reads the Return Address from the request and uses it to route the reply, rather than relying on a hardcoded or globally shared reply channel. This allows a single responder to serve multiple concurrent requesters each listening on their own reply channel.

## Why it matters

When the reply channel is hardcoded in the responder, a single reply destination must serve all callers, which means concurrent requesters receive each other's replies. Alternatively, the responder must carry out-of-band knowledge of who is calling and how to reach them. The Return Address makes the routing of replies a responsibility of the requester, not the responder: each requester declares its own reply address in the request, and the responder remains decoupled from the caller's identity and location.

## Violations to detect

- Asynchronous request-reply implementations where the responder uses a hardcoded reply queue name rather than reading the reply address from the incoming message
- Request messages with no reply-to field, header, or metadata - the responder has no way to dynamically address the reply without prior knowledge of the caller
- A single shared reply queue consumed by all callers, requiring each consumer to inspect every reply and discard those addressed to other callers
- Temporary reply queues that are not created per request (or per session) - persistent shared reply queues accumulate stale undelivered replies

## Good practice

- Include a reply-to address in every request message: a temporary queue name, a named durable queue, a callback URL, or a topic with a caller-specific subscription
- Use framework support for temporary reply queues: JMS `TemporaryQueue`, AMQP exclusive queues, or AWS SQS temporary queue patterns
- Pair the Return Address with a Correlation Identifier so that the requester can match a reply to the specific request that generated it when multiple requests are in flight simultaneously
- Destroy temporary reply queues after the reply is consumed to avoid resource leaks

## Sources

- Hohpe, Gregor & Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0321200686. Pattern: "Return Address."
- Hohpe, Gregor & Woolf, Bobby. "Return Address." https://www.enterpriseintegrationpatterns.com/patterns/messaging/ReturnAddress.html (accessed 2026-03-22).
