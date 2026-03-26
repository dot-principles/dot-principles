# CODE-DX-RECOGNITION-OVER-RECALL — Support recognition over recall in interfaces

**Layer:** 2
**Categories:** developer-experience, usability, ux-design
**Applies-to:** all
**Summary:** Make objects, actions, and options visible so users never need to recall them from memory.

## Principle

Minimize the user's memory load by making objects, actions, and options visible. The user should not have to remember information from one part of the interface to another. Instructions for use should be visible or easily retrievable whenever appropriate. Interfaces should present choices rather than require users to recall commands, parameter names, or sequences from memory.

## Why it matters

Human working memory is limited — people can reliably hold only a few items at a time. Interfaces that require users to remember exact command names, configuration key spellings, or the output from a previous screen impose unnecessary cognitive load. Recognition (seeing and choosing from options) is fundamentally easier than recall (producing the answer from memory), so interfaces that support recognition are faster to use and produce fewer errors.

## Violations to detect

- CLI tools that require memorizing exact command names and flags with no discoverability (no `--help`, no tab completion, no suggestions)
- Configuration files with hundreds of keys that must be typed from memory with no schema validation or autocomplete support
- Wizards or multi-step forms where choices made in earlier steps are not visible in later steps
- APIs that require callers to remember opaque identifiers returned from previous calls with no way to look them up
- Error messages that reference internal codes without explaining what went wrong or what to do

## Good practice

- Provide autocompletion, suggestions, and inline documentation in CLI tools and configuration editors
- Use JSON Schema, TypeScript types, or similar mechanisms to enable IDE autocompletion for configuration files
- In multi-step workflows, display a summary of previous selections so users can verify context without going back
- Offer command palettes, search, and contextual menus that let users browse available actions rather than memorize them
- Provide examples alongside documentation — users recognize correct usage patterns faster than they recall syntax rules

## Sources

- Nielsen, Jakob. "10 Usability Heuristics for User Interface Design." Nielsen Norman Group, 1994 (updated 2020). Heuristic #6: "Recognition Rather Than Recall." https://www.nngroup.com/articles/ten-usability-heuristics/
