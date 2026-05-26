# CODE-DX-AFFORDANCES-AND-FEEDBACK - Provide clear affordances and feedback

**Layer:** 2
**Categories:** developer-experience, usability, ux-design
**Applies-to:** all
**Summary:** Every interactive element must signal what it does and confirm the effect of every action.

## Principle

Every interactive element should signal what it does (affordance) and confirm what it did (feedback). Affordances are the perceived and actual properties of an object that suggest how it can be used - a button looks pressable, a slider looks draggable, a text field looks typeable. Feedback closes the loop: after the user acts, the system must show the effect of that action. Without affordances, users do not know what to do; without feedback, they do not know whether they did it.

## Why it matters

Norman's key insight is that good design communicates through the object itself, not through labels or manuals. When affordances are clear, users can figure out how to use a system without instruction. When feedback is immediate and visible, users build accurate mental models of how the system works. Poor affordances lead to mode errors (clicking something that looked clickable but was not interactive) and poor feedback leads to repeated actions (clicking a button three times because nothing seemed to happen).

## Violations to detect

- Interactive elements (buttons, links, toggles) that are visually indistinguishable from non-interactive text or decorations
- Actions that complete without any visual, auditory, or textual confirmation
- Flat UI designs where clickable and non-clickable elements have no visual distinction
- CLI commands that produce no output on success (violating the principle of feedback, though "silence is golden" in Unix pipelines has a different rationale)
- Disabled controls with no indication of why they are disabled or how to enable them

## Good practice

- Make interactive elements visually distinct: use cursor changes, hover states, elevation/shadow, and color contrast to signal interactivity
- Provide immediate feedback for every user action - visual state changes, success messages, or progress indicators
- When an element is disabled, communicate why (tooltip, helper text) and what the user can do to enable it
- Use established UI conventions (underlined links, raised buttons, checkboxes) rather than inventing novel interaction patterns that users must learn
- For APIs and CLIs, return meaningful responses for every operation - even a simple "done" is better than silence

## Sources

- Norman, Don. *The Design of Everyday Things*, revised ed. Basic Books, 2013. ISBN 978-0-465-05065-9. Chapters 1-2: "The Psychopathology of Everyday Things" and "The Psychology of Everyday Actions."
