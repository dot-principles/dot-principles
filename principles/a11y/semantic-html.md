# A11Y-SEMANTIC-HTML — Use semantic HTML elements; do not build interactive controls from divs

**Layer:** 2 (contextual)
**Audit-scope:** full
**Categories:** accessibility, wcag, html
**Applies-to:** HTML, JSX, TSX, templates

## Principle

Use the HTML element that most precisely describes the content's meaning and role. Do not replace native interactive elements (`<button>`, `<a>`, `<nav>`, `<main>`, `<header>`) with generic `<div>` or `<span>` elements augmented with click handlers and ARIA. Native elements carry built-in keyboard behaviour, focus management, and accessibility semantics that manual ARIA replication invariably gets wrong.

## Why it matters

Assistive technologies rely on the HTML element type and ARIA landmark roles to build a structural model of the page. A `<div>` carrying an `onClick` is invisible to a screen reader as an interactive element, cannot be reached by keyboard, and provides no context about what it does. Recreating the native behaviour manually requires implementing all of: `role`, `tabIndex`, keyboard event handlers, focus styling, and state management — and most implementations miss at least one. Using the right element gives all of this for free.

Relates to WCAG 2.1 SC 1.3.1 Info and Relationships (Level A), SC 2.4.1 Bypass Blocks (Level A), and SC 4.1.2 Name, Role, Value (Level A).

## Violations to detect

- `<div>` or `<span>` with an `onClick` handler but no `role` attribute and no `tabIndex`
- `<div>` used as a navigation menu without `<nav>` or `role="navigation"`
- Page layout with no landmark elements (`<main>`, `<header>`, `<footer>`, `<nav>`, `<aside>`)
- `<div>` used as a button (`<div class="btn" onClick=...>`) instead of `<button>`
- `<div>` or `<span>` used as a heading instead of `<h1>`–`<h6>`
- Form controls built from `<div>` without matching `role="checkbox"`, `role="radio"`, etc.
- Tables used for layout rather than for tabular data

## Inspection

- `grep -rnE '<div[^>]*onClick' --include="*.html" --include="*.jsx" --include="*.tsx" --include="*.vue" $TARGET` | HIGH | Clickable div — use button or anchor instead
- `grep -rnE '<span[^>]*onClick' --include="*.html" --include="*.jsx" --include="*.tsx" $TARGET` | HIGH | Clickable span — use button instead
- `grep -rnE '<div[^>]*class\s*=\s*["'"'"'][^"'"'"']*\b(btn|button|link|nav-item)\b' --include="*.html" --include="*.jsx" --include="*.tsx" $TARGET` | MEDIUM | Div styled as interactive element
- `grep -rnE '<(main|header|footer|nav|aside)' --include="*.html" --include="*.jsx" --include="*.tsx" $TARGET` | INFO | Verify landmark elements are present for page structure

## Good practice

```jsx
// Bad: div reimplementing button behaviour
<div
  className="btn"
  onClick={handleSubmit}
  style={{ cursor: 'pointer' }}
>
  Submit
</div>

// Good: native button with built-in keyboard support, focus, and semantics
<button type="submit" onClick={handleSubmit}>
  Submit
</button>

// Page structure with landmarks
<header>...</header>
<nav aria-label="Main navigation">...</nav>
<main>
  <h1>Page title</h1>
  ...
</main>
<footer>...</footer>
```

- Prefer `<button>` for actions that do not change the URL; prefer `<a href>` for navigation
- Use heading levels (`<h1>`–`<h6>`) to communicate document hierarchy, not to control font size
- Use `<ul>`/`<ol>` for lists, `<table>` for tabular data, `<form>` for forms
- Add ARIA only where native HTML semantics are genuinely insufficient; `aria-` is a patch, not a substitute

## Sources

- W3C. *WCAG 2.1*, SC 1.3.1 Info and Relationships (Level A). https://www.w3.org/TR/WCAG21/#info-and-relationships
- W3C. *WCAG 2.1*, SC 4.1.2 Name, Role, Value (Level A). https://www.w3.org/TR/WCAG21/#name-role-value
- W3C WAI-ARIA Authoring Practices. https://www.w3.org/WAI/ARIA/apg/
