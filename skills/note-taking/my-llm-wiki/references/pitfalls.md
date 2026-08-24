# Pitfalls (Canonical Checklist)

Tool-operation and discipline pitfalls accumulated across wiki
sessions. Only the most fatal few live in SKILL.md; this is the
full checklist. Related rule sets: footnote/coverage rules →
`health-check.md`; page-level rules → `page-patterns.md`; body
style → `writing-style.md`; page splitting → `splitting-pages.md`.

## Sources and Orientation

- **Never modify files in `sources/`** — sources are immutable.
  Corrections go in wiki pages.
- **Always orient first** — read SCHEMA + index + recent log
  before any operation (see SKILL.md Orientation).
- **Always update index.md and log.md** — these are the
  navigational backbone. Index descriptions are authored
  independently of page `summary` fields.

## Patch / Edit Tooling

- **V4A patch can swallow frontmatter `---`** — when a hunk's
  context includes a blank line adjacent to the frontmatter
  closing `---`, the fuzzy matcher may treat `---` as the blank
  line and replace it (log.md corrupts silently, YAML never
  closes). Anchor hunks on unique content lines (e.g. the first
  log entry) instead of blank-line context, and after any patch
  near frontmatter verify the `---` delimiter survives (read the
  first ~12 lines of the file).
- **Adding table rows: never use the adjacent row as `old_string`
  boundary** — include both old and new row in `new_string`, and
  use only the insertion point as `old_string`. Always re-read to
  verify.
- **`replace_all` on substrings of structured lines leaves orphan
  fragments** — when using `patch(replace_all=True)` to strip a
  token like `[^2]` from `[^2]: [[Source]]`, only the substring is
  removed, leaving `: [[Source]]` as a dangling orphan. For
  structured patterns (footnote definitions, table rows, YAML
  keys), remove the entire line, not a substring. Always re-read
  every affected file after substring `replace_all` to check for
  orphans. `sed -i` is more reliable for stripping orphan remnants
  than `patch`.

## Operational Discipline

- **Keep pages scannable** — readable in 30 seconds. Split pages
  over ~200 lines (see `splitting-pages.md`).
- **Unicode smart quotes in source filenames** — macOS/Obsidian
  often produce smart quotes (`'` U+2019). Use shell globbing via
  terminal to handle them.
