---
name: my-llm-wiki
description: "Provides access to the user's personal wiki, including notes, research, project documentation, decisions, and archived knowledge. Use this skill whenever the user wants to: ingest a new source into the wiki, find answers from the existing wiki, perform a health check of the wiki, or apply recurring workflow patterns (book digest planning, base file population, re-digest, taxonomy promotion, survey digests)."
metadata:
  requires_tools: [read, bash, edit, write]
compatibility: |
  Primary interface: the `obsidian` CLI against the wiki's vault
  (requires Obsidian running). Optional CLIs: `defuddle` (web
  capture), `python3` (health-check audit script). When Obsidian
  is not running, vault operations degrade to file tools
  (read/write/edit) with identical semantics.
---

## Wiki Location

Set via `WIKI_PATH` environment variable. Defaults to current
directory. Raise warning if current'directory is not satisfied.

The wiki lives inside an Obsidian vault (plain markdown files — no
database). All vault operations go through the `obsidian` CLI; the
file tools (`read`/`write`/`edit`) are the FALLBACK, not the
default.

## Obsidian CLI — Primary Interface (CRITICAL)

Full command syntax: the `obsidian-cli` skill. Session-specific
rules:

### Session startup — resolve vault + path prefix (once, before Orientation)

1. **Probe**: `obsidian vault`. Not installed / no app running →
   CLI unavailable this session: use file tools for everything
   and say so once. Do not re-probe per command.
2. **Resolve the vault**: `WIKI_PATH` set → match against
   `obsidian vaults` paths; the vault whose root contains
   `WIKI_PATH` wins, and REL = `WIKI_PATH` relative to that root
   (usually empty — the vault root is normally the wiki repo).
   `WIKI_PATH` unset → the focused vault (`obsidian vault`) is
   the wiki vault and REL is empty (its root contains `wiki/` and
   `sources/`); warn if the cwd doesn't look like a wiki.
3. **Pin it**: pass `vault="<name>"` on EVERY command — the
   default "most recently focused vault" changes under you.
4. **Paths are vault-root-relative**: `path=wiki/entity/foo.md`;
   prepend REL when non-empty.

### Operation → command mapping

| Operation | Command |
|:----------|:--------|
| Read page / SCHEMA / index / log | `read path=...` |
| Create a page | `create path=... content=... silent` |
| Body edit (whole-file rewrite) | `read` → transform → `create ... overwrite silent` |
| Frontmatter fields | `property:set` / `property:read` / `property:remove` |
| log.md entry (newest-first) | `prepend path=wiki/log.md content=...` |
| Tail append | `append` |
| Dedupe / locate content | `search` / `search:context` |
| Link-graph checks | `links` / `backlinks` / `orphans` / `deadends` / `unresolved` |
| Rename / move | `rename` / `move` — auto-update inbound wikilinks |
| Delete | `delete` — user confirmation first |
| Query a `.base` board | `base:query` |

### Body-edit discipline

The CLI has no surgical mid-file edit — body changes are always
`read` → transform → `create overwrite`. Therefore:

- **`read` immediately before every `overwrite`** (keep the
  pre-image in context for diff review + recovery) and re-read
  after to verify the landed content.
- **Single-quote `content` values**: newlines as literal `\n`,
  tabs as `\t` (CLI-interpreted), embedded `'` as `'\''`.
  Frontmatter via `property:set` avoids most escaping exposure.
- **Fallback to the `edit` tool** when the page exceeds ~300
  lines or a whole-file rewrite is risky; `write` is for
  capturing new `sources/` files only.

### Guardrails

- **`sources/` is CLI-read-only** — `read` / `search` / `files`
  only; never `create` / `append` / `delete` / `move` / `rename`
  with a `sources/...` target. Exception: the one-time capture of
  a NEW source file (defuddle output, douban metadata) as part of
  ingest.
- **`silent` on every non-interactive `create`** — don't yank the
  user's Obsidian focus.
- **`delete` needs prior user confirmation**; `permanent` only
  for files created within the same session (cleanup).

## Architecture

```
.
├── sources/              # Do not modify. Immutable raw materials.
│   ├── assets/           # Images, diagrams
│   ├── books/            # Book clippings
│   ├── blogs/            # Web articles, clippings
│   ├── documents/        # Official tool documentation
│   ├── papers/           # Academic papers
│   └── products/         # Product information
└── wiki/
    ├── base/             # Obsidian Kanban/Canvas .base files
    ├── entity/           # Specific instances: person, book, project...
    ├── concept/          # Abstract ideas: idea, phenomenon, framework
    ├── synthesis/        # Comparative analyses of ≥2 entities
    ├── SCHEMA.md         # Conventions, structure rules, tag taxonomy
    ├── index.md          # Sectioned content catalog
    ├── log.md            # ACTIVE log for the current quarter (newest-first)
    └── logs/             # Archived quarterly logs (log-YYYY-qN.md)
```

## Orientation — Every Session (CRITICAL)

Always orient yourself before any operation:

0. **Locate the wiki** — resolve `WIKI_PATH`; if unset, default to
   current directory. If it's unsatisfieid, ask the user for 
   the path before anything else — never guess or operate on 
   an empty directory.
