# A11Y-KEYBOARD-NAVIGATION - Interactive elements must be fully keyboard-accessible

**Layer:** 2 (contextual)
**Audit-scope:** full
**Categories:** accessibility, wcag, html
**Applies-to:** HTML, JSX, TSX, templates
**Summary:** Ensure every interactive element is reachable, activatable, and escapable using keyboard alone.

## Principle

Every interactive element - buttons, links, form controls, modals, dropdowns, tabs - must be reachable and operable using only a keyboard. This means: focusable via Tab/Shift-Tab, activatable via Enter or Space, and escapable via Escape where appropriate. Mouse-only interactions are a hard barrier for users with motor impairments, power users, and anyone relying on keyboard-driven workflows.

## Why it matters

An estimated 7% of working-age adults have a severe dexterity impairment. Beyond accessibility, keyboard operability is a baseline quality bar: screen reader users navigate entirely by keyboard, and advanced users frequently prefer it. WCAG 2.1 SC 2.1.1 Keyboard (Level A) requires that all functionality is available from a keyboard.

## Violations to detect

- `onClick` handler without a corresponding `onKeyDown` or `onKeyPress` on a non-interactive element (div, span, li)
- Interactive elements with `tabIndex="-1"` that are never programmatically focused (unreachable)
- Missing `tabIndex` on custom interactive components not backed by a native focusable element
- Modal dialogs that do not trap focus (Tab cycles outside the modal while it is open)
- Dropdown menus or autocomplete widgets where arrow-key navigation is absent
- `onMouseEnter`/`onMouseLeave` used for content reveal with no `onFocus`/`onBlur` equivalent
- `pointer-events: none` or `visibility: hidden` used to hide elements that are still in the tab order

## Inspection

- `grep -rnE 'onClick\s*=' --include="*.jsx" --include="*.tsx" --include="*.html" $TARGET | grep -v "onKeyDown\|onKeyPress\|onKeyUp\|<button\|<a \|<input\|<select\|<textarea"` | HIGH | onClick on potentially non-focusable element without keyboard handler
- `grep -rnE 'tabIndex\s*=\s*[{"]?-1[}"]?' --include="*.jsx" --include="*.tsx" --include="*.html" $TARGET` | MEDIUM | tabIndex -1 removes element from tab order - verify intentional
- `grep -rnE 'onMouseEnter|onMouseLeave|onMouseOver' --include="*.jsx" --include="*.tsx" $TARGET` | MEDIUM | Mouse-only hover handlers - verify onFocus/onBlur equivalents exist
- `grep -rnE 'role\s*=\s*["'"'"'](button|link|menuitem|tab|checkbox|radio)['"'"'"](?![^>]*tabIndex)' --include="*.jsx" --include="*.tsx" --include="*.html" $TARGET` | HIGH | ARIA interactive role without tabIndex

## Good practice

```jsx
// Bad: mouse-only interaction, not keyboard accessible
<div onClick={openMenu}>Open menu</div>

// Good: native button, keyboard accessible out of the box
<button onClick={openMenu}>Open menu</button>

// Good: if a div must be used (avoid where possible)
<div
  role="button"
  tabIndex={0}
  onClick={openMenu}
  onKeyDown={(e) => (e.key === 'Enter' || e.key === ' ') && openMenu(e)}
>
  Open menu
</div>

// Hover tooltip - also needs focus equivalent
<div
  onMouseEnter={showTooltip}
  onMouseLeave={hideTooltip}
  onFocus={showTooltip}
  onBlur={hideTooltip}
>
  Hover or focus me
</div>
```

- Native `<button>` and `<a href>` elements are keyboard-focusable and activatable by default - prefer them
- For custom widgets (combobox, date picker, tree), follow the WAI-ARIA Authoring Practices keyboard interaction patterns
- Ensure focus indicators are visible (never `outline: none` without a custom replacement)
- Test by unplugging the mouse and navigating the entire UI with Tab, Shift-Tab, Enter, Space, Escape, and arrow keys

## Sources

- W3C. *WCAG 2.1*, SC 2.1.1 Keyboard (Level A). https://www.w3.org/TR/WCAG21/#keyboard
- W3C. *WCAG 2.1*, SC 2.4.3 Focus Order (Level A). https://www.w3.org/TR/WCAG21/#focus-order
- W3C WAI-ARIA Authoring Practices Guide - Keyboard Interaction. https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface/
