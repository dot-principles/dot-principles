# PTAC-LEAN-CONTENT — Lean Content

**Layer:** 1
**Categories**: content, readability, token-efficiency
**Applies-to**: all
**Summary:** Keep plain-text content DRY and front-loaded; every line must earn its place.

## Principle

Put the most critical information — the decision, constraint, or summary — first.
Cut any sentence that doesn't change a reader's understanding or action.
Link to one canonical source rather than repeating the same fact across files.

AI language models suffer from degraded recall for content buried in the middle of long documents. Human readers skim from the top. Both share the same constraint: attention and context windows are finite and degrade with length.

**The test:** Can the first three lines tell an AI agent what this document is about and what action it implies?

## Why it matters

Token budgets are finite and costly. Verbose documents inflate AI context, increase error rates, and slow human reviewers. DRY documents reduce maintenance: the same fact in two places creates two divergence risks. Front-loaded documents ensure the most important content survives truncation, skimming, or context-window overflow.

## Violations to detect

- Key decision, constraint, or summary buried after lengthy preamble
- The same information stated in multiple files without a canonical source
- Background or context section longer than the actionable content it introduces
- Filler sentences that don't change understanding ("This section describes...", "As mentioned above...")
- Files over 200 lines that could be split or trimmed without losing meaning

## Good practice

```
# Front-load                         # Avoid burying the lead
✅ Decision/summary (line 1–3)       ❌ Background (10 lines)
   Constraints and rationale              Context (5 lines)
   Examples only if non-obvious           History (5 lines)
                                          THE ACTUAL DECISION (line 25)
```

## Sources

- LeanSpec First Principles: [Context Economy and Signal-to-Noise](https://www.lean-spec.dev/docs/advanced/first-principles)
- Nelson Liu et al., "Lost in the Middle: How Language Models Use Long Contexts", arXiv:2307.03172, 2023.