1. **Read `./wiki/SCHEMA.md`** — domain, conventions, tag
   taxonomy. If absent: note it and infer conventions from
   existing pages' frontmatter and tag patterns. Never block on a
   missing schema.
2. **Read `./wiki/index.md`** — what pages exist and their
   summaries.
3. **Scan recent `./wiki/log.md`** — last 20–30 entries for
   recent activity. (Historical quarters: `./wiki/logs/`.)

Only after orientation should you ingest, query, or lint. This
prevents duplicate pages, missing cross-references, schema
contradictions, and repeated work.

## The Two-Tag Rule

Every page carries **exactly 2 tags**, no more:

1. **Base-filter tag** — powers Obsidian `.base` file
   `file.hasTag()` filters. Examples: `rust-crate`, `rust-trait`,
   `书籍`, `python-feature`, `container-runtime`.
   **It is a page-TYPE tag**: only pages of that type may carry it
   (e.g. `Python软件包` belongs ONLY on entity pages of Python
   packages — concept pages about a library's internals (channels,
   encodings, grammars) must NOT take it, or the `.base` board
   wrongly collects them).
2. **Functional category tag** — nested `domain/subcategory`
   format. Examples: `软件包/日志`, `语言特性/并发`,
   `容器技术/运行时`, `深度学习/内存优化`.

**Forbidden**: broad standalone tags like `rust`, `python`,
`logging`, `security` — too wide, create noise; 3+ tags on any
page — that's taxonomy, not filtering.

New tags are added to SCHEMA.md's taxonomy table first; see
`references/page-patterns.md` for taxonomy extensions and tag
promotion.

## Workflow Router — Load What You Need

This skill is split for progressive disclosure. SKILL.md is the
router; load the matching reference for your task. Most sessions
need 1–2 references, not the whole skill.

| Task | Load |
|:-----|:-----|
| Ingest a source / re-digest / query / paper notes | `references/operations.md` |
| 开始 digest 一本书 (book clippings) | `references/book-digest.md` |
| Health check after any write | `references/health-check.md` |
| Plan page structure / page anatomy | `references/page-patterns.md` |
| Split a page over ~200 lines | `references/splitting-pages.md` |
| Write body text / Chinese style | `references/writing-style.md` |
| Debug a patch or tooling failure | `references/pitfalls.md` |
| Create / edit an Obsidian `.base` file | `obsidian-bases` skill (external) |
| Obsidian CLI command syntax / flags | `obsidian-cli` skill (external) |

**After any page write: run the health check** (load
`references/health-check.md`) — don't wait to be asked. Expect
failures on first pass; fix → re-check until all pages pass.

## Non-Negotiable Rules

- **Never modify files in `sources/`** — immutable raw material;
  corrections go in wiki pages.
- **Always update index.md and log.md** — the navigational
  backbone. Log entries are newest-first (top of body, after
  frontmatter) and strictly ONE line each:
  `- YYYY-MM-DD | 基于 [[source]] 创建 [[page]]、[[page]]` — date,
  source(s), page names; never expand page contents (see
  `references/operations.md` log.md conventions). New index
  entries are inserted at the end of their section.
- **Every page links to ≥2 other pages** — isolated pages are
  invisible.
- **Exactly 2 tags per page** — base-filter + functional
  category (Two-Tag Rule above).
- No space in the tag
- **代表工作 lists are wiki-only** — on research pages,
  「代表工作 / SOTA 工作」lists may only contain works that have
  their own page in this wiki (wikilink-able). Works without a
  wiki page stay out of the list — cite them in prose with a
  footnote or describe them at category level.
- **Footnotes: inline `[^N]` + page-bottom definitions** — see
  `references/health-check.md` for the full rules.
- **Keep pages scannable** — readable in 30 seconds; split pages
  over ~200 lines (`references/splitting-pages.md`).
- **Summary ≤ 20 chars; INDEX lines ≤ 50 chars** — frontmatter
  `summary` stays within ~20 characters (spaces excluded); each
  `index.md` entry line stays within 50 characters (whole line,
  wikilink and prefix included).
- **Outline approval before any page write** — creating a new
  page or rewriting/restructuring an existing one requires
  presenting the page outline first (frontmatter fields; complete
  section skeleton with planned coverage tags and the
  source→footnote mapping; planned cross-links) and **waiting for
  explicit user approval**. No write until approved. Small
  additive edits still need a one-line plan before writing —
  never write unannounced.
- **Ask before mass-updating** — confirm scope if an ingest would
  touch 10+ existing pages.
- **CLI writes aren't done until verified** — after `create

## References

Supporting files, loaded on demand:

| File | Purpose |
|:-----|:--------|
| `operations.md` | Ingest / re-digest / query / paper notes + log.md conventions |
| `book-digest.md` | Full book-digest workflow (plan-first, naming, hierarchy, douban, vendor-viewpoint) |
| `health-check.md` | Coverage/source_cnt/footnote rules, script usage, false positives |
| `page-patterns.md` | Page anatomy per type + tag taxonomy extensions + page-level rules |
| `splitting-pages.md` | Hub + sub-page split workflow |
| `writing-style.md` | Synthesize-don't-translate, translation-ese, annotation, typography |
| `pitfalls.md` | Canonical tooling/discipline checklist |
| `book-entity-template.md` | Book entity page template |
| `research-page-template.md` | Research synthesis page anatomy |
