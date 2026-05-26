# CODE-AR-PIPES-AND-FILTERS - Apply the Pipes and Filters pattern for composable processing

**Layer:** 2 (contextual)
**Categories:** architecture, integration
**Applies-to:** all
**Summary:** Decompose complex processing into independent single-responsibility filter stages connected by message channels.

## Principle

Decompose complex processing into a sequence of independent, self-contained filter stages connected by message channels (pipes). Each filter performs a single transformation, reads from an input channel, and writes to an output channel. Because filters are decoupled from one another and communicate only through the pipe, they can be reordered, replaced, or parallelized without affecting the rest of the pipeline.

## Why it matters

Monolithic processing logic is difficult to test, reuse, and scale. The Pipes and Filters pattern enforces separation of concerns at the integration level - each stage has a single responsibility and can be developed, tested, and deployed independently. When load increases on one stage, only that stage needs to be scaled. When requirements change, individual filters can be swapped without rewriting the entire flow.

## Violations to detect

- A single monolithic function or class that performs multiple sequential transformations on a message or data set
- Processing steps that are tightly coupled through shared mutable state rather than communicating via well-defined messages
- Hard-coded processing sequences where adding or removing a step requires modifying a central orchestrator
- Direct method calls between processing stages that prevent independent deployment or scaling

## Good practice

- Design each filter to be stateless and to operate only on its input message, producing an output message
- Connect filters using message channels so that the transport mechanism (in-memory queue, message broker, stream) can be changed without modifying filter logic
- Keep filter interfaces uniform - a common message format or envelope simplifies composition
- Use the pattern to build processing pipelines that can be extended by adding new filters without changing existing ones

## Sources

- Hohpe, Gregor; Woolf, Bobby. *Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions*. Addison-Wesley, 2003. ISBN 978-0-321-20068-6. Chapter 3: "Pipes and Filters."
