# CODE-CS-CQS - CQS: Command-Query Separation

**Layer:** 1 (universal)
**Categories:** software-design, maintainability, predictability
**Applies-to:** all
**Summary:** Every method must be either a command or a query, never both.

## Principle

Every method should be either a **command** (changes state, returns nothing) or a **query** (returns a value, causes no side effects) - never both. A caller should be able to call a query any number of times without changing system state, and should be able to issue a command without needing to inspect a return value to know whether it succeeded.

## Why it matters

Methods that both mutate state and return a value are harder to reason about, harder to test, and harder to compose. Callers cannot safely call them multiple times (idempotency breaks), cannot cache their results, and must handle two concerns at once. Mixing commands and queries also makes code harder to read: a function named `getUser()` that also logs an audit event violates the reader's expectation that reads are safe.

## Violations to detect

- A method that returns a value and also modifies state (e.g. `pop()` style methods outside of data structures where it is a deliberate design choice)
- Getters or query methods with observable side effects (logging, incrementing counters, writing to a database)
- Functions named as queries (`get`, `find`, `check`, `is`) that also mutate
- Repository or service methods that return the saved entity and also send a notification or emit an event in the same call

## Inspection

- `grep -rnE '(get|find|fetch|is|has|check)[A-Za-z]*\(.*\{' --include="*.java" --include="*.ts" --include="*.js" --include="*.cs" $TARGET | grep -iE '\.(save|update|delete|remove|send|write|insert|set)\('` | MEDIUM | Query-named methods that also mutate state

## Good practice

- If a method must both return a value and have a side effect, split it: one command method, one query method; call the command, then query separately
- Accept deliberate exceptions - `Stack.pop()`, iterator advancement, test framework assertions - but make them explicit and document the departure
- In event-sourced or CQRS architectures, CQS scales up: separate entire read models from write models
- Name commands as imperatives (`save`, `send`, `delete`) and queries as nouns or predicates (`user`, `isActive`, `findById`)

## Sources

- Meyer, Bertrand. *Object-Oriented Software Construction*, 2nd ed. Prentice Hall, 1997. ISBN 978-0-13-629155-8. (original formulation)
- Fowler, Martin. "CommandQuerySeparation." https://martinfowler.com/bliki/CommandQuerySeparation.html
