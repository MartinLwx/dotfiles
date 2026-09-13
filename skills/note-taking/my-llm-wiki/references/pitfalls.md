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

## Patch / Edit Tooling (file-tool fallback only)

Applies when a write falls back to file tools per SKILL.md
body-edit discipline (page >~300 lines, escaping risk, or CLI
unavailable):

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

## Obsidian CLI

- **`create overwrite` is destructive and whole-file** — always
  `read` immediately before (keep the pre-image in context) and
  re-read after. `obsidian history` / `history:restore` is the
  backup of last resort.
- **Single-quote `content` values** — double quotes expose `$`,
  backticks, and history expansion; newlines go in as literal
  `\n` (CLI-interpreted), embedded `'` as `'\''`.
- **Prefer `path=` over `file=`** — `file=` resolves like a
  wikilink and is ambiguous with duplicate basenames; `path=` is
  exact, vault-root-relative (prepend the session REL prefix from
  SKILL.md vault resolution).
- **`property:set` appends NEW keys at the end of frontmatter**
  (existing keys update in place) — order-sensitive fields
  (`tags`, `aliases`, book-template ordering) must be written in
  the `create` content, not patched in afterwards. Lists come out
  as block YAML, numbers stay scalars.
- **`prepend` lands directly after the frontmatter closing `---`**
  — verified; in log.md this is ABOVE the `> 历史日志` nav line
  (accepted; see `operations.md` log.md conventions).
- **CLI needs Obsidian running** — probe `obsidian vault` at
  session start; on failure switch to file tools for the whole
  session (no per-command retrying).
- **Pass `vault="<name>"` explicitly on every command** — the
  default "most recently focused vault" changes under you; pin
  the wiki vault resolved at session start.
