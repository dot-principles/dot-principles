# DOC-OBJECTIVE - Write in a neutral, factual tone; eliminate promotional language

**Layer:** 1 (universal)
**Categories:** documentation, readability, trust
**Applies-to:** docs
**Summary:** Use only factual, demonstrable claims and omit marketing adjectives like "easy", "simple", or "powerful".

## Principle

Technical documentation should be factual and neutral. Avoid adjectives and claims that express enthusiasm, relative quality, or ease without supporting evidence: words like `"easy"`, `"simple"`, `"powerful"`, `"seamlessly"`, `"best-in-class"`, and `"robust"` signal marketing copy, not technical content. Every claim in documentation should be demonstrable; if it cannot be shown, it should not be stated.

Objective documentation earns reader trust. Promotional language in technical writing signals that the author's goal is persuasion, not information - and readers adjust their reading posture accordingly, discounting everything that follows.

## Why it matters

Usability research by Morkes and Nielsen (1997) found that rewriting promotional language into objective, factual prose produced a 27% improvement in usability scores. Readers slow down and become more sceptical when they encounter unsupported superlatives. In documentation, where readers are trying to solve a problem, promotional language wastes their attention and erodes confidence in the accuracy of the surrounding content.

## Violations to detect

- Unsupported quality adjectives: `"easy"`, `"simple"`, `"intuitive"`, `"powerful"`, `"robust"`, `"flexible"`, `"best"`, `"seamlessly"`, `"effortlessly"`
- Marketing framing in technical content: `"our industry-leading API"`, `"world-class performance"`, `"delightful developer experience"`
- Unverifiable comparative claims: `"faster than alternatives"`, `"more reliable than X"` with no benchmark or citation
- Hedged non-committal claims: `"may help improve performance in some cases"` that provide no actionable information
- Instructional language that implies the reader is wrong for not already knowing: `"simply run"`, `"just add"`, `"obviously"`

## Inspection

- `grep -rniE "\b(easy|simple|simply|just|obvious|seamless|powerful|robust|flexible|intuitive|effortless|best-in-class|world.class|industry.leading)\b" $TARGET --include="*.md"` | MEDIUM | Promotional or minimising language in documentation

## Good practice

- Replace subjective claims with demonstrable facts: instead of `"simple to configure"`, show a minimal configuration and let the reader judge
- Replace `"simply run X"` with `"run X"` - the qualifier adds no information and patronises readers who find it non-trivial
- If a comparative claim is important, back it with a benchmark, citation, or concrete example
- Reserve emphasis (`**bold**`, `_italic_`) for technical terms and key actions, not for enthusiasm
- Review documentation PRs specifically for promotional language as a distinct pass

## Sources

- Morkes, John and Jakob Nielsen. "Concise, SCANNABLE, and Objective: How to Write for the Web." Nielsen Norman Group, 1997. https://www.nngroup.com/articles/concise-scannable-and-objective-how-to-write-for-the-web/ (accessed 2026-03-22).
- Microsoft. *Microsoft Writing Style Guide*. Microsoft, 2018. https://learn.microsoft.com/en-us/style-guide/welcome/ (accessed 2026-03-22). Section: "Bias-free communication" and "Word choice."
