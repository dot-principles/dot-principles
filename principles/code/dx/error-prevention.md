# CODE-DX-ERROR-PREVENTION — Design for error prevention, not just error handling

**Layer:** 2
**Categories:** developer-experience, usability, ux-design
**Applies-to:** all
**Summary:** Design to prevent errors from occurring in the first place, not to recover from them after.

## Principle

Good design prevents errors from occurring in the first place rather than relying on good error messages after the fact. Eliminate error-prone conditions by offering constraints, defaults, confirmations, and undo capabilities. There are two types of errors to prevent: slips (unconscious mistakes from inattention) and mistakes (conscious errors from incorrect mental models). Different prevention strategies apply to each.

## Why it matters

Error messages, no matter how well-written, are a symptom of a design that allowed the error to happen. Every error a user encounters costs time, creates frustration, and risks data loss. Preventing errors is always cheaper than recovering from them — both for the user's experience and for the system's reliability. As Norman argues, when people make errors, it is usually the design's fault, not the user's.

## Violations to detect

- Text input fields where a constrained selector (dropdown, date picker, enum) would prevent invalid values
- Destructive operations (delete, overwrite, deploy to production) with no confirmation step or undo capability
- Forms that allow submission of invalid data and only report errors after a round-trip to the server
- APIs that accept strings where a structured type would prevent malformed input (e.g., accepting any string for a date instead of requiring ISO 8601)
- Configuration that silently accepts invalid values and fails at runtime rather than validating at load time

## Good practice

- Use type systems, enums, and constrained inputs to make invalid states impossible to express
- Provide sensible defaults so users do not need to specify every option — make the common case effortless
- Add confirmation dialogs for irreversible destructive actions, and offer undo for reversible ones
- Validate input at the boundary — as early as possible — and provide immediate, specific feedback about what is wrong
- Use linters, formatters, and pre-commit hooks to catch mistakes before they reach code review or production

## Sources

- Nielsen, Jakob. "10 Usability Heuristics for User Interface Design." Nielsen Norman Group, 1994 (updated 2020). Heuristic #5: "Error Prevention." https://www.nngroup.com/articles/ten-usability-heuristics/
- Norman, Don. *The Design of Everyday Things*, revised ed. Basic Books, 2013. ISBN 978-0-465-05065-9. Chapter 5: "Human Error? No, Bad Design."
