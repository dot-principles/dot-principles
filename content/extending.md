# Extending

You do not need to fork this repository to make `.principles` useful for your team.

The built-in catalog is the shared public baseline. Your organization can layer its own principles on top.

## What extension looks like

Create an extra catalog directory that follows the same structure as `principles/` in this repo.

That catalog can contain:

- organization-specific principles
- domain rules that are too local for the shared public catalog
- team conventions backed by your own internal standards

## Register the extra catalog

You can register an extra catalog at several levels:

```bash
# User-level
echo ~/acme-principles >> ~/.principles-extra

# Per-project
echo /shared/acme-principles >> my-project/.principles-extra

# One-off vendoring
./install.sh vendor my-project --extra-catalog ~/acme-principles
```

Corporate and personal catalogs can coexist.

## When to extend instead of contributing upstream

Use an extra catalog when the rule is:

- specific to your company or product
- specific to your domain
- based on an internal standard rather than a published shared source

Contribute upstream when the principle belongs to the public software engineering literature and would help many teams, not just your own.

## Deep reference and examples

- [`templates/extra-catalog/`](https://github.com/dot-principles/dot-principles.github.io/tree/main/templates/extra-catalog)
- [`example-catalog`](https://github.com/dot-principles/example-catalog)
- [`INSTALL.md` §9 — Extra Catalogs](https://github.com/dot-principles/dot-principles.github.io/blob/main/INSTALL.md#9-extra-catalogs)
- [`INSTALL.md` §10 — Installing an Extra Catalog](https://github.com/dot-principles/dot-principles.github.io/blob/main/INSTALL.md#10-installing-an-extra-catalog)
- [`DESIGN.md` section 11](https://github.com/dot-principles/dot-principles.github.io/blob/main/DESIGN.md#-11-adding-a-new-namespace)