# EFFECTIVE-JAVA-WRITE-DOC-COMMENTS — Write Doc Comments for All Exposed API Elements

**Layer:** 2 (contextual)
**Categories:** api-design, developer-experience
**Applies-to:** java
**Summary:** Document every exported API element with a Javadoc comment covering contract, parameters, return value, and exceptions.

## Principle

Document every exported class, interface, constructor, method, and field with a doc comment. The doc comment should describe the contract between the method and its caller: what the method does (not how), its preconditions, postconditions, side effects, thread-safety guarantees, and the meaning of each parameter, the return value, and any exceptions thrown.

## Why it matters

Documentation is the primary way API consumers learn how to use a component correctly. Without it, users must read source code — assuming they have access — or guess. Poor or missing documentation leads to misuse, bugs, and reluctance to adopt otherwise well-designed APIs.

## Violations to detect

- Public or protected classes, methods, or fields without any doc comment
- Doc comments that merely repeat the method name without adding information (e.g., "Gets the name" for `getName()`)
- Missing `@param`, `@return`, or `@throws` tags for public methods
- No documentation of thread-safety properties on classes designed for concurrent use

## Good practice

- Describe *what* the method does and its contract, not *how* it is implemented
- Use `@param` for every parameter, `@return` for non-void methods, and `@throws` for each checked and notable unchecked exception
- Document thread-safety: is the class immutable, thread-safe, or not thread-safe?
- Write the first sentence of each doc comment as a summary — tools use it as the short description

## Sources

- Bloch, Joshua. *Effective Java*, 3rd ed. Addison-Wesley, 2018. ISBN 978-0-13-468599-1. Item 56: "Write doc comments for all exposed API elements."
