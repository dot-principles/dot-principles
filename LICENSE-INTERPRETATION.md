# License Interpretation (Operational Guide)

This document explains how to apply the repository's dual-license model in practice.

> This is an implementation guide for contributors and adopters, not legal advice.

## Glossary (for this guide)

- **distribution**: making material available outside your organization, including public release, private customer delivery, partner sharing, contractor access, package publication, or artifact handoff.
- **internal use**: use only within your organization and legal entity, without sharing outside that boundary.
- **adaptation**: modified, translated, remixed, transformed, or otherwise changed content.
- **attribution**: credit that identifies source, license, and whether you changed the material.

## 1) License scope by path

The authoritative scope is defined by `LICENSE`:

- `principles/` -> **CC BY-SA 4.0**
- Everything outside `principles/` -> **MIT**

If a file outside `principles/` copies substantial text from `principles/`, treat that copied text as CC BY-SA content.

## 2) What you are allowed to do

You may, including commercially:

- Fork this repository.
- Modify any files.
- Add your own namespaces such as `principles/corp/`.
- Use, copy, and redistribute MIT-covered scripts/tooling.
- Share and adapt CC BY-SA-covered principle texts.

## 3) What you must do

### A. If you redistribute MIT-covered parts (outside `principles/`)

- Keep the MIT copyright and license notice.

### B. If you redistribute or adapt `principles/` content (CC BY-SA)

- Give appropriate attribution.
- Provide a link to CC BY-SA 4.0: <https://creativecommons.org/licenses/by-sa/4.0/>.
- Indicate whether changes were made.
- Distribute adaptations under the same license (CC BY-SA 4.0).

## 4) Internal use vs distribution

- `internal use` (no sharing outside your organization): you can freely adapt for local workflows.
- `distribution` (public release or any sharing outside your organization): license obligations apply.

Operational rule: if material leaves your organization, treat it as distribution.

## 5) Mixed-content repositories

It is valid to distribute a repo containing both licenses.

Recommended approach:

- Keep `LICENSE` at repo root.
- Keep this guide (`LICENSE-INTERPRETATION.md`) for contributors.
- Preserve attribution history in modified principle files.
- Do not relicense adapted `principles/` text under closed-only terms.

## 6) Practical compliance checklist

### For developers using this repo

- Check whether your changed files are in `principles/` (CC BY-SA) or not (MIT).
- When editing `principles/`, keep source traces so attribution is easy at release time.
- When copying principle text into new docs/files, mark it as CC BY-SA-derived.

### Before publishing/sharing

- Keep MIT notice for MIT-covered files.
- For CC BY-SA-derived material, include attribution + license link + change note.
- Ensure adapted principle text remains under CC BY-SA 4.0.
- Keep scope explicit: `principles/` is CC BY-SA; other files are MIT unless they embed CC BY-SA text.

## 7) Attribution template (CC BY-SA-derived text)

Use this template when redistributing adapted `principles/` content:

```text
This material includes adapted content from the .principles project
(source: <URL or repo reference>), licensed under CC BY-SA 4.0
(https://creativecommons.org/licenses/by-sa/4.0/).
Changes made: <brief description>.
```

## 8) Examples

### Example A: Fork + private customization

- You fork and add `principles/corp/` for internal use only.
- Outcome: allowed.

### Example B: Publish a modified fork

- You modify files in `principles/` and publish your fork.
- Outcome: allowed, but you must keep attribution, link CC BY-SA, mark changes, and keep adaptations under CC BY-SA.

### Example C: Private customer delivery

- You deliver a private repository/archive containing adapted `principles/` files to a customer.
- Outcome: this is distribution; CC BY-SA obligations apply to the adapted principle text.

### Example D: Reuse install tooling in another project

- You copy `install.sh` and related tooling into your own project.
- Outcome: allowed under MIT with MIT notice retained.

## 9) Maintainer intent

The line in `DISCLAIMER.md` that encourages forking and adaptation is intentional and compatible with both licenses, as long as the obligations above are followed.

## 10) Ownership and curation scope

This project does not claim ownership of underlying engineering principles as ideas.

What this project contributes is curation and expression, including:

- Selection of principles and sources.
- Organization into namespaces, groups, and layers.
- Repository-specific identifiers, structure, and presentation.

Repository-original material is licensed as defined in `LICENSE`.
Source-derived text remains subject to its applicable license terms.






