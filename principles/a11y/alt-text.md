# A11Y-ALT-TEXT — Images must have meaningful alternative text

**Layer:** 2 (contextual)
**Audit-scope:** full
**Categories:** accessibility, wcag, html
**Applies-to:** HTML, JSX, TSX, templates
**Summary:** Provide meaningful alt text for every informative image; use empty alt="" for decorative images.

## Principle

Every informative image must have an `alt` attribute that conveys the same information a sighted user would get from the image. Decorative images must have an empty `alt=""` so screen readers skip them. An absent `alt` attribute is always a violation; an empty `alt` on an informative image is equally harmful.

## Why it matters

Screen readers and other assistive technologies cannot interpret pixel content. Users who are blind, have low vision, or have images disabled rely entirely on alternative text to understand what an image communicates. Missing or misleading `alt` text makes content inaccessible or actively confusing, and fails WCAG 2.1 Success Criterion 1.1.1 (Level A) — the minimum accessibility conformance level.

## Violations to detect

- `<img>` elements with no `alt` attribute at all
- `<img>` with `alt=""` when the image conveys meaning (charts, photos of people, icons used as the sole label for an action)
- `<img>` with `alt` text that is a filename, URL, or generic phrase (`"image"`, `"photo"`, `"icon"`)
- Icon-only buttons or links where the icon has no `aria-label` and no adjacent visible text
- CSS `background-image` used to display content images rather than decoration (cannot have alt text)
- `<input type="image">` without an `alt` attribute describing the button action

## Inspection

- `grep -rnE '<img(?![^>]*\balt\s*=)[^>]*>' --include="*.html" --include="*.jsx" --include="*.tsx" --include="*.vue" --include="*.svelte" $TARGET` | HIGH | img element missing alt attribute entirely
- `grep -rnE '<img[^>]*alt\s*=\s*["'"'"']\s*["'"'"'][^>]*>' --include="*.html" --include="*.jsx" --include="*.tsx" $TARGET` | MEDIUM | img with empty alt — verify image is decorative
- `grep -rnE 'alt\s*=\s*["'"'"'](image|photo|picture|icon|logo|img)\b' -i --include="*.html" --include="*.jsx" --include="*.tsx" $TARGET` | MEDIUM | Generic or meaningless alt text

## Good practice

```html
<!-- Informative image: describe what the image communicates -->
<img src="revenue-chart.png" alt="Monthly revenue grew 40% from Jan to Jun 2024" />

<!-- Decorative image: explicitly empty alt so screen readers skip it -->
<img src="divider.png" alt="" role="presentation" />

<!-- Icon button: label the action, not the icon -->
<button aria-label="Close dialog">
  <svg aria-hidden="true" focusable="false">...</svg>
</button>
```

- Write `alt` text that describes the *purpose* or *information*, not the visual appearance
- Do not start `alt` text with "Image of" or "Picture of" — screen readers already announce it as an image
- For complex images (charts, diagrams), either include a full text description nearby or use `aria-describedby` pointing to an explanation
- Audit with a screen reader (NVDA, JAWS, VoiceOver) or the axe browser extension

## Sources

- W3C. *Web Content Accessibility Guidelines (WCAG) 2.1*, Success Criterion 1.1.1 Non-text Content (Level A). https://www.w3.org/TR/WCAG21/#non-text-content
- W3C WAI. *Images Tutorial*. https://www.w3.org/WAI/tutorials/images/
