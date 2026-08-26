---
name: my-llm-wiki
description: "Provides access to the user's personal wiki, including notes, research, project documentation, decisions, and archived knowledge. Use this skill whenever the user wants to: ingest a new source into the wiki, find answers from the existing wiki, perform a health check of the wiki, or apply recurring workflow patterns (book digest planning, base file population, re-digest, taxonomy promotion, survey digests)."
metadata:
  requires_tools: [read, bash, edit, write]
compatibility: |
  Requires optional CLIs: `defuddle` (web capture), `obsidian` (orphan/vault
  queries), `python3` (health-check audit script). Operations degrade
  gracefully when any is absent.
---

## Wiki Location

Set via `WIKI_PATH` environment variable. Defaults to current
directory. Raise warning if current'directory is not satisfied.

The wiki is a directory of markdown files. No database, no special
tooling required.

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

**After any page write: run the health check** (load
`references/health-check.md`) — don't wait to be asked. Expect
failures on first pass; fix → re-check until all pages pass.

## Non-Negotiable Rules

- **Never modify files in `sources/`** — immutable raw material;
  corrections go in wiki pages.
- **Always update index.md and log.md** — the navigational
  backbone. Log entries are newest-first (top of body, after
  frontmatter). New index entries are inserted at the end of
  their section.
- **Every page links to ≥2 other pages** — isolated pages are
  invisible.
- **Exactly 2 tags per page** — base-filter + functional
  category (Two-Tag Rule above).
- **Footnotes: inline `[^N]` + page-bottom definitions** — see
  `references/health-check.md` for the full rules.
- **Keep pages scannable** — readable in 30 seconds; split pages
  over ~200 lines (`references/splitting-pages.md`).
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
