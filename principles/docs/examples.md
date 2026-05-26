# DOC-EXAMPLES - Illustrate with concrete, runnable examples

**Layer:** 2 (contextual)
**Categories:** documentation, usability
**Applies-to:** docs
**Summary:** Accompany every abstract description with a concrete, runnable example that readers can try immediately.

## Principle

Abstract descriptions of behavior should be accompanied by concrete examples that a reader can try immediately. Examples are not supplementary - for many readers, the example is the primary content and the prose is the supplement. A working example communicates intent, valid inputs, expected outputs, and edge cases simultaneously, often more efficiently than paragraphs of prose.

Examples must be accurate, runnable (or clearly illustrative), and representative of the common case. Do not illustrate only edge cases; show the 80% use case first.

## Why it matters

Abstract descriptions leave readers uncertain whether they have understood correctly. A reader who must mentally simulate a system from prose alone is doing extra work that a good example would eliminate. Runnable examples also serve as executable documentation: they can be tested in CI, ensuring they stay accurate as the system evolves.

## Violations to detect

- API reference documentation that lists parameters with no example request/response pair
- A tutorial that describes configuration options in prose without showing a minimal working configuration file
- Code examples that use placeholder names like `foo`, `bar`, `data`, or `thing` that obscure the actual usage pattern
- Examples that demonstrate only error handling or edge cases, never the happy path
- Examples that require significant pre-existing knowledge to adapt to the reader's context
- Documentation that says "see the source code for examples" as a substitute for written examples

## Good practice

- Lead with the simplest possible working example before presenting variations or options
- Use realistic values in examples (real-looking URLs, plausible field names, actual command output)
- Show both input and output for any transformation or command
- Keep examples short: strip everything that does not contribute to illustrating the principle
- Test examples in CI where possible; at minimum, manually verify them before publishing
- For APIs, provide a complete, copy-pasteable example that works without modification in a standard environment

## Sources

- Procida, Daniele. "Diátaxis - A systematic approach to technical documentation authoring." https://diataxis.fr (accessed 2026-03-18).
- Write the Docs community. "Style Guides." https://www.writethedocs.org/guide/ (accessed 2026-03-18).
