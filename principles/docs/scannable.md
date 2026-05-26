# DOC-SCANNABLE - Structure documents so readers can navigate without reading every word

**Layer:** 1 (universal)
**Categories:** documentation, readability, usability
**Applies-to:** docs
**Summary:** Use descriptive headings, short paragraphs, and bold anchors so readers can locate information by scanning.

## Principle

Readers of technical documentation do not read linearly - they scan for the section relevant to their current goal. Documentation should support scanning by using descriptive headings, short paragraphs, bullet lists for enumerable items, and bold text to anchor key terms. A reader who skims the headings and first sentences of paragraphs should be able to locate the information they need without reading everything.

## Why it matters

Usability research by Morkes and Nielsen (1997) found that restructuring web content to be more scannable produced a 47% improvement in usability scores. Walls of undifferentiated prose force readers to read linearly to find a single fact, making documentation slower to use and more likely to be abandoned. In technical documentation, where users arrive with a specific question, poor scannability directly translates to wasted time and increased support burden.

## Violations to detect

- Paragraphs longer than 5-6 sentences without a visual break
- Sections of more than 300 words with no heading, subheading, or list to break them up
- A list of three or more parallel items written as a comma-separated sentence rather than a bulleted list
- Headings that are questions or vague labels (`"More details"`, `"Overview"`) that don't tell the scanner what the section contains
- No use of bold or emphasis to anchor the key term or action in a paragraph
- Step-by-step instructions written as prose rather than a numbered list

## Inspection

- `awk '/^[^#\-\*\n]/{lines++} /^$/{if(lines>6) print FILENAME": paragraph of "lines" lines near line "NR; lines=0} END{if(lines>6) print FILENAME": paragraph of "lines" lines at end"}' $TARGET/*.md` | LOW | Long prose paragraphs with no visual breaks
- `grep -rn "^## \|^### " $TARGET --include="*.md" -c` | INFO | Heading density per file - low counts suggest insufficient structure

## Good practice

- Use descriptive headings that name the concept or action covered, not generic labels
- Break any list of three or more parallel items into a bulleted list
- Keep paragraphs to one idea; aim for 3-5 sentences
- Bold the key term or action on first use in a section to anchor scanning
- Use numbered lists for sequential steps; use bullet lists for unordered sets
- Write the most important sentence first in each paragraph (inverted pyramid within paragraphs)

## Sources

- Morkes, John and Jakob Nielsen. "Concise, SCANNABLE, and Objective: How to Write for the Web." Nielsen Norman Group, 1997. https://www.nngroup.com/articles/concise-scannable-and-objective-how-to-write-for-the-web/ (accessed 2026-03-22).
- Carey, Michelle et al. *Developing Quality Technical Information: A Handbook for Writers and Editors*, 3rd ed. IBM Press, 2014. ISBN 978-0133118971. Chapter 6: "Visual effectiveness."
