# A11Y-COLOR-CONTRAST - Text must meet minimum contrast ratio against its background

**Layer:** 2 (contextual)
**Audit-scope:** limited
**Categories:** accessibility, wcag, css
**Applies-to:** CSS, SCSS, styled-components, inline styles
**Summary:** Ensure normal text meets 4.5:1 contrast ratio and large text meets 3:1 against its background.

## Principle

Normal text (below 18pt / 14pt bold) must have a contrast ratio of at least **4.5:1** against its background. Large text (18pt+ / 14pt+ bold) and UI component boundaries must meet **3:1**. Hardcoded color values that do not meet these thresholds are auditable statically; dynamic theming and computed styles require rendering-time evaluation.

## Why it matters

Low contrast is one of the most common accessibility failures and affects a large audience: approximately 8% of males have some form of colour vision deficiency, and contrast issues worsen for all users in bright sunlight, on low-end displays, or as users age. WCAG 2.1 SC 1.4.3 Contrast Minimum (Level AA) specifies the 4.5:1 threshold as the minimum for legal conformance in many jurisdictions.

**Audit-scope: limited.** Static analysis can flag suspicious hardcoded pairs and near-white-on-white or near-black-on-black values, but definitive contrast evaluation requires the rendered text color and background color in context, including inheritance, overlays, and gradients.

## Violations to detect

- Light-grey text on white backgrounds (e.g., `color: #aaa` on `background: #fff` - ratio ≈ 2.3:1)
- White text on light-coloured backgrounds without sufficient contrast
- Placeholder text styled the same as regular input text but at reduced opacity (`opacity: 0.4`)
- Disabled UI elements styled with very low contrast and still conveying meaningful information
- Icon-only controls with no background differentiation (icon colour too close to background)
- `color` and `background-color` set to values that are visually similar in the same rule or nearby rules

## Inspection

- `grep -rnE 'color\s*:\s*#[89a-fA-F][0-9a-fA-F]{5}' --include="*.css" --include="*.scss" --include="*.sass" $TARGET` | MEDIUM | Light colour value - verify contrast ratio against background
- `grep -rnE 'color\s*:\s*(#[c-fC-F][0-9a-fA-F]{5}|rgba?\([^)]*0\.[1-3][^)]*\))' --include="*.css" --include="*.scss" $TARGET` | MEDIUM | Very light or low-opacity text color - likely low contrast
- `grep -rnE 'color\s*:\s*#(?:aaa|bbb|ccc|999|888)[^0-9a-f]' -i --include="*.css" --include="*.scss" $TARGET` | HIGH | Known low-contrast grey shorthand value
- `grep -rnE 'opacity\s*:\s*0\.[1-4][^0-9]' --include="*.css" --include="*.scss" $TARGET` | MEDIUM | Low opacity applied to text - verify resulting contrast

## Good practice

```css
/* Bad: #767676 on white is exactly at the 4.5:1 threshold - avoid values lighter than this */
.caption {
  color: #999; /* ratio ~2.8:1 on white - fails */
}

/* Good: dark enough to pass 4.5:1 on white */
.caption {
  color: #595959; /* ratio ~7:1 on white - passes AA and AAA */
}

/* Large text (18pt+): 3:1 minimum */
h1 {
  color: #767676; /* ratio 4.5:1 on white - passes for large text */
}
```

- Use a contrast checker (WebAIM Contrast Checker, browser DevTools accessibility panel, axe) to verify every text/background pair
- Design tokens and a centralised palette make systematic contrast review possible; ad-hoc inline colours make it nearly impossible
- Do not rely solely on colour to convey information (SC 1.4.1 Use of Color) - always provide a secondary indicator (icon, label, pattern, underline)
- Ensure focus indicator contrast also meets 3:1 against adjacent colours (SC 1.4.11, Level AA)

## Sources

- W3C. *WCAG 2.1*, SC 1.4.3 Contrast (Minimum) (Level AA). https://www.w3.org/TR/WCAG21/#contrast-minimum
- W3C. *WCAG 2.1*, SC 1.4.11 Non-text Contrast (Level AA). https://www.w3.org/TR/WCAG21/#non-text-contrast
- WebAIM. *Contrast Checker*. https://webaim.org/resources/contrastchecker/
