# CODE-DX-SYSTEM-STATUS-VISIBILITY — Provide clear visibility of system status

**Layer:** 2
**Categories:** developer-experience, usability, ux-design
**Applies-to:** all
**Summary:** Always inform users what the system is doing through timely, appropriate feedback.

## Principle

The system should always keep users informed about what is going on, through appropriate feedback within reasonable time. When a user initiates an action, the system must indicate that the action was received, show progress if the operation takes time, and clearly communicate the outcome — success, failure, or partial completion. Silence is the worst response a system can give.

## Why it matters

When users cannot see what the system is doing, they lose trust and make mistakes. They retry operations that are still in progress, navigate away from pages that are loading, or assume success when an error occurred silently. Visible system status reduces user anxiety, prevents duplicate actions, and enables users to make informed decisions about what to do next.

## Violations to detect

- Long-running operations with no progress indicator or loading state
- Form submissions that provide no feedback after the user clicks submit
- Background processes or builds that fail silently without surfacing errors to the user
- API calls or CLI commands that produce no output during processing and then dump results all at once
- Dashboards or status pages that show stale data without indicating when the data was last refreshed

## Good practice

- Show immediate acknowledgment when a user action is received (spinner, progress bar, "saving..." text)
- For long-running tasks, provide progress updates with estimates when possible
- Clearly distinguish between "in progress," "succeeded," and "failed" states — use visual differentiation (color, icons) and text
- Display timestamps on data to make freshness visible (e.g., "last updated 2 minutes ago")
- For CLI tools, provide verbose and quiet modes so users can choose their level of visibility

## Sources

- Nielsen, Jakob. "10 Usability Heuristics for User Interface Design." Nielsen Norman Group, 1994 (updated 2020). Heuristic #1: "Visibility of System Status." https://www.nngroup.com/articles/ten-usability-heuristics/
