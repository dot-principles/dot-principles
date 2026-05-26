# DOC-TASK-ORIENTED - Organise documentation around user tasks, not product features

**Layer:** 2 (contextual)
**Categories:** documentation, usability, information-architecture
**Applies-to:** docs
**Summary:** Structure documentation around user goals expressed as tasks, not around internal product components.

## Principle

Documentation should be structured around what users need to accomplish, not around how the product is organised internally. Headings, sections, and navigation should reflect user goals expressed as tasks (`"Authenticate a user"`, `"Deploy to production"`) rather than product features or system components (`"Authentication"`, `"Deployment Module"`). The structure of the documentation is the structure of the user's work, not the structure of the codebase.

## Why it matters

Feature-oriented documentation forces users to understand the product's internal structure before they can find the information they need. A user trying to accomplish a task must first learn how the product categorises its own features, then map their goal onto that taxonomy - cognitive work the documentation should do for them. Task-oriented documentation meets users where they are: at the point of a goal, not a feature.

## Violations to detect

- Top-level navigation or section headings that mirror the product's module or component names rather than user goals
- Headings phrased as nouns (`"Configuration"`, `"Authentication"`, `"Permissions"`) where the section is actually procedural and could be phrased as a task verb
- A table of contents that lists features exhaustively but provides no grouping by user scenario or task
- Reference material mixed into task-oriented sections, forcing users to parse both types to extract the procedure
- Getting-started guides structured as a feature tour rather than a sequence of tasks producing a working result

## Inspection

- `grep -rn "^## [A-Z][a-z]*$\|^### [A-Z][a-z]*$" $TARGET --include="*.md"` | LOW | Single-word noun headings that may be feature-oriented rather than task-oriented

## Good practice

- Write headings as verb phrases that complete the sentence "How to…" or "I want to…" - `"Configure rate limiting"` rather than `"Rate Limiting"`
- Group documentation by user scenario or job-to-be-done; keep feature reference in a separate, clearly labelled reference section
- Validate structure by asking: can a new user read the table of contents and understand what they can accomplish, without knowing what the product is?
- Separate procedural (how-to) from descriptive (reference) content; each type implies a different heading vocabulary

## Sources

- Carey, Michelle et al. *Developing Quality Technical Information: A Handbook for Writers and Editors*, 3rd ed. IBM Press, 2014. ISBN 978-0133118971. Chapter 2: "Task orientation."
- Procida, Daniele. "Diátaxis - A systematic approach to technical documentation authoring." https://diataxis.fr (accessed 2026-03-22).
